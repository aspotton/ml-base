FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

# install system dependencies
RUN apt-get -qqy update \
 && apt-get -qqy upgrade \
 && apt-get -qqy install python3.6 python3-pip

WORKDIR /code

ADD . /code

RUN pip3 --no-cache-dir install -r requirements.txt

# Cache the tensorflow packages so we can switch between GPU/CPU
RUN mkdir /packages; cd /packages; VERSION=`pip3 freeze | grep tensorflow | head -1 | cut -d'=' -f3-4`; \
  pip3 --no-cache-dir download --no-deps tensorflow==$VERSION && \
  pip3 --no-cache-dir download --no-deps tensorflow-gpu==$VERSION

ENTRYPOINT ["/code/run.sh"]
