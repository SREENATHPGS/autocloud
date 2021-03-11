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


