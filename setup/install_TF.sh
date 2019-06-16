#!/bin/bash
#Bash script for installing Tensorflow(GPU Enabled), CUDA 7.5 and cuDNN v5 on Bash on Ubuntu on Windows
#Prerequisites:
#Make this script executable using command "chmod +x installTF.sh"
#Download cuDNN v5 for CUDA 7.5 from website https://developer.nvidia.com/cudnn
#After downloading cuDNN v5 from NVIDIA developers website, run this script using command "sudo sh installTF.sh"
#Install nvidia drivers
sudo apt-get install nvidia-367
#Install CUDA-7.5
sudo apt-get install cuda-7.5
#Add cuda environment variable
export CUDA_HOME=/usr/local/cuda-7.5
export LD_LIBRARY_PATH=${CUDA_HOME}/lib64
PATH=${CUDA_HOME}/bin:${PATH}
export PATH
source ~/.bashrc
#CUDA will be installed in path /usr/local/cuda-7.5/
#Test CUDA installation using nvcc --version
#Download and install cuDNN v5 for CUDA 7.5 from website https://developer.nvidia.com/rdp/assets/cudnn-7.5-linux-x64-v5.0-ga-tgz
tar xvzf cudnn-7.5-linux-x64-v5.0-ga.solitairetheme8
cd cuda
cp include/cudnn.h /usr/local/cuda-7.5/include/
cp lib64/* /usr/local/cuda-7.5/lib64/
#Install tensorflow
export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.10.0-cp27-none-linux_x86_64.whl
pip install $TF_BINARY_URL
#Setup environment variables
sudo nano ~/.bashrc
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-7.5/lib64:/usr/local/cudnn/lib64
export CUDA_HOME=/usr/local/cuda-7.5
export PATH=/usr/local/cuda-7.5/bin:$PATH
#Save and exit nano editor using shortcut Ctrl+X, enter Y
sudo ldconfig
source ~/.bashrc

#Install Tensorflow on Windows 10
#Prerequisites
#Tensorflow works only with Python 3.5 on Windows. Download Python 3.5 64-bit from https://www.python.org/ftp/python/3.5.0/python-3.5.0-amd64.exe and install it.
#Edit environment variables and point Python path to Python 3.5 64-bit installation folder.
#Download and install CUDA for Windows from https://developer.nvidia.com/compute/cuda/8.0/prod/local_installers/cuda_8.0.44_win10-exe
#Download and install CUDNN for Windows from https://developer.nvidia.com/cudnn
#Copy contents of CUDNN into CUDA directory
#Download pip from https://bootstrap.pypa.io/get-pip.py and install it using command "python get-pip.py"
#Install Tensorflow (GPU)
python -m pip install https://storage.googleapis.com/tensorflow/windows/gpu/tensorflow_gpu-0.12.1-cp35-cp35m-win_amd64.whl
#Install Tensorflow (CPU-only)
python -m pip install https://storage.googleapis.com/tensorflow/windows/cpu/tensorflow-0.12.1-cp35-cp35m-win_amd64.whl

#Install Tensorflow with Anaconda and include Spyder support on Windows 10
#Install Anaconda Python 3.5 64-bit version, run Anaconda promt with administrator priviliges and run the following commands
conda create -n tensorflow python=3.5
activate tensorflow
