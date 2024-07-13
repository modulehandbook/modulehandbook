
tag=$1
sha=$2

base_url=https://raw.githubusercontent.com/modulehandbook/modulehandbook
tag=sha-f153ba9
sha=fe7208f942eee11973888b5687a455d8b65ce421

mkdir -p nginx/templates

for file in Makefile docker-compose.yml .env.staging nginx/nginx.conf  nginx/templates/default.conf.template ; do
echo $base_url/$sha/$file
curl $base_url/$sha/$file > $file

done

echo "TAG_MODULE_HANDBOOK=$tag" >> .env.staging