import logging, boto3, argparse, os, sys, requests
from botocore.exceptions import ClientError
logger =  logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


def create_presigned_post(bucket_name, object_name, fields=None, conditions=None, expiration=60):
    """Generate a presigned URL S3 POST request to upload a file

    :param bucket_name: string
    :param object_name: string
    :param fields: Dictionary of prefilled form fields
    :param conditions: List of conditions to include in the policy
    :param expiration: Time in seconds for the presigned URL to remain valid
    :return: Dictionary with the following keys:
        url: URL to post to
        fields: Dictionary of form fields and values to submit with the POST
    :return: None if error.
    """

    # Generate a presigned S3 POST URL
    s3_client = boto3.client(
        's3',
        aws_access_key_id=os.environ.get("aws_access_key_id"),
        aws_secret_access_key=os.environ.get("aws_secret_access_key"),
        region_name = os.environ.get("aws_region", "ap-south-1")
        )
    try:
        response = s3_client.generate_presigned_post(
            bucket_name,
            object_name,
            Fields=fields,
            Conditions=conditions,
            ExpiresIn=expiration,
        )
        logger.info(response)
    except ClientError as e:
        logger.error(e)
        return None

    # The response contains the presigned URL and required fields
    return response

if __name__ == '__main__':
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter, description="Script that generates pre-signed url to copy files to s3.")
    parser.add_argument('--bucket_name', type=str, help="The name of the s3 bucket.")
    parser.add_argument('--filename', type=str, help="The name of the file to copy to bucket.")
    parser.add_argument('--object_name', type=str, help="The name of the file stored in the bucket.")
    parser.add_argument('--expiry', type=int, help="Link expiry duration in seconds.")

    args = parser.parse_args()
    
    bucket_name = args.bucket_name
    filename = args.filename
    object_name = args.object_name
    expiration = args.expiry

    if not os.path.isfile(filename):
        logger.error("File doesn't exist.")
        sys.exit()
    
    logger.info("File Exists. Getting presigned url.")

    response = create_presigned_post(bucket_name, object_name, expiration = expiration)

    if not response:
        logger.error("Getting presigned url faild.")
        sys.exit()

    logger.info("Reading file.")
    with open(filename, 'rb') as f:
        files = {'file': (object_name, f)}
        logger.info("Uploading file...")
        http_response = requests.post(response["url"], data =  response['fields'], files=files)

    logger.info(f'File upload HTTP status code: {http_response.status_code}')
    logger.info(http_response.text)

    if http_response.status_code == 200:
        logger.info("File upload successful.")