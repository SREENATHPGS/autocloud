Simple App to collect and display IP addresses.

# README #

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for? ###

### How do I get set up? ###

* Dependencies
    Python==3.8
    Python-pip
    virtualenv (optional)
    Refer requirements.txt for library dependencies.

* Database configuration
    This app uses SQLite by default, configuration is taken care of by the app itself. This the only DB supported as of now.

* Deployment instructions
    1. `virtualenv pyenv --python=python3.8`
    2. `source pyenv/bin/activate`
    3. `pip install -r requirements.txt`
    4. `python app.py`

* Deployment instructions - Will update installation on client side soon.
    1. Run `ifconfig` and get your computer's interface name. Eg. wlo1, ensp1, etc...
    2. Run `wget https://github.com/SREENATHPGS/autocloud/blob/main/ipCollector/update_ip.sh`
    3. Run `crontab -e`
    4. Add an entry `*/10 * * * * bash ~/update_ip.sh -i <interface_name> -u <server_url>` to the end of the file. This entry will call the script every 5 minuted, so the IP will be updated to the server every 5 mins.

### Who do I talk to? ###

* Repo owner or admin
    
* Other community or team contact
