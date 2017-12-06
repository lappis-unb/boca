FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get -y install \
    apt-utils \
    make \
    gcc \
    curl \
    python-software-properties \
    software-properties-common \
    locales \
    makepasswd \
    expect

RUN locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN add-apt-repository ppa:ondrej/php \
    && apt-get update

RUN apt-get -y install \
    postgresql \
    postgresql-contrib \
    postgresql-client \
    apache2 \
    libapache2-mod-php5.6 \
    php5.6 \
    php5.6-cli \
    php5.6-cgi \
    php5.6-gd \
    php5.6-mcrypt \
    php5.6-pgsql

COPY . /boca

WORKDIR /boca

RUN make install

RUN service postgresql start \
    && su postgres -c "psql -c \"UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';\"" \
    && su postgres -c "psql -c \"DROP DATABASE template1;\"" \
    && su postgres -c "psql -c \"CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';\"" \
    && su postgres -c "psql -c \"UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';\"" \
    && su postgres -c "psql -d template1 -c \"VACUUM FREEZE;\""

EXPOSE 80

CMD service apache2 start \
    && service postgresql start \
    && docker/postgres_boca.sh \
    && bash
