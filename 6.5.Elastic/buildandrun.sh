docker build -t vitalykay/es_test:1.0-netology .
docker run --name els-test -p 9200:9200 -p 9300:9300 -d vitalykay/es_test:1.0-netology