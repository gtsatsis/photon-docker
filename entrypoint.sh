EXTERNAL_IP=${EXTERNAL_IP:=10.0.0.1}
CONTAINER_IP=$(hostname -i)

rm -f /tmp/.X99-lock # Remove a possibly-missing lock
Xvfb :99 -screen 0 640x480x8 -nolisten tcp &

# IP address configuration
sed -i "s/127.0.0.1/$CONTAINER_IP/g" /home/wine/photon/deploy/bin_Win64/PhotonServer.config
sed -i "s/127.0.0.1/$CONTAINER_IP/g" /home/wine/photon/deploy/LoadBalancing/GameServer/bin/GameServer.xml.config
sed -i "s/<PublicIPAddress>$CONTAINER_IP<\/PublicIPAddress>/<PublicIPAddress>$EXTERNAL_IP<\/PublicIPAddress>/g" /home/wine/photon/deploy/LoadBalancing/GameServer/bin/GameServer.xml.config

cd /home/wine/photon/deploy/bin_Win64
DISPLAY=:99 wine PhotonSocketServer.exe /debug LoadBalancing

tail -f log/*.log
