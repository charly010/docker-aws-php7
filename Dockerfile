FROM amazonlinux
#
#
# COMMAND :
#
# Build : docker build -t eurelis-php7 .
#
# Run: docker run -d -p 9080:80 -it eurelis-php7
# Shell: docker exec -it XXXXX_XXXXX /bin/bash
# Stop: docker stop XXXXX_XXXXX
#
# Remove container: docker rm XXXXX_XXXXX
# Remove all container: docker rm $(docker ps -a -q)
#
# Remove all ilmages: docker rmi $(docker images -q)
#
#

#
# Config de base
#
RUN yum install -y \
    vi \
    htop \
    which \
    git

#
# Install Supervisor
#
RUN yum install -y python-pip \
&& pip-python install pip --upgrade \
&& pip install supervisor

#
# Install Apache / PHP7
#
RUN yum install -y httpd24

RUN yum install -y \
    php70 \
    php70-pdo \
    php70-ftp \
    php70-mcrypt \
    php70-soap \
    php70-gmp \
    php70-dom \
    php70-zip \
    php70-mysqli \
    php70-sqlite3 \
    php70-bcmath \
    php70-gd \
    php70-odbc \
    php70-pdo_mysql \
    php70-pdo_sqlite \
    php70-gettext \
    php70-xmlreader \
    php70-xmlwriter \
    php70-xmlrpc \
    php70-bz2 \
    php70-pdo_dblib \
    php70-curl \
    php70-ctype \
    php70-session \
    php70-redis \
    php70-zlib \
    php70-mbstring \
    php70-simplexml \
    php70-tokenizer \
    php70-opcache \
    php70-intl \
    php70-posix

#
# Install MySQL
#
RUN yum install -y \
    mysql \
    mysql-server

#
# Configure Apache/PHP
#
RUN mkdir '/etc/httpd/vhosts.conf.d'
RUN sed -i "s/#ServerName www.example.com:80/ServerName myproject.local:80/" /etc/httpd/conf/httpd.conf \
&& echo 'IncludeOptional vhosts.conf.d/*.conf' >> /etc/httpd/conf/httpd.conf
RUN sed -i "s/;date.timezone =/date.timezone = Europe\/Paris/" /etc/php.ini
COPY config/info.php /var/www/html/
#RUN chkconfig httpd on
#RUN service httpd start
#RUN apachectl start
EXPOSE 80

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#
# Configure MySQL
#
RUN sed -i "s/socket=\/var\/lib\/mysql\/mysql.sock/socket=\/tmp\/mysql.sock/" /etc/my.cnf \
&& sed -i "s/pdo_mysql.default_socket=/pdo_mysql.default_socket=\/tmp\/mysql.sock/" /etc/php.ini \
&& echo '[client]' >> /etc/my.cnf \
&& echo 'socket=/tmp/mysql.sock' >> /etc/my.cnf

RUN echo 'NETWORKING=yes' >> /etc/sysconfig/network
COPY config/mysql_safe_start_custom.sh /usr/bin/
RUN chmod +x /usr/bin/mysql_safe_start_custom.sh

#RUN chkconfig mysqld on
#RUN service mysqld start

#
# Configure Supervisor
#
COPY config/supervisord.conf /etc/

#
# Configure xdebug
#
RUN yum install -y \
    gcc \
    php70-devel

RUN cd /opt \
&& curl -OL http://xdebug.org/files/xdebug-2.5.4.tgz \
&& tar -xvzf xdebug-2.5.4.tgz \
&& cd /opt/xdebug-2.5.4 \
&& phpize \
&& ./configure \
&& make \
&& make install \
&& sed -i "/;zend.script_encoding =/a\zend_extension = /usr/lib64/php/7.0/modules/xdebug.so\n" /etc/php.ini \
&& cd .. \
&& rm xdebug-2.5.4.tgz \
&& rm -R xdebug-2.5.4 \
&& rm package.xml


#
# Custom env
COPY config/.bashrc /root/


#
# Image history
#
RUN touch /etc/version \
&& echo "Current image version : 0.04" > /etc/version \
&& echo "---------- Version history ----------" >> /etc/version \
&& echo "0.04 - Optimisation du shell" >> /etc/version \
&& echo "0.03 - Ajout support Xdebug" >> /etc/version \
&& echo "0.02 - Ajout support Git" >> /etc/version \
&& echo "0.01 - Version initiale de l'image" >> /etc/version


#
# Container start
#
#CMD mysqld_safe
#CMD apachectl -D FOREGROUND
CMD ["supervisord", "--nodaemon"]

