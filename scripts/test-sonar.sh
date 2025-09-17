#!/usr/bin/env bash

source ~/.config/sonarqube/config.env

echo "$SONAR_JAVA_PATH"

# [Install]
# WantedBy=default.target
#
# [Service]
# EnvironmentFile=%h/.config/sonarqube/config.env
# ExecStart=/nix/store/49xyhdc622s326wj6xykvazpdb9ppzyr-openjdk-minimal-jre-21.0.7+6/bin/java \
#   -Xmx2G -Xms512M \
#   -jar /nix/store/f3cqwxxpj84jna33kyabrdrxdca0qf8s-source/lib/sonar-application-25.9.0.112764.jar
#
# LimitNOFILE=65536
# LimitNPROC=8192
# Restart=on-failure
# RestartSec=10s
# WorkingDirectory=/nix/store/f3cqwxxpj84jna33kyabrdrxdca0qf8s-source
#
# [Unit]
# After=syslog.target
# After=network.target
# Description=SonarQube Service
# Wants=network.target

cd ~/.local/share/sonarqube

/nix/store/49xyhdc622s326wj6xykvazpdb9ppzyr-openjdk-minimal-jre-21.0.7+6/bin/java \
  -Xmx2G -Xms512M \
  -jar /nix/store/f3cqwxxpj84jna33kyabrdrxdca0qf8s-source/lib/sonar-application-25.9.0.112764.jar
