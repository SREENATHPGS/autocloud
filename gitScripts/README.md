# GIT CLEAN UPDATE
The purpose of this script is to clean and update a git repo on a single command.

## Platforms
 LINUX - Tested on Linux (Ubuntu:16.04, Ubuntu:18.04)

## Requirements
This script relies on packages jo and jq. 
Please refer this github page for installation details of jq - https://github.com/mwilliamson/jq.py.
for jo - https://github.com/jpmens/jo

or do

```
sudo apt install jq

wget https://github.com/jpmens/jo/releases/download/1.4/jo-1.4.tar.gz

tar xvzf jo-1.4.tar.gz
cd jo-1.3
autoreconf -i
./configure
make check
make install
```

## Installation.
### Just Copying.

Download and store this script on your home directory and add an entry to your ```.bashrc``` to source it.

```
cd ~/
wget https://raw.githubusercontent.com/SREENATHPGS/autocloud/main/gitScripts/gitUpdate.sh
mv gitUpdate.sh .gitUpdate.sh
```
#### Add an entry to .bashrc
```
vi ~/.bashrc
.........
.........

source ~/.gitUpdate.sh

.........
.........
```
### Install from Pacakge.
I'm working on packagization for this script, i know this is an overkill for a simple script ;).

## Disclaimer
Please go through the script before usage. DO IF YOU KNOW WHAT YOU ARE DOING. I'm not responsible for the damages caused.

## Usage.
After installation you have to update the script with the location of your git repo on line 14.

```
vi ~/.gitUpdate.sh 
repoMap=`jo -p <your repo key>=<your repo dir>
```
Now you are good to run the command.

```source ~/.bashrc```

```
update <your repo key> <branch name>
```
