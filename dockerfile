###############################################################################
#
# usage:
# > docker build -t nginx_app .
# > docker run -p 127.0.0.1:10000:10000 -ti nginx_app 
# > docker inspect <CONTAINER ID> | grep IPAddress
###############################################################################
###

FROM centos:7

###############################################################################
### config

### 设置环境变量
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.utf8

### 时区
RUN ln -s -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

### 设置工作目录
WORKDIR /opt

###############################################################################
### install base tool
RUN yum install -y epel-release
RUN yum install -y perl gcc curl wget make net-tools

###############################################################################
### install python36

RUN yum install -y python36
RUN ln -s /usr/bin/python36 /usr/bin/python3

### install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3 get-pip.py

### upgrade pip
RUN pip3 install -U pip
# upgrade setuptools
RUN pip3 install -U setuptools

### pip test
# CMD ["pip3", "-V"]

###############################################################################
### install openresty
WORKDIR /opt

RUN yum install -y pcre-devel openssl-devel

### download
RUN wget https://openresty.org/download/openresty-1.13.6.2.tar.gz
RUN tar xvf ./openresty-1.13.6.2.tar.gz

### configure
RUN cd /opt/openresty-1.13.6.2 && ./configure --prefix=/opt/openresty \
    --with-pcre-jit \
    --with-ipv6 \
    --without-http_redis2_module \
    --with-http_iconv_module
RUN cd /opt/openresty-1.13.6.2 && make && make install

### link
RUN ln -sf /opt/openresty/bin/resty  /usr/bin/resty
RUN ln -sf /opt/openresty/bin/openresty /usr/bin/openresty

### install LuaJIT
WORKDIR /opt/openresty-1.13.6.2/bundle/LuaJIT-2.1-20180420/
RUN make clean && make && make install
RUN ln -sf src/luajit /usr/bin/luajit

###############################################################################
### clean
RUN yum clean all
RUN rm -rf /tmp/* /var/tmp/*

###############################################################################
### app

RUN mkdir /var/nginx_app
WORKDIR /var/nginx_app

### install python requirements
# COPY requirements.txt ./
# RUN pip install --no-cache-dir -r requirements.txt


# RUN pip3 install pipenv
# COPY Pipfile ./
# COPY Pipfile.lock ./
# RUN pipenv install
# RUN pipenv shell

###############################################################################
### project

COPY . .
# COPY app ./
# COPY wsgi.py ./

RUN pip3 install requests

### 环境变量
# ENV FLASK_ENV=prodection

### Port to expose
EXPOSE 10000 10001

# RUN flask initdb
# RUN export LC_ALL=en_US.utf8 && export LANG=en_US.utf8 && flask run -h 0.0.0.0 -p 5000
# RUN flask run -h 0.0.0.0 -p 5000
# ENTRYPOINT ["./gunicorn_bootshrap.sh"]

# CMD flask run -h 0.0.0.0 -p 5000
# CMD openresty -c /var/nginx_app/ngx_hello_lua.conf
