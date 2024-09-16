from fastapi import FastAPI
from deepface import DeepFace
from typing import Dict

from models import ImagePaths, GroupImagePaths
from utils import (
    check_and_create_dir,
    download_from_url,
    delete_local_file,
    download_new_images,
    prepare_image,
    delete_new_images,
    prepare_data_for_indexing,
    get_query_vector,
    parse_search_result,
    anti_spoofing_user_image
)
from opensearch_service import (
    create_opensearch_client,
    create_knn_index,
    index_data,
    search_knn_index,
    check_images_exist,
)

# Create an OpenSearch client
client = create_opensearch_client()
# Create an index in OpenSearch for the face verification
index_name = "facial-recog-index"
create_knn_index(client, index_name)

model_name = "SFace"

app = FastAPI()

@app.post("/verify")
async def verify_faces(image_paths: ImagePaths) -> Dict[str, str]:
    
    img1_key = image_paths.img1_path
    img2_key = image_paths.img2_path


    img1_path = "images/" + "img1.jpg"
    img2_path = "images/" + "img2.jpg"

    check_and_create_dir("images")

    # Download images from url
    download_result = download_from_url(img1_key, img1_path)
    if download_result["status"] == "failure":
        return {"message": "Error downloading User Image. Invalid Link.", "verified" : "False"}
    download_result = download_from_url(img2_key, img2_path)
    if download_result["status"] == "failure":
        return {"message": "Error downloading Reference Image. Invalid Link.", "verified" : "False"}
    
    # Perform anti-spoofing check on the user image
    anti_spoofing_result = anti_spoofing_user_image(img1_path)
    if anti_spoofing_result is None:
        delete_local_file(img1_path)
        return {"message": "No faces detected in User Image", "verified" : "False"}
    elif anti_spoofing_result == False:
        delete_local_file(img1_path)
        return {"message": "User Image is a spoof image", "verified" : "False"}
    else:
        print("User Image is a real image")

    try:
        # Perform face verification using the provided image paths
        result = DeepFace.verify(
            img1_path=img1_path,
            img2_path=img2_path,
            model_name=model_name

        )
        print("Same person",flush=True) if result["verified"] else print("Different persons", flush=True)
        # Delete the local files after the verification is done
        delete_local_file(img1_path)
        delete_local_file(img2_path)
        # Return the result as a JSON response
        if result["verified"]:
            return {"message": "User Recognised.", "verified" : "True"}
        else:
            return {"message": "User Not Recognized","verified" : "False"}
    except Exception as e:
        print(e)
        delete_local_file(img1_path)
        delete_local_file(img2_path)
        return {"message": "No faces detected in User Image"  + str(e), "verified" : "False"}
    
@app.post("/group_verify")
async def group_verify_faces(image_paths: GroupImagePaths) -> Dict[str, str]:
    
    img1_key = image_paths.img1_path
    group_image_keys = image_paths.group_image_paths

    check_and_create_dir("images")

    # Download User image from url
    img1_path = "images/" + "img1.jpg"
    download_result = download_from_url(img1_key, img1_path)
    if download_result["status"] == "failure":
        return {"message": "Error downloading User Image. Invalid Link.", "verified" : "False"}

    # Perform anti-spoofing check on the user image
    anti_spoofing_result = anti_spoofing_user_image(img1_path)
    if anti_spoofing_result is None:
        delete_local_file(img1_path)
        return {"message": "No faces detected in User Image", "verified" : "False"}
    elif anti_spoofing_result == False:
        delete_local_file(img1_path)
        return {"message": "User Image is a spoof image", "verified" : "False"}
    else:
        print("User Image is a real image")

    # Download Group images from url
    new_image_keys = check_images_exist(client, index_name, group_image_keys)
    new_image_paths = {}
    if new_image_keys is not None:  
        download_result = download_new_images(new_image_keys)
        new_image_paths = download_result["new_image_paths"]
        if download_result["status"] == "failure":
            delete_new_images(new_image_paths)
            return {"message": "Error downloading Group Images. Invalid Link.", "verified" : "False"}
        docs = prepare_image(model_name, new_image_paths)
        if isinstance(docs, str):
            delete_local_file(img1_path)
            delete_new_images(new_image_paths)
            return {"message": "Error Indexing image. No face found in the image", "error_image":f"{docs}","verified" : "False"}
        index_docs = prepare_data_for_indexing(docs, index_name)
        response = index_data(client, index_docs)
        print(response) 

    # Get the query vector for the user image
    query_embedding = get_query_vector(model_name, img1_path)
    if query_embedding is None:
        delete_local_file(img1_path)
        delete_new_images(new_image_paths)
        return {"message": "No faces detected in the User image", "verified" : "False"}
    
    search_result = search_knn_index(client, index_name, query_embedding, group_image_keys)
    print(search_result)
    delete_local_file(img1_path)
    delete_new_images(new_image_paths)

    # Parse the search result and return the response
    result = parse_search_result(search_result)
    if result is None:
        return {"message": "User Not Recognized. No match found", "verified" : "False"}
    return {"message": f"User Recognized. Match found", "match_image": result[0], "verified" : "True"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app)