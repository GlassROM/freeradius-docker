FROM archlinux:latest

#LABEL maintainer=""

COPY pacman.conf /etc/pacman.conf

RUN set -x \
    && groupadd --system --gid 970 radiusd \
    && useradd --system -g radiusd -M --shell /bin/nologin --uid 970 radiusd \
    && pacman -Syyuu --noconfirm \
    && pacman -Syyuu --noconfirm base freeradius git

# Building inside docker is a mess. Build your own hardened malloc git version outside the container and supply it here
COPY hmalloc.pkg.tar /
RUN pacman -U --noconfirm hmalloc.pkg.tar

USER root
WORKDIR /

RUN git clone https://github.com/GlassROM/freeradius-config
RUN mv freeradius-config/.git /etc/raddb
WORKDIR /etc/raddb
RUN git config --global --add safe.directory /etc/raddb
RUN git reset --hard
RUN git clean -f


RUN pacman -Rcns git --noconfirm \
    && pacman -Qdtq --noconfirm | pacman -Rs - --noconfirm \
    && pacman -Sc --noconfirm

RUN echo '/usr/lib/libhardened_malloc.so' | tee -a /etc/ld.so.preload

WORKDIR /etc/raddb

EXPOSE 1812/tcp 1812/udp 1813/tcp 1813/udp

STOPSIGNAL SIGQUIT

RUN chown -R radiusd:radiusd /etc/raddb
RUN rm -rf /freeradius-config /etc/raddb/.git /etc/raddb/certs/.git /etc/raddb/.gitignore
USER radiusd

CMD ["/usr/bin/radiusd", "-d", "/etc/raddb", "-f"]
