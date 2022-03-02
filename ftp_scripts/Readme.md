This is a simple script to download fils from an FTP server, this script is useful when you have to download a bunch of files from FTP server periodically.

A cron line can be written as below to run it periodically.

To run the script every 5 minutes add the below line to crontab.

`crontab -e`

`*/5 * * * * bash /home/dave/application/mailer/price_sheet_mailer.sh > /home/dave/application/mailer/mailer.log `
