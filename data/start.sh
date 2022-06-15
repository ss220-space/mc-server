#!/usr/bin/env bash

JAVA="java"
MINECRAFT="1.18.2"
FABRIC="0.14.6"
INSTALLER="0.10.2"
ARGS="-Xms8G -Xmx8G -XX:+UnlockExperimentalVMOptions -XX:+UseShenandoahGC -XX:ShenandoahGCMode=iu -XX:+UseNUMA -XX:+AlwaysPreTouch -XX:-UseBiasedLocking -XX:+DisableExplicitGC -Dfile.encoding=UTF-8"
OTHERARGS="-Dlog4j2.formatMsgNoLookups=true"

if [[ ! -s "fabric-server-launch.jar" ]];then

  echo "Fabric Server JAR-file not found. Downloading installer...";
  wget -O fabric-installer.jar https://maven.fabricmc.net/net/fabricmc/fabric-installer/$INSTALLER/fabric-installer-$INSTALLER.jar;

  if [[ -s "fabric-installer.jar" ]];then

    echo "Installer downloaded. Installing...";
    java -jar fabric-installer.jar server -mcversion $MINECRAFT -loader $FABRIC -downloadMinecraft;

    if [[ -s "fabric-server-launch.jar" ]];then
      rm -rf .fabric-installer;
      rm -f fabric-installer.jar;
      echo "Installation complete. fabric-installer.jar deleted.";
    fi

  else
    echo "fabric-installer.jar not found. Maybe the Fabric server are having trouble.";
    echo "Please try again in a couple of minutes.";
  fi
else
  echo "fabric-server-launch.jar present. Moving on...";
fi

if [[ ! -s "eula.txt" ]];then
  echo "eula=true" >> eula.txt;
else
  echo "eula.txt present. Moving on...";
fi

echo "Starting server...";
echo "Minecraft version: $MINECRAFT";
echo "Fabric version: $FABRIC";
echo "Java version:"
$JAVA -version
echo "Java args: $ARGS";

$JAVA $OTHERARGS $ARGS -jar fabric-server-launch.jar nogui