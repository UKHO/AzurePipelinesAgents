echo "update apt"
apt update

echo "install docker"
apt install -y docker.io

echo "install docker-compose"
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "install maven"
apt install -y maven

cd /usr/lib

echo "create agent directory"
mkdir agt

# Loop for Agents pool
for i in `seq 1 $5`
do

"Setup for Agent $i on $4"
cd /usr/lib/agt

dir=$4-A$i
mkdir $dir

cd $dir

mkdir _work

echo "download agent"
curl https://vstsagentpackage.azureedge.net/agent/2.150.3/vsts-agent-linux-x64-2.150.3.tar.gz | tar zx

echo "set permissions on agent directory"
chmod 755 -R .

echo "allow agent run as root"
export AGENT_ALLOW_RUNASROOT="YES"

echo "configure agent"
./config.sh --unattended --url https://dev.azure.com/$1 --auth PAT --token $2 --pool "$3 Agents" --agent $dir --acceptTeeEula --work _work

echo "install service for Agent $i on $4"
./svc.sh install

echo "start service for Agent $i on $4"
./svc.sh start
done

# Loop for Ubuntu 1804 pool
for i in `seq 1 $5`
do

"Setup for Agent $i on $4"
cd /usr/lib/agt

dir=$4-B$i
mkdir $dir

cd $dir

mkdir _work

echo "download agent"
curl https://vstsagentpackage.azureedge.net/agent/2.150.3/vsts-agent-linux-x64-2.150.3.tar.gz | tar zx

echo "set permissions on agent directory"
chmod 755 -R .

echo "allow agent run as root"
export AGENT_ALLOW_RUNASROOT="YES"

echo "configure agent"
./config.sh --unattended --url https://dev.azure.com/$1 --auth PAT --token $2 --pool "$3 Ubuntu 1804" --agent $dir --acceptTeeEula --work _work

echo "install service for Agent $i on $4"
./svc.sh install

echo "start service for Agent $i on $4"
./svc.sh start
done

# Install .Net Core SDK
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

add-apt-repository universe
apt-get update
apt-get install apt-transport-https
apt-get update
apt-get install dotnet-sdk-3.1

# Download and extract azurevmagentservice
servicepath=/usr/local/bin/azurevmagentdrainer
mkdir -p $servicepath
curl -L https://github.com/ukho/azdoagentdrainer/releases/latest/download/azurevmagentservice.tar.gz | tar zx -C $servicepath

# Creat the service file
cat > /etc/systemd/system/azurevmagentdrainer.service << EOF
[Unit]
Description=Azure Pipelines Agent Draienr

[Service]
Type=notify
WorkingDirectory=$servicepath
ExecStart=dotnet $servicepath/AzureVmAgentsService.dll --drainer:uri=https://dev.azure.com/$1 --drainer:pat=$2
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

# enable on restarts
systemctl enable azurevmagentdrainer.service
systemctl start azurevmagentdrainer.service