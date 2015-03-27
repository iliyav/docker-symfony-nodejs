FROM ubuntu:14.10

ENV DEBIAN_FRONTEND noninteractive

#Install PHP stack
RUN apt-get update -y && apt-get install -y \
    curl \
    git \
    make \
    php5 \
    php-pear \
    php5-cli \
    php5-common \
    php5-curl \
    php5-gd \
    php5-fpm \
    php5-mcrypt \
    nginx \
    supervisor \
    sudo
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf
RUN sed -e 's/;listen\.owner/listen.owner/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/;listen\.group/listen.group/' -i /etc/php5/fpm/pool.d/www.conf
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

#Install nodejs
RUN curl -sL https://deb.nodesource.com/setup | bash && apt-get install -y nodejs

RUN npm install -g bower && npm update -g bower
RUN npm install -g gulp && npm update -g gulp
RUN npm install -g uglifycss && npm update -g uglifycss

COPY vhost.conf /etc/nginx/sites-available/default
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY init.sh /init.sh

EXPOSE 80

VOLUME ["/srv"]
WORKDIR /srv

CMD ["/usr/bin/supervisord"]
