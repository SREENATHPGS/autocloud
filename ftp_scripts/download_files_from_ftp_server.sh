#!/bin/bash

HOST="0.0.0.0"    #Server's hostname
USER="maggie"            #Server login username
PASSWORD="maggie@1887"    #Server login password

SOURCE=<dirname in ftp server>

FILENAMES=<filename> # "*<you can use wild cards too>*" 

DOWNLOAD_DIR_PATH=<Download to path>

function downloadFiles() {

ftp -invp $HOST <<EOF
user $USER $PASSWORD
cd $SOURCE
mget $FILENAMES
bye
EOF


}

function send_email() {
    echo "Sending mails using mailgun."
    filename_to_send=$(ls -hrt | tail -n 1)

    echo "Sending Email. Attaching $filename_to_send."

    curl -s --user 'api:key-12345678900987654321123456' \
    https://api.mailgun.net/v3/mg.abcdefghigklcorpindia.in/messages \
    -F from='ftp@abccorp.com' \
    -F to=me@abccorp.cp, \
    -F cc=mycoleauge@abccorp.com \
    -F subject="Files for $(date '+%d-%m-%y')" \
    -F text='PFA files downloaded from FTP.' \
    -F attachment=@$filename_to_send
}

function main() {

	pushd $DOWNLOAD_DIR_PATH

		downloadFiles
		send_email

	popd

}

main
