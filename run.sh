#!/bin/bash

TF_CPU_INSTALLED=0
TF_GPU_INSTALLED=0

DETECT_GPU=0

RESULT=`pip3 freeze | grep tensorflow-gpu`
if [ -n "$RESULT" ]; then
	TF_GPU_INSTALLED=1
fi

RESULT=`pip3 freeze | grep tensorflow | grep -v tensorflow-gpu`
if [ -n "$RESULT" ]; then
	TF_CPU_INSTALLED=1
fi

NVIDIA_DEVS=`ls -d1 /dev/nvidia* 2>/dev/null`
if [ -n "$NVIDIA_DEVS" ]; then
	DETECT_GPU=1
	echo "GPU detected ..."
else
	echo "No GPU detected ..."
fi

if [ $DETECT_GPU -eq 1 ]; then
	if [ $TF_CPU_INSTALLED -eq 1 ]; then
		echo "Removing CPU version of Tensorflow ..."
		pip3 uninstall -y tensorflow
	fi

	if [ $TF_GPU_INSTALLED -ne 1 ]; then
		echo "Installing GPU version of Tensorflow ..."
		FILE=`ls -1 /packages/tensorflow_gpu*.whl | head -1`
		pip3 install $FILE
	fi
else
	if [ $TF_GPU_INSTALLED -eq 1 ]; then
		echo "Removing GPU version of Tensorflow ..."
		pip3 uninstall -y tensorflow-gpu
	fi

	if [ $TF_CPU_INSTALLED -ne 1 ]; then
		echo "Installing CPU version of Tensorflow ..."
		FILE=`ls -1 /packages/tensorflow*.whl | grep -v tensorflow_gpu | head -1`
		pip3 install $FILE
	fi
fi

CUDA_LIBS=`ls -d1 /usr/local/cuda-* 2>/dev/null`

if [ -n "$CUDA_LIBS" ]; then
	export LD_LIBRARY_PATH=$CUDA_LIBS/lib64:$LD_LIBRARY_PATH
fi

# Setup local user to be the same - avoid permission issues
if [ -n "$USER" -a -n "$UID" -a -n "$GID" ]; then
	groupadd -g $GID $USER
	useradd -g $GID -M -N $USER -d /code
else
	USER="root"
fi

ARGS="$@"
if [ -n "$ARGS" ]; then
	su $USER -c "$@"
else
	su $USER -c /bin/bash
fi
