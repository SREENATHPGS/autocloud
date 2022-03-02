Run this cronjob to check for changes in git and deploy periodically.

To check for changes every 5 minutes add below cron line to crontab.

`crontab -e`

`*/5 * * * * bash /home/ubuntu/application/automation/autodeploy.sh -d dev -a backend >> /home/ubuntu/autodeploy.log`
