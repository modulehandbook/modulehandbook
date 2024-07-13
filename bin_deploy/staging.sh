
tag=$1
sha=$2

base_url=https://raw.githubusercontent.com/modulehandbook/modulehandbook

mkdir -p nginx/templates
mkdir -p bin_deploy

pause="bin_deploy/check.sh bin_deploy/staging.sh docker-compose.yml"
for file in Makefile.prod  .env.staging nginx/nginx.conf  nginx/templates/default.conf.template $pause ; do
   echo $base_url/$sha/$file
   curl $base_url/$sha/$file > $file

done

ls

echo "TAG_MODULE_HANDBOOK=$tag" >> .env.staging

mv Makefile.prod Makefile
mv .env.staging .env

sudo docker-compose down
sudo docker-compose up -d