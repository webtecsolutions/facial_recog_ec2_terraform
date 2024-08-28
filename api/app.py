from fastapi import FastAPI
from pydantic import BaseModel
from deepface import DeepFace
from typing import Dict

app = FastAPI()

# Define a Pydantic model for the request body
class ImagePaths(BaseModel):
    img1_path: str
    img2_path: str

@app.post("/verify")
async def verify_faces(image_paths: ImagePaths) -> Dict[str, str]:
    try:
        # Perform face verification using the provided image paths
        result = DeepFace.verify(
            img1_path=image_paths.img1_path,
            img2_path=image_paths.img2_path
        )
        print("Same person",flush=True) if result["verified"] else print("Different persons", flush=True)
        # Return the result as a JSON response
        if result["verified"]:
            return {"message": "Both are the same person", "verified" : "True"}
        else:
            return {"message": "Both are different persons","verified" : "False"}
    except Exception as e:
        print(e)
        return {"message": "No Face Found "  + str(e), "verified" : "False"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app)