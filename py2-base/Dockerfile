FROM python:2.7

# set the workdir
WORKDIR /root

# minimal software stack
RUN apt-get update; apt-get clean
RUN apt-get install nano less htop; apt-get clean

# update pip
RUN pip install --upgrade pip

# install base software
RUN pip install ipython
