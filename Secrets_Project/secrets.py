import boto3
from botocore.exceptions import ClientError



# def main():
    #use list_secrets to get a list of all AWS secrets X 
    #loop over the list of screts X
    #Pull the ARN of every item in the list of secrets X
    #append pulled ARNs to a list of ARNs X
    #use get_secret_value with the input of the ARN or friendly name of the secret from the list of ARNs X
    # print out the list of ARNs X
def print_secrets():
    ARNs = []

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name='us-east-1',
        )

    AWS_list_secrets = client.list_secrets(
        IncludePlannedDeletion=True,
        MaxResults=45,
        
        SortOrder='asc'
    )

    for item in AWS_list_secrets['SecretList']:
        ARNs.append(item['ARN'])

    for ARN in ARNs:
        secret_key = client.get_secret_value(
            SecretId=ARN
        )
        print(secret_key['SecretString'])


def delete_secrets():
    for ARN in ARNs:
        client.delete_secret(
            SecretId= ARN,
            RecoveryWindowInDays=123,
            ForceDeleteWithouyRecovery=True
        )






if __name__ == "__main__":
     delete_secrets()
