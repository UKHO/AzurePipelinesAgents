echo "stop service"
cd /usr/lib/agent
sudo ./svc.sh stop

echo "uninstall service"
sudo ./svc.sh uninstall

echo "allow agent run as root"
export AGENT_ALLOW_RUNASROOT="YES"

echo "remove from registry"
./config.sh remove --auth PAT --token $1

cd ~

echo "remove agent"
sudo rm -rf /usr/lib/agent
