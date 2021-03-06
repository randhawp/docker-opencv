FROM python:3.8.2
MAINTAINER  Puneet Randhawa <randhawa.puneet@gmail.com>

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        python3-dev \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libavformat-dev \
        libpq-dev \
	libgtk2.0-dev \
	qtbase5-dev \
	libqt5opengl5-dev \
	libassimp-dev \
        python-opengl \
	x11vnc \
	xvfb \
	fluxbox \
	wmctrl \
	swig3.0 \
	python-numpy \
	zlib1g-dev \
	xorg-dev \
	libboost-all-dev \
	libsdl2-dev \ 
    && rm -rf /var/lib/apt/lists/*
	 
RUN apt-get update && \
	apt-get upgrade -y && \
 	apt-get install -y gstreamer-1.0* && \
  	apt-get install -y aptitude && \
 	cpan Data::Dumper && \
	apt-get install -y vim && \
	apt-get install -y ffmpeg	&& \
	apt-get install -y imagemagick
RUN pip install numpy scipy pandas matplotlib jupyter seaborn scikit-learn scikit-Image sympy cython patsy statsmodels cloudpickle dill 
RUN pip install pafy youtube_dl
RUN pip3 install -U virtualenv
RUN pip install --upgrade tensorflow
RUN pip install cffi
RUN pip install 'pyglet==1.5.5'
RUN pip install 'gym==0.17.2' 
RUN pip install 'imageio==2.8.0'
RUN pip install PILLOW
RUN pip install pyvirtualdisplay
RUN pip install --upgrade tensorflow-probability
RUN pip install tf-agents
RUN pip install ipython
RUN pip install 'gym[atari]'

WORKDIR /
ENV OPENCV_VERSION="4.3.0"
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&& unzip ${OPENCV_VERSION}.zip \
&& mkdir /opencv-${OPENCV_VERSION}/cmake_binary \
&& cd /opencv-${OPENCV_VERSION}/cmake_binary \
&& cmake -DBUILD_TIFF=ON \
  -DBUILD_opencv_java=OFF \
  -DWITH_CUDA=OFF \
  -DWITH_OPENGL=ON \
  -DWITH_OPENCL=ON \
  -DWITH_IPP=ON \
  -DWITH_TBB=ON \
  -DWITH_EIGEN=ON \
  -DWITH_V4L=ON \
  -DBUILD_TESTS=OFF \
  -DWITH_GTK=ON \
  -DBUILD_PERF_TESTS=OFF \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DCMAKE_INSTALL_PREFIX=$(python3.8 -c "import sys; print(sys.prefix)") \
  -DPYTHON_EXECUTABLE=$(which python3.8.2) \
  -DPYTHON_INCLUDE_DIR=$(python3.8 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
  -DPYTHON_PACKAGES_PATH=$(python3.8 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
  .. \
&& make install \
&& rm /${OPENCV_VERSION}.zip \
&& rm -r /opencv-${OPENCV_VERSION}

#RUN ln -s \
#  /usr/local/python/cv2/python-3.8/cv2.cpython-38m-x86_64-linux-gnu.so \
#  /usr/local/lib/python3.8/site-packages/cv2.so

ENV PATH="/opt/scripts/:${PATH}"
COPY *.py  /examples/
COPY *.sh /usr/bin/

#alternatives to TF
RUN pip install torch torchvision
RUN pip install gym-gridworlds
RUN pip install tensorboardX
RUN pip install gym-minigrid

#install all other RL envs here
#RUN mkdir /home/gridworld
#RUN cd /home/gridworld
#RUN git clone https://github.com/maximecb/gym-minigrid.git

#some helper tools
RUN pip install terminaltables
RUN pip install tqdm
         

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888
# VNC Server
EXPOSE 5900

 

