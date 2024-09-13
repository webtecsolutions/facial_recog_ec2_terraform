from opensearchpy import OpenSearch, RequestsHttpConnection, helpers
import os

knn_index = {
    'settings': {
        'index.knn': True,
        'index.knn.space_type': 'cosinesimil',
    },
    'mappings': {
        'properties': {
            'embedding': {  # k-NN vector field
                'type': 'knn_vector',
                'dimension': 128 ,  # Dimension of the vector
                'method' : {
                    'name': 'hnsw',
                    'engine': 'lucene',
                    'space_type': 'cosinesimil'
                }

            },
            'unique_url': { 
                'type': 'keyword'
            }
        }
    }
}

def create_opensearch_client():
    # Access environment variables
    OPENSEARCH_USERNAME = os.getenv("OPENSEARCH_USERNAME")
    OPENSEARCH_PASSWORD = os.getenv("OPENSEARCH_PASSWORD")
    OPENSEARCH_HOST = os.getenv("OPENSEARCH_HOST")
    port = 443
    
    if not OPENSEARCH_USERNAME or not OPENSEARCH_PASSWORD or not OPENSEARCH_HOST:
        raise ValueError("Please set the environment variables OPENSEARCH_USERNAME, OPENSEARCH_PASSWORD, and OPENSEARCH_HOST")

    # Set the credentials
    credentials = (OPENSEARCH_USERNAME, OPENSEARCH_PASSWORD)

    # Create the OpenSearch client
    client = OpenSearch(
    hosts = [f'{OPENSEARCH_HOST}:{port}'],
    http_auth = credentials,
    use_ssl = True,
    verify_certs = True,
    connection_class = RequestsHttpConnection
    )
    return client

def create_knn_index(client, index_name):
    #Chweck if the index exists
    if client.indices.exists(index=index_name):
        print("Index already exists")
        return
    # Create the k-NN index
    response = client.indices.create(
        index=index_name, 
        body=knn_index
        )
    return response

def index_data(client, docs):
    # Index the data
    response = helpers.bulk(client, docs)
    return response

def delete_index(client, index_name):
    # Delete the index
    response = client.indices.delete(index=index_name)
    return response

def search_knn_index(client, index_name, query_embedding, query_image_list):
    search_query={
    "size": 3,
    "query": {
        "knn": {
            "embedding":{
                "vector":query_embedding,
                "k":3,
                "filter": {
                        "terms": {
                            "unique_url": query_image_list
                        }
                    }
            }  
        }
    }, "_source": False,
    "fields": ["unique_url"]
    }
    result = client.search(index=index_name, body=search_query)
    result['hits']['hits']
    return result

def check_images_exist(client, index_name, image_list):
    search_query={
        "size": 0,
        "aggs":{
            "unique_urls":{
                "filter": {
                    "terms": {
                        "unique_url": image_list
                    }
                },
                "aggs":{
                    "unique_urls":{
                        "terms": {
                            "field": "unique_url",
                            "size": len(image_list)
                        }
                    }
                }
            }
        }   
    }
    aggregation_result = client.search(index=index_name, body=search_query)
    unique_urls = aggregation_result['aggregations']['unique_urls']['unique_urls']['buckets']
    unique_urls = [bucket['key'] for bucket in unique_urls]
    non_indexed_urls = list(set(image_list) - set(unique_urls))
    if len(non_indexed_urls) > 0:
        print("Some images are not indexed")
        return non_indexed_urls
    else:
        print("All images are indexed")
        return None
