#! /bin/bash
docker stop boca
docker rm boca
docker run -it -p 80:80 --name boca boca
