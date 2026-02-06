#!/usr/bin/env bash
#set -euo pipefail

sudo mkdir -p /opt/jenkins
sudo useradd -m -d /opt/jenkins -s /bin/bash jenkins
sudo wget -O /opt/jenkins/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war
sudo chown -R jenkins:jenkins /opt/jenkins

sudo tee /etc/systemd/system/jenkins.service > /dev/null <<EOF
[Unit]
Description=Jenkins CI
After=network.target

[Service]
User=jenkins
Group=jenkins
ExecStart=/usr/bin/java -jar /opt/jenkins/jenkins.war
Restart=always
Environment="JENKINS_HOME=/opt/jenkins"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

sudo apt update
sudo apt install -y openjdk-17-jre
java -version
sudo -u jenkins cat /opt/jenkins/secrets/initialAdminPassword || echo "(Not yet generated, check later)"