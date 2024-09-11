from fastapi import FastAPI
from pydantic import BaseModel
from deepface import DeepFace
from typing import Dict

import os
import requests

app = FastAPI()

# Define a Pydantic model for the request body
class ImagePaths(BaseModel):
    img1_path: str
    img2_path: str

def download_from_url(url, download_path):
    try:
        response = requests.get(url)
        if response.status_code == 200:
            with open(download_path, 'wb') as f:
                f.write(response.content)
        else:
            print(f"Failed to download image from {url}. Status code: {response.status_code}")
            return None
    except Exception as e:
        print(f"Error downloading image from {url}: {e}")
        return None

def delete_local_file(file_path):
    try:
        if os.path.exists(file_path):
            os.remove(file_path)
    except Exception as e:
        print(f"Error deleting file {file_path}: {e}")

@app.post("/verify")
async def verify_faces(image_paths: ImagePaths) -> Dict[str, str]:
    
    img1_key = image_paths.img1_path
    img2_key = image_paths.img2_path


    img1_path = "images/" + "img1.jpg"
    img2_path = "images/" + "img2.jpg"

    if not os.path.exists("images"):
        os.makedirs("images")
        print("Directory created",flush=True)

    # Download images from url
    download_from_url(img1_key, img1_path)
    download_from_url(img2_key, img2_path)

    # check if images are downloaded
    if not os.path.exists(img1_path):
        return {"status": "failure", "message": "Image 1 not found"}
    if not os.path.exists(img2_path):
        return {"status": "failure", "message": "Image 2 not found"}

    try:
        # Perform face verification using the provided image paths
        result = DeepFace.verify(
            img1_path=img1_path,
            img2_path=img2_path,
            model_name="SFace"

        )
        print("Same person",flush=True) if result["verified"] else print("Different persons", flush=True)
        # Delete the local files after the verification is done
        delete_local_file(img1_path)
        delete_local_file(img2_path)
        # Return the result as a JSON response
        if result["verified"]:
            return {"message": "Both are the same person", "verified" : "True"}
        else:
            return {"message": "Both are different persons","verified" : "False"}
    except Exception as e:
        print(e)
        delete_local_file(img1_path)
        delete_local_file(img2_path)
        return {"message": "No Face Found "  + str(e), "verified" : "False"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app)