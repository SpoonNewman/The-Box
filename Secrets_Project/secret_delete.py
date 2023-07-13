import boto3
from botocore.exceptions import ClientError




# # def print_secrets():
#     ARNs = []

#     session = boto3.session.Session()
#     client = session.client(
#         service_name='secretsmanager',
#         region_name='us-east-1',
#         )

#     AWS_list_secrets = client.list_secrets(
#         IncludePlannedDeletion=True,
#         MaxResults=45,
        
#         SortOrder='asc'
#     )

#     for item in AWS_list_secrets['SecretList']:
#         ARNs.append(item['ARN'])

#     for ARN in ARNs:
#         secret_key = client.get_secret_value(
#             SecretId=ARN
#         )
#         print(secret_key['SecretString'])







def delete_secrets():
    ARNs = []
    
    
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name='us-east-1',
        )
    
    # AWS_list_secrets = client.list_secrets()
    paginator = client.get_paginator("list_secrets")


    for page in paginator.paginate():


        for item in page['SecretList']:
            ARNs.append(item['ARN'])
        
        
        for ARN in ARNs:
            client.delete_secret(
                SecretId= ARN,
            )
    






if __name__ == "__main__":
     delete_secrets()
