docker build -t vitalykay/nginx:1.00-netology .
docker run --name nginx-test -p 80:80 -d vitalykay/nginx:1.00-netology