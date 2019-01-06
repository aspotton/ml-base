# ml-base

Base image for machine learning projects using Tensorflow. The idea is you can clone this repo and use it to start a new ML project. It auto detects exposed NVIDIA GPUs when starting and will install the correct version of Tensorflow for your app. There is no dependency on nvidia-docker, either.

## How Does It Work

You place the required version of tensorflow in your requirements.txt file. The project code gets saved to `/code`. When building the docker image both the CPU and GPU versions of tensorflow will be saved in the directory `/packages`. If you have a GPU exposed when the image starts, it will install the GPU version of tensorflow. If not, it will make sure the CPU version is installed.

## Usage

### Building the Image

```
docker build -t projectname:tagversion .
```

### Using the Image

To run with GPU support (and without nvidia-docker):

```
docker run -it --rm $(ls /dev/nvidia* | xargs -I{} echo '--device={}') $(ls /usr/lib/*-linux-gnu/{libcuda,libnvidia}* | xargs -I{} echo '-v {}:{}:ro') -v $(pwd):/code projectname:tagversion [entry-command]
```

To run without GPU support:

```
docker run -it --rm -v $(pwd):/code projectname:tagversion [entry-command]
```
