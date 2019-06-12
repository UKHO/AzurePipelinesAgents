echo "install docker"
apt install -y docker.io

cd /usr/lib

echo "create agent directory"
mkdir agent

cd agent

mkdir _work

echo "download agent"
curl https://vstsagentpackage.azureedge.net/agent/2.150.3/vsts-agent-linux-x64-2.150.3.tar.gz | tar zx

echo "set permissions on agent directory"
chmod 755 -R .

echo "allow agent run as root"
export AGENT_ALLOW_RUNASROOT="YES"

echo "configure agent"
./config.sh --unattended --url https://dev.azure.com/$1 --auth PAT --token $2 --pool "$3" --agent $4 --acceptTeeEula --work _work

echo "install service"
./svc.sh install

echo "start service"
./svc.sh start
