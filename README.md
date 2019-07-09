# ml-base

Base image for machine learning projects using Miniconda and Tensorflow. The idea is you can clone this repo and use it to start a new ML project, just adjust `environment.yml` accordingly.

Currently uses: CUDA 10.0 for use with NVIDIA binary driver

![Supported Python Versions](https://img.shields.io/badge/python-3.3%20%7C%203.4%20%7C%203.5%20%7C%203.6%20%7C%203.7-blue.svg)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE)

## How Does It Work

You need to have the latest NVIDIA binary driver installed on the host system. Docker will pass privileges to the container so that it can access the video card when needed.

## Usage

### Install the latest NVIDIA driver

#### Ubuntu

```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo ubuntu-drivers autoinstall
```

You can also see a list of alternative drivers

```
ubuntu-drivers devices
```

### Building the Image

```
docker build -t mlbase:cuda10 .
```

### Using the Image

Change to the project code directory. This will be mapped to the `/code` directory inside the container.

If this is the first time running you'll need to create and setup the container by running:

```
docker run -it --name projectname --runtime=nvidia -e UID=$(id -u) -e GID=$(id -g) -e USER=$(whoami) -e DISPLAY="$DISPLAY" -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd):/code -p 8000:8000 mlbase:cuda10 "/opt/conda/bin/conda env update --file /code/environment.yml"
```

It can then be started with

```
docker start projectname
```

To get a shell in the running container
```
docker exec -it -u $(whoami) -e DISPLAY="$DISPLAY" projectname /bin/bash -l
```

#### Jupyter Notebook

To use, append this to the `docker run` command:

```
"jupyter notebook --ip=0.0.0.0 --port=8888"
```
