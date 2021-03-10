import sys, os, argparse
import boto3 
from botocore.config import Config
import logging as logger
from utils import regionMap

logger.basicConfig(level="INFO")
regionInstanceMap = {
        "mumbai" : {
            "test": "i-xxxxxxxxxxxxxxxxxx",
            "jenkins":"i-xxxxxxxxxxxxxxxx"
            }
        }

def switch_instance_state(state, instances):
    if state == "start":
        ec2.start_instances(InstanceIds=instances)
        logger.info ('started your instances: ' + str(instances))
    elif state == "stop":
        ec2.stop_instances(InstanceIds=instances)
        logger.info ('stopped your instances: ' + str(instances))
    elif state == "reboot":
        ec2.reboot_instance(InstanceIds=instances)
        logger.info ('rebooting your instances: ' + str(instances))
    return 

if __name__ == '__main__':
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--REGION', help = "Region where instance is deployed", default = "mumbai")
    parser.add_argument('--STATE', help = "State to which the instance has to be switched, [start, stop]")
    parser.add_argument('--NAME', help = "Name given to the instance")
    args = parser.parse_args()

    state = args.STATE 
    region = args.REGION
    instanceName = args.NAME
    
    logger.info("Region given is, "+region)
    logger.info("Instance name given is, {}".format(instanceName))
    logger.info("Instance will be switched to, {}".format(state))

    if not state in ["start", "stop"]:
        logger.info("No a valid instance state, exitting...")
        sys.exit()

    if not region in regionMap:
        logger.info("Region not given, exitting...")
        sys.exit()
        
    if not instanceName in regionInstanceMap[region]:
        logger.info("Instance name is not given, exitting...")
        sys.exit()

    if not state:
        logger.info("Instance state is not given, exitting...")
        sys.exit()

    config = Config(
            region_name = regionMap[region],
            signature_version = 'v4',
            retries = {
                'max_attempts': 10,
                'mode': 'standard'
            }
        )

    instance_id = regionInstanceMap[region][instanceName]
    instances = [instance_id]

    global ec2
    try:
        ec2 = boto3.client('ec2', config = config)
    except Exception as e:
        logger.error(e)
        logger.info("Creating boto3 client instance for ec2 failed.")
        sys.exit()
    
    switch_instance_state(state, instances)
