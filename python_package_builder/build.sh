#!/bin/bash

export PUSH_TO_S3=${PUSH_TO_S3:-0}
export BUCKET_NAME=${BUCKET_NAME:-0}
export OBJECT_PREFIX=${OBJECT_PREFIX:-0}

function main() {
	pushd /root/build_project/
		unzip project.zip
		#python3 -m venv pyenv
		#pyenv/bin/pip install --upgrade build setuptools wheel pytest
		pyenv/bin/python -m build
		mkdir /root/build_project/output/
		rm /root/build_project/output/*whl
		rm /root/build_project/output/*.gz
		cp ./dist/* /root/build_project/output/

		if [ $PUSH_TO_S3 == 0 ];then
			return
		fi

		if [ $BUCKET_NAME == 0 ];then
			echo "Bucket name not given, not pushing to s3."
			exit 1
		fi

		if [ $OBJECT_PREFIX == 0 ];then
			echo "Invalid object prefix or path."
			exit 1
		fi

		whl_filename=$(basename $(ls -lhrt output/*.whl | awk '{print $9}' | tail -1))

		pyenv/bin/python /root/push_to_s3.py --bucket_name=$BUCKET_NAME --filename=/root/build_project/output/$whl_filename --object_name=$OBJECT_PREFIX/$whl_filename --expiry=30

	popd
}

main