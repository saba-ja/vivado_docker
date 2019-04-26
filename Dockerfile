FROM ubuntu:18.04

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://localhost:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

### Envrionment config
ENV HOME=/home/developer \
    TERM=xterm \
    STARTUPDIR=/home/developer/dockerstartup \
    INST_SCRIPTS=/home/developer/headless/install \
    NO_VNC_HOME=/home/developer/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=32 \
    VNC_RESOLUTION=1920x1080 \
    VNC_VIEW_ONLY=false \
    VNC_PW=vncpassword
WORKDIR $HOME

RUN cp /root/.bashrc /home/developer/
RUN apt-get update

### Add all install scripts for further steps
ADD ./src/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install some common tools
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

### Install custom fonts
RUN $INST_SCRIPTS/install_custom_fonts.sh

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### configure startup
RUN $INST_SCRIPTS/libnss_wrapper.sh
ADD ./src/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

### Install required packages by vivado
RUN $INST_SCRIPTS/vivado_essential.sh

### Install lxde
RUN $INST_SCRIPTS/lxde_setup.sh

### setup developer home page
RUN useradd -r -d /home/developer -s /bin/bash -g root -G sudo -u 1000 -p "$(openssl passwd -1 $VNC_PW)" developer
USER developer
WORKDIR /home/developer/proj
COPY installation_config.txt /home/developer/proj
RUN echo "alias l='ls -la'" >> /home/developer/.bash_aliases \
&& echo "alias c='cd ..'" >> /home/developer/.bash_aliases

### 
ENTRYPOINT ["/home/developer/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]

# docker build --tag=my-vivado-image .
# docker run --name=my-vivado-container --user developer:root --shm-size=256m -e VNC_RESOLUTION=1920x1080 -it -p 5901:5901 -p 6901:6901 -v $(pwd)/proj/:/home/developer/proj my-vivado-image /bin/bash
# docker run --name=my-vivado-container -it -e DISPLAY=docker.for.mac.host.internal:0 -v $(pwd)/proj/:/home/developer/proj my-vivado-image /bin/bash
# docker run -it --rm -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=mypassword pddenhar/docker-mint-vnc-desktop
# docker run -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=vncpassword -v $(pwd)/proj/:/home/developer/proj dorowu/ubuntu-desktop-lxde-vnc