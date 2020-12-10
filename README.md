# autocloud
# Requirements
  1. Python3
  2. boto3
  3. AWS account and credentials.
  
# Setup
  
  Clone or downlaod this project and navigate into the project directory.
  
  # Linux
  
  Create virtualenv if required,
  ```
  virtualenv pyenv
  source pyenv/bin/activate
  ```
  ```
  pip install -r requirements.txt
  ```
  # Windows
  
  Create virtualenv if required,
  ```
  virtualenv pyenv
  pyenv\Scripts\activate
  ```
  ```
  pip install -r requirements.txt
  ```
  
# Usage
  ```
  
  (pyenv) ubuntu@dell-machine-001:~/projects/autocloud$ python change_instance_state.py --help
  usage: change_instance_state.py [-h] [--REGION REGION] [--STATE STATE] [--NAME NAME]
  optional arguments:
    -h, --help       show this help message and exit
    --REGION REGION  Region where instance is deployed (default: mumbai)
    --STATE STATE    State to which the instance has to be switched, [start,
                     stop, reboot] (default: None)
    --NAME NAME      Name given to the instance (default: None)
    
  ```

# Readme for this branch
This branch contains production version of the code snippet that is published on my blogs. Links are given below,
1. https://sreenathgirikanyadas.medium.com/start-stop-reboot-ec2-instances-using-pyhton-boto3-10e994121d4e

# Main readme
This is a git repo of collection of scripts i will be writing related to cloud/networking/devops/system management. Future goal is to make it a full fledged application that can be used to create and manage cloud and cloud based applications.
