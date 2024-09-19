from pydantic import BaseModel
from typing import Optional

# Define a Pydantic model for the request body
class ImagePaths(BaseModel):
    img1_path: str
    img2_path: str

class GroupImagePaths(BaseModel):
    img1_path: str
    group_image_paths: list

class ImageComparisonResult(BaseModel):
    message: str
    verified: bool

class ImageVerificationResult(BaseModel):
    message: str
    verified: bool
    match_image: Optional[str] = None   # For cases where a match is found
    error_image: Optional[str] = None   # For cases where an error occurred during indexing