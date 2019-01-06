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

NVIDIA_DEVS=`ls -1 /dev/nvidia*`
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

ARGS="$@"
if [ -n "$ARGS" ]; then
	"$@"
else
	/bin/bash
fi
