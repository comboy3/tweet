# 最新の　centos7 をインストール
FROM centos:centos7

# デフォルトシェルの指定
# SHELL ["/bin/bash", "-c"]

# yum を更新し必要なツールをインストールします
RUN yum -y update
RUN yum -y groupinstall base "Development tools" --setopt=group_package_types=mandatory,default,optional
RUN yum -y install bzip2-devel gdbm-devel libffi-devel \
  libuuid-devel ncurses-devel openssl-devel readline-devel \
  sqlite-devel tk-devel wget xz-devel zlib-devel postgresql-devel

# locale を日本語にする
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANGUAGE="ja_JP:ja" LANG="ja_JP.UTF-8" LC_ALL="ja_JP.UTF-8"

# pythonをインストールする
RUN wget https://www.python.org/ftp/python/3.6.11/Python-3.6.11.tar.xz
RUN tar xJf Python-3.6.11.tar.xz
RUN cd ./Python-3.6.11 && \
  ./configure && \
  make && \
  make install
RUN rm Python-3.6.11.tar.xz

# SQLiteの最新化（3.31.1の場合）
RUN wget https://www.sqlite.org/2020/sqlite-autoconf-3310100.tar.gz
RUN tar xvfz sqlite-autoconf-3310100.tar.gz

# ビルドしてインストール
RUN cd sqlite-autoconf-3310100 && \
  ./configure --prefix=/usr/local && \
  make && \
  make install
RUN rm sqlite-autoconf-3310100.tar.gz
RUN rm -rf ./sqlite-autoconf-3310100

# 作業ディレクトリ
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN pip3 install -r requirements.txt
ADD . /code/

# 最後に yum をclean していらないものを削除
RUN yum clean all
RUN rm -rf /var/cache/yum
