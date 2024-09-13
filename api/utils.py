import os
import requests
from deepface import DeepFace

def check_and_create_dir(dir_path):
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)
        print(f"Directory created: {dir_path}")

def download_from_url(url, download_path):
    try:
        response = requests.get(url)
        if response.status_code == 200:
            with open(download_path, 'wb') as f:
                f.write(response.content)
        else:
            print(f"Failed to download image from {url}. Status code: {response.status_code}")
    except Exception as e:
        print(f"Error downloading image from {url}: {e}")


def delete_local_file(file_path):
    try:
        if os.path.exists(file_path):
            os.remove(file_path)
    except Exception as e:
        print(f"Error deleting file {file_path}: {e}")

def download_new_images(image_list):
    new_image_paths = {}
    for i, img_key in enumerate(image_list):
        img_path = "images/" + f"img{i+2}.jpg"
        download_from_url(img_key, img_path)
        new_image_paths[img_key] = img_path
    return new_image_paths

def delete_new_images(image_dict):
    for img_key, img_path in image_dict.items():
        delete_local_file(img_path)
    return

def anti_spoofing_user_image(image_path):
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

def prepare_image(image_dict):
    embedded_docs = []
    for image_key, image_path in image_dict.items():
        try:
            embedding_objs = DeepFace.represent(
                img_path = image_path,
                model_name='SFace'
            )
            embedding = embedding_objs[0]['embedding']
            doc = {
                'embedding': embedding,
                'unique_url': image_key,
                '_id': image_key,
            }
            embedded_docs.append(doc)
        except Exception as e:
            print(f"Error preparing image {image_key}: {e}")
            return image_key
    return embedded_docs

def prepare_data_for_indexing(docs, index):
    for i in range(len(docs)):
        docs[i]["_index"] = index
    return docs

def get_query_vector(image_path):
    try:
        embedding_objs = DeepFace.represent(
            img_path = image_path,
            model_name='SFace'
        )
        embedding = embedding_objs[0]['embedding']
        return embedding
    
    except Exception as e:
        print(f"Error getting query vector: {e}")
        return None
    
def parse_search_result(result):
    hits = result['hits']['hits']
    if hits[0]['_score'] > 0.65:
        return hits[0]['fields']['unique_url']
    else:
        return None