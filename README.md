# Running Vivado suit in Docker container

## A. Download Vivado source

### 1. Download Vivado from your source (CAE or Xilinx) into proj/ folder
```
CAE: https://cae.jpl.nasa.gov

or

Xilinx: https://www.xilinx.com/support/download.html
```

------------------

## B. Docker Setup

### 1. Build docker image
```bash
docker build --tag=my-vivado-image .
```

###  2.1 (Option 1) Create docker container from the image to run with VNC
```bash
docker run --name=my-vivado-container --user developer:root --shm-size=256m -e VNC_RESOLUTION=1920x1080 -it -p 5901:5901 -p 6901:6901 -v $(pwd)/proj/:/home/developer/proj my-vivado-image /bin/bash
```

###  2.2 (Option 2) Create docker container from the image to run with X11
```bash
docker run --name=my-vivado-container -it -e DISPLAY=docker.for.mac.host.internal:0 -v $(pwd)/proj/:/home/developer/proj my-vivado-image:latest /bin/bash
```


### 3. Enter to the container
If container is not started start the container first:
```bash
docker container start my-vivado-container
```
Then enter to the container:
```bash
docker exec -it my-vivado-container bash
```

------------------

## C. Install Vivado

### 1. Extract archive
Note: Change the name of the tar file based on your downloaded file
```bash
tar zxf Xilinx_Vivado_SDK_2018.3_1207_2324.tar.gz
```

### 2. Run setup
```bash
./Xilinx_Vivado_SDK_2018.3_1207_2324/xsetup --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --batch Install --config installation_config.txt
```

### 3. Add Vivado setting to the shell
```bash
echo "source /home/developer/proj/tools/Xilinx/Vivado/2018.3/settings64.sh" >> /home/developer/.bashrc
```
### 4. Add licence
```bash
cp /path/to/your/licence/Xilinx.lic /home/developer/.Xilinx/
```
------------

## D. Setting up the display

### 1.1 (Option 1) Running with VNC
Note: The VNC image is based on consol/ubuntu-xfce-vnc (see https://hub.docker.com/r/consol/ubuntu-xfce-vnc for more info)

### 1. Download VNC application from cae website
https://opencae.jpl.nasa.gov/portal/#/tool-detail/site__18_0_5_eda034b_1473882873612_377936_85638_cover

### 2. Connect using VNC client
If the container is started as VNC stated above, connect via one of these options:

1. connect via VNC viewer localhost:5901, default password: vncpassword
2. connect via noVNC HTML5 full client: http://localhost:6901/vnc.html, default password: vncpassword
3. connect via noVNC HTML5 lite client: http://localhost:6901/?password=vncpassword



### 1.2 (Option 2) Running with X11
Note: X11 might be slow and not responsive when running Vivado 

### 1. Make sure to install XQuartz
```bash
$ brew install socat
$ brew cask reinstall xquartz
```

### 2. Close any 6000
On a new terminal, verify if there's anything running on port 6000

```bash
$ lsof -i TCP:6000
```
If there is anything, just kill the process

### 3. Open a socket on the port 6000 and keep the terminal open

```bash
$ socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```

### 4. Verify 6000 is open
```bash
$ lsof -i TCP:6000
```

### 5. X11 setup
```bash
defaults write org.x.X11 enable_test_extensions -boolean true
defaults write org.macosforge.xquartz.X11 enable_test_extensions -boolean true
defaults write org.macosforge.xquartz.X11 startx_script -string "/opt/X11/bin/startx -- /opt/X11/bin/Xquartz"
defaults write org.macosforge.xquartz.X11 enable_iglx -bool true
```
Note:
Make sure the output look like the following:
```bash
$ defaults read org.x.X11
{
    "enable_test_extensions" = 1;
}
$ defaults read org.macosforge.xquartz.X11
{
...
    "enable_test_extensions" = 1;
    "startx_script" = "/opt/X11/bin/startx -- /opt/X11/bin/Xquartz";
}
```

------------
## E. Starting LDXE window manager 
To start the X window manager run the following:
```bash
startx

```
## F. Starting Vivado 
If everything is OK you can start Vivado from the comand line by:
```bash
Vivado

```
------------
#### Removing docker container
```bash
docker container stop my-vivado-container
docker container rm my-vivado-container
```

#### Removing docker image
```bash
docker image rm my-vivado-image
```

#### Deleting .DS_Strore files
```bash
find . -name '.DS_Store' -type f -delete
```

#### References
- https://hub.docker.com/r/consol/ubuntu-xfce-vnc/dockerfile
- https://github.com/ConSol/docker-headless-vnc-container
- https://github.com/BBN-Q/vivado-docker
- https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/dockerfile
- https://github.com/meefik/linuxdeploy/issues/978 (no pid issue)
- https://hub.docker.com/r/x11docker/lxde
