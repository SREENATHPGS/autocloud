# Python Package Builder - Docker

This package builder for Python uses docker container to build a python package amd optionally upload it your aws s3 bucket.
The build python package (both *.whl and *.tz) are stored in the container and a volume needs to be mounted in order to get it in the host.

## Step 0: Build docker image.
  ##### 0.1 Download this directory.
  ##### 0.2 docker build -t python-package-builder:latest
  
## Step 1: Create project zip.
  >
  >Note:- Ensure that the project has valid pyproject.toml or setup.py files.
  > 
  Zip your project with the zip name as project.zip
  `zip -r project.zip ./`
  
### Step 2: Run the contaienr.
  `docker run -it --rm \
    -e PUSH_TO_S3=1 \
    -e BUCKET_NAME=your-release-bucket \
    -e OBJECT_PREFIX=your-package-folder-in-bucket \
    -e aws_access_key_id=XXXXXXXXXXXXXXXXXXXX \
    -e aws_secret_access_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \
    -e aws_region=your-preferred-aws-region \
    --name python_package_builder \
    -v ./project.zip:/root/build_project/project.zip  \
    -v ./output:/root/build_project/output \
    python-package-builder:latest`

### Optional Params:
    1. PUSH_TO_S3=1 - Use only if the image needs to be pushed to s3.
    2. BUCKET_NAME=<bucket name> - Provide valid bucketname.
    3. OBJECT_PREFIX=<object/path/in/the/bucket>
    4. aws_access_key_id=XXXXXXXXXXXXXXXXXXXX
    5. aws_secret_access_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    6. aws_region=<region> - defaults to ap-south-1
    7. ./output:/root/build_project/output - if you want the package on you build machine.


