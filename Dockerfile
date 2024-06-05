FROM tejctcznrtamwvvfecrocsnimmnxqgazpchlcgejjfghbwosrbgfbdkybmmy

#LABEL maintainer=""

RUN set -x \
    && groupadd --system --gid 970 radiusd \
    && useradd --system -g radiusd -M --shell /bin/nologin --uid 970 radiusd \
    && pacman -Syyuu --noconfirm --needed base freeradius git

USER root
WORKDIR /

RUN git clone https://github.com/GlassROM/freeradius-config
RUN mv freeradius-config/.git /etc/raddb
WORKDIR /etc/raddb
RUN git config --global --add safe.directory /etc/raddb
RUN git reset --hard
RUN git clean -f


RUN yes | pacman -Scc

WORKDIR /etc/raddb

EXPOSE 1812/tcp 1812/udp 1813/tcp 1813/udp

STOPSIGNAL SIGQUIT

RUN chown -R radiusd:radiusd /etc/raddb
RUN rm -rf /freeradius-config /etc/raddb/.git /etc/raddb/certs/.git /etc/raddb/.gitignore
USER radiusd

CMD ["/usr/bin/radiusd", "-d", "/etc/raddb", "-f"]
