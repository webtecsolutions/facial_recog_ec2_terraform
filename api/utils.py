import os
import requests
from deepface import DeepFace

def check_and_create_dir(dir_path):
    """Check if a directory exists and create it if it doesn't."""
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)
        print(f"Directory created: {dir_path}")

def download_from_url(url, download_path):
    """Download an image from a URL."""
    try:
        response = requests.get(url)
        if response.status_code == 200:
            with open(download_path, 'wb') as f:
                f.write(response.content)
            return {"status": "success", "path": download_path}
        else:
            print(f"Failed to download image from {url}. Status code: {response.status_code}")
            return {"status": "failure", "path": None}   
    except Exception as e:
        print(f"Error downloading image from {url}: {e}")
        return {"status": "failure", "path": None}  


def delete_local_file(file_path):
    """Delete a file from the local"""
    try:
        if os.path.exists(file_path):
            os.remove(file_path)
    except Exception as e:
        print(f"Error deleting file {file_path}: {e}")

def download_new_images(image_list):
    """Download new images from a list of URLs."""
    new_image_paths = {}
    for i, img_key in enumerate(image_list):
        img_path = "images/" + f"img{i+2}.jpg"
        result = download_from_url(img_key, img_path)
        if result["status"] == "failure":
            return {"status": "failure", "new_image_paths": new_image_paths}
        new_image_paths[img_key] = img_path
    return {"status": "success", "new_image_paths": new_image_paths}

def delete_new_images(image_dict):
    """Delete new images from the local."""
    for img_key, img_path in image_dict.items():
        delete_local_file(img_path)
    return

def anti_spoofing_user_image(image_path):
    """Perform anti-spoofing check on the user image."""
    try:
        embedding_objs = DeepFace.extract_faces(
            img_path = image_path,
            anti_spoofing = True
        )
        for embedding_obj in embedding_objs:
            if embedding_obj['is_real'] == False:
                return False
        return True
    except Exception as e:
        print(f"Error performing anti-spoofing check: {e}")
        return None

def prepare_image(model_name, image_dict):
    """Prepare images for indexing."""
    embedded_docs = []
    for image_key, image_path in image_dict.items():
        embedding_objs = []
        try:
            embedding_objs = DeepFace.represent(
                img_path = image_path,
                model_name=model_name
            )
        except Exception as e:
            print(f"Error preparing image {image_key}: {e}")
            # return image_key
            embedding_objs = DeepFace.represent(
                img_path = image_path,
                model_name=model_name,
                enforce_detection=False
            )
        embedding = embedding_objs[0]['embedding']
        doc = {
            'embedding': embedding,
            'unique_url': image_key,
            'id': image_key,
        }
        embedded_docs.append(doc)
    return embedded_docs

def prepare_data_for_indexing(docs, index):
    """Prepare data for indexing in OpenSearch."""
    for i in range(len(docs)):
        docs[i]["_index"] = index
    return docs

def get_query_vector(model_name, image_path):
    """Get the query vector for the user image."""
    try:
        embedding_objs = DeepFace.represent(
            img_path = image_path,
            model_name=model_name
        )
        embedding = embedding_objs[0]['embedding']
        return embedding
    
    except Exception as e:
        print(f"Error getting query vector: {e}")
        return None
    
def parse_search_result(result):
    """Parse the search result and return the response."""
    hits = result["distances"][0][0]
    print(hits)
    print(result["ids"][0][0])
    if hits < 0.4:
        return result["ids"][0][0]
    else:
        return None