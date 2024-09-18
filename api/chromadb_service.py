import chromadb

def create_chroma_client(path):
    """Create a client for the ChromaDB service."""
    client = chromadb.PersistentClient(path=path)
    return client

def create_collection(client, collection_name):
    """Create a collection in ChromaDB."""
    collection = client.get_or_create_collection(
        name=collection_name,
        # default values as per the documentation in opensearch
        metadata = {"hnsw:space": "cosine", "hnsw:construction_ef": 100, "hnsw:M": 16, "hnsw:search_ef": 100}
    )
    return collection

def index_data(collection, docs):
    """Index data in ChromaDB."""
    # Index the data
    try:
        for doc in docs:
            collection.add(
                embeddings=doc['embedding'],
                ids=doc['id'],
                metadatas = [{ "unique_url": doc['unique_url'] }]
            )
        print("Indexed all documents")
        return {"status": "success", "message": "Indexed all documents"}
    except Exception as e:
        print(f"Error indexing data: {e}")
        return {"status": "failure", "message": f"Error indexing data: {e}"}
    
def delete_collection(client, collection_name):
    """Delete a collection in ChromaDB."""
    try:
        client.delete_collection(name=collection_name)
        print("Collection deleted")
        return {"status": "success", "message": "Collection deleted"}
    except Exception as e:
        print(f"Error deleting collection: {e}")
        return {"status": "failure", "message": f"Error deleting collection: {e}"}
    
def search_knn_index(collection, query_embedding, query_image_list):
    """Search the k-NN index in ChromaDB."""
    result = collection.query(
        query_embeddings=query_embedding,
        n_results=3,
        where={"unique_url": {"$in": query_image_list}},
    )
    return result
    

def check_images_exist(collection, image_list):
    """Check if images are already indexed"""
    result = collection.get(
        ids=image_list
    )
    unique_urls = result['ids']
    non_indexed_urls = list(set(image_list) - set(unique_urls))
    if len(non_indexed_urls) > 0:
        print("Some images are not indexed")
        return non_indexed_urls
    else:
        print("All images are indexed")
        return None
    

    
