# learning OpenResty

## install openresty

```bash
# CentOS
yum install pcre-devel openssl-devel gcc curl

cd /opt
wget https://openresty.org/download/openresty-1.13.6.2.tar.gz
tar xf ./openresty-1.13.6.2.tar.gz
cd ./openresty-1.13.6.2
./configure --prefix=/opt/openresty \
            --with-pcre-jit \
            --with-ipv6 \
            --without-http_redis2_module \
            --with-http_iconv_module \
            --with-http_postgres_module \
            -j2
make
make install
ln -sf /opt/openresty/bin/resty  /usr/bin/resty
ln -sf /opt/openresty/bin/openresty /usr/bin/openresty

# test
resty -e 'print("hello, world!")'
```

## start

```bash
# start
openresty -c /home/www/ngx_hello_lua.conf -t

# test
curl http://127.0.0.1:10000/lua
```

## install thrid-package

```bash
mkdir -p lualib/resty
```

### install lua-resty-template

```bash
cd lualib/resty
wget https://raw.githubusercontent.com/bungle/lua-resty-template/master/lib/resty/template.lua

mkdir html
cd html
wget https://raw.githubusercontent.com/bungle/lua-resty-template/master/lib/resty/template/html
```

## install lua-resty-redis

```
cd lualib/resty
wget https://github.com/openresty/lua-resty-redis/blob/master/lib/resty/redis.lua
```
