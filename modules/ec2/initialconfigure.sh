#!/bin/bash

# Update and install required packages
sudo apt-get update 
sudo apt install -y python3-pip python3-venv libgl1 

git clone https://github.com/amit-cubit/facial_recognition_api.git
cd facial_recognition_api
mkdir images

# sudo  cp fastapi_nginx /etc/nginx/sites-enabled/
# sudo service nginx restart

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# cat /var/log/cloud-init-output.log

