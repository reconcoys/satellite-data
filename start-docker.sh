#!/bin/bash
docker build -t satellite-data .
docker run --rm -it -p 3000:3000 satellite-data bash