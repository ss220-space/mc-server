@ECHO off

SET JAVA="java"
SET MINECRAFT="1.18.2"
SET FABRIC="0.14.7"
SET INSTALLER="0.10.2"
SET ARGS="-Xmx5G"
SET OTHERARGS="-Dlog4j2.formatMsgNoLookups=true"

IF NOT EXIST fabric-server-launch.jar (

  ECHO Fabric Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.fabricmc.net/net/fabricmc/fabric-installer/%INSTALLER%/fabric-installer-%INSTALLER%.jar', 'fabric-installer.jar')"

  IF EXIST fabric-installer.jar (

    ECHO Installer downloaded. Installing...
    java -jar fabric-installer.jar server -mcversion %MINECRAFT% -loader %FABRIC% -downloadMinecraft

    IF EXIST fabric-server-launch.jar (
      RMDIR /S /Q .fabric-installer
      DEL fabric-installer.jar
      ECHO Installation complete. fabric-installer.jar and installation files deleted.
    )

  ) ELSE (
    ECHO fabric-installer.jar not found. Maybe the Fabric servers are having trouble.
    ECHO Please try again in a couple of minutes.
  )
) ELSE (
  ECHO fabric-server-launch.jar present. Moving on...
)

IF NOT EXIST eula.txt (
  ECHO eula=true>> eula.txt
) ELSE (
  ECHO eula.txt present. Moving on...
)

ECHO Starting server...
ECHO Minecraft version: %MINECRAFT%
ECHO Fabric version: %FABRIC%
ECHO Java version:
%JAVA% --version
ECHO Java args: %ARGS%

%JAVA% "%OTHERARGS%" %ARGS% -jar fabric-server-launch.jar nogui

PAUSE