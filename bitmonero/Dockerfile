FROM debian:stable-slim  AS builder
RUN  apt update -y \
  && apt install --no-install-recommends --no-install-suggests -y python3 python3-distutils python3-venv \
  && apt install --no-install-recommends --no-install-suggests -y wget tmux nano gcc unzip \
  && wget https://bootstrap.pypa.io/get-pip.py  --no-check-certificate  \
  && python3 get-pip.py 
  
RUN  wget https://github.com/monero-ecosystem/monero-python/archive/refs/heads/master.zip  --no-check-certificate  && \
	 unzip master.zip  && \
	 mv monero-python-master /app  && \
	 rm master.zip  && \
	 cd /app  && \
	 python3 -m venv .venv  && \
	 echo c291cmNlIC52ZW52L2Jpbi9hY3RpdmF0ZQpwaXAzIGluc3RhbGwgLXIgcmVxdWlyZW1lbnRzLnR4dAo=  \
	      | base64 -d >  py-venv.sh  && \
	 bash py-venv.sh   ###  source .venv/bin/activate && pip3 install -r requirements.txt

##################################################################

FROM debian:stable-slim
RUN  apt update -y  && \
	 apt install --no-install-recommends --no-install-suggests -y python3  && \
	 rm -rf /var/lib/apt/lists/*

COPY --from=builder  /app  /app
ADD  ./xmseed.py  /app/xmseed.py

WORKDIR  /app
RUN  echo IyEvYmluL2Jhc2gKICAgIApzb3VyY2UgLnZlbnYvYmluL2FjdGl2YXRlCnB5dGhvbjMgeG1zZWVkLnB5  \
	    | base64 -d > run.sh  && \
	 chmod +x  run.sh

CMD ["bash", "run.sh"]

##################################################################

# Usage:  docker run --rm -it xmseed

# docker run --name xmseed -itd hongwenjun/xmseed sh
# docker exec -it xmseed  bash run.sh

