

docker build -t ansible-action:v2 .

 docker-compose run action ansible-galaxy install -v -r requirements.yml -p roles/