FROM ubuntu:24.04

RUN apt update
RUN apt install -yy unzip python3 python3-pip python3.12-venv
COPY build.sh /root/
COPY push_to_s3.py /root/
WORKDIR /root/build_project/
RUN python3 -m venv pyenv
RUN pyenv/bin/pip install --upgrade build setuptools wheel pytest boto3 requests
WORKDIR /root/
CMD ["bash", "build.sh"]
