FROM ubuntu:16.04
MAINTAINER Howard

ADD demo.conf /
ADD hello_module.py /

RUN apt-get update \
 && apt-get install -y python3 python3-pip python-dev build-essential \
 && pip3 install --upgrade pip \
 && pip install virtualenv uwsgi \
 && apt-get install -y python-software-properties \
 && apt-get install -y nginx \
 && rm /etc/nginx/sites-available/default \
 && rm /etc/nginx/sites-enabled/default \
 && cd /etc/nginx/sites-enabled \
 && mv /demo.conf . \
 && service nginx restart \
 && cd /var/www \
 && mkdir demo \
 && cd demo \
 && virtualenv venv \
 && /bin/bash -c "source /var/www/demo/venv/bin/activate" \
 && pip install flask \
 && mv /hello_module.py .

CMD ["cd /var/www/demo"]
CMD ["uwsgi --module hello_module --callable app --socket /var/www/demo/demo.sock --chown-socket www-data:www-data --venv /var/www/demo/venv", "run"]


