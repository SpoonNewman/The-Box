import boto3
from botocore.exceptions import ClientError


def get_secret():
    secret_name = "some_secret_296b1161-165b-4282-beba-71fbbbf9b6a5"
    region_name = "us-east-1"

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name,
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        raise


        
    text_secret_data = get_secret_value_response['SecretString']

    return text_secret_data



if __name__ == "__main__":
    secrets = get_secret()
    
    print(secrets)    


#example of filters
    # response = client.list_secrets(
    # IncludePlannedDeletion=True|False,
    # MaxResults=123,
    # NextToken='string',
    # Filters=[
    #     {
    #         'Key': 'description',
    #         'Values': [
    #             'cum_fart',
    #         ]
    #     },
    #     {
    #         'Key': 'tag-key',
    #         'Values': [
    #             'region',
    #         ]
    #     },
    #     {
    #         'Key': 'tag-value',
    #         'Values': [
    #             'us-west-2'
    #         ]
    #     }
    # ],
    # SortOrder='asc'|'desc'
# )