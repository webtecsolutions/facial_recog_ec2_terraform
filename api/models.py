from pydantic import BaseModel

# Define a Pydantic model for the request body
class ImagePaths(BaseModel):
    img1_path: str
    img2_path: str

class GroupImagePaths(BaseModel):
    img1_path: str
    group_image_paths: list