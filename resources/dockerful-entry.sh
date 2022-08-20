#!/bin/sh
# Startup script for Docker image "yanwk/barotrauma-server:dockerful"
# by: <code@yanwk.fun>

set -eu

# Check persistence volume.
# Create files if not exist.
# Edit settings according to ENV variables.
echo "Checking dicretory on persistence volume..."
mkdir -p "${MOUNTPATH}/configs"
mkdir -p "${MOUNTPATH}/mods"
mkdir -p "${MOUNTPATH}/submarines"
mkdir -p "${MOUNTPATH}/multiplayer-saves"

LC_PLAYERCONF=${GAMEPATH}/config_player.xml
LC_SERVERSETT=${GAMEPATH}/serversettings.xml
LC_CLIENTPERM=${GAMEPATH}/Data/clientpermissions.xml
LC_KARMASETTG=${GAMEPATH}/Data/karmasettings.xml

MNT_PLAYERCONF=${MOUNTPATH}/configs/config_player.xml
MNT_SERVERSETT=${MOUNTPATH}/configs/serversettings.xml
MNT_CLIENTPERM=${MOUNTPATH}/configs/clientpermissions.xml
MNT_KARMASETTG=${MOUNTPATH}/configs/karmasettings.xml

TMPL_CLIENTPERM=${SCRIPTPATH}/template_clientpermissions.xml

##############################
# config_player.xml
##############################
if [ ! -f "${MNT_PLAYERCONF}" ] ; then
    echo "Creating new <config_player.xml>."
    cp "${LC_PLAYERCONF}" "${MNT_PLAYERCONF}"
    if [ -n "${DEFAULT_LANGUAGE}" ] ; then
        echo "DEFAULT_LANGUAGE is set, changing language setting."
        sed -i "s/language=.*/language=\"${DEFAULT_LANGUAGE}\"/" "${MNT_PLAYERCONF}"
    fi ;
fi ;

if [ -n "${FORCE_LANGUAGE}" ] ; then
    echo "FORCE_LANGUAGE is set, changing language setting."
    sed -i "s/language=.*/language=\"${FORCE_LANGUAGE}\"/" "${MNT_PLAYERCONF}"
fi ;

##############################
# serversettings.xml
##############################
if [ ! -f "${MNT_SERVERSETT}" ] ; then
    echo "Creating new <serversettings.xml>."
    cp "${LC_SERVERSETT}" "${MNT_SERVERSETT}"

    if [ -n "${DEFAULT_SERVERNAME}" ] ; then
        echo "DEFAULT_SERVERNAME is set, changing in-game display server name."
        sed -i "s/name=.*/name=\"${DEFAULT_SERVERNAME}\"/" "${MNT_SERVERSETT}"
    fi ;
    if [ -n "${DEFAULT_PASSWORD}" ] ; then
        echo "DEFAULT_PASSWORD is set, changing server password."
        sed -i "s/password=.*/password=\"${DEFAULT_PASSWORD}\"/" "${MNT_SERVERSETT}"
    fi ;
    if [ -n "${DEFAULT_PUBLICITY}" ] ; then
        echo "DEFAULT_PUBLICITY is set, server publicity will be ${DEFAULT_PUBLICITY}."
        sed -i "s/public=.*/public=\"${DEFAULT_PUBLICITY}\"/" "${MNT_SERVERSETT}"
    fi ;
fi ;

if [ -n "${FORCE_SERVERNAME}" ] ; then
    echo "FORCE_SERVERNAME is set, changing in-game display server name."
    sed -i "s/name=.*/name=\"${FORCE_SERVERNAME}\"/" "${MNT_SERVERSETT}"
fi ;
if [ -n "${FORCE_PASSWORD}" ] ; then
    echo "FORCE_PASSWORD is set, changing server password."
    sed -i "s/password=.*/password=\"${FORCE_PASSWORD}\"/" "${MNT_SERVERSETT}"
fi ;
if [ -n "${FORCE_PUBLICITY}" ] ; then
    echo "FORCE_PUBLICITY is set, server publicity will be ${FORCE_PUBLICITY}."
    sed -i "s/public=.*/public=\"${FORCE_PUBLICITY}\"/" "${MNT_SERVERSETT}"
fi ;

##############################
# clientpermissions.xml
##############################
if [ ! -f "${MNT_CLIENTPERM}" ] ; then
    echo "Creating new <clientpermissions.xml>."
    if [ -n "${DEFAULT_OWNER_STEAMNAME}" ] && [ -n "${DEFAULT_OWNER_STEAMID}" ] ; then
        echo "DEFAULT_OWNER_STEAMNAME and DEFAULT_OWNER_STEAMID are both set, changing in-game server admin."
        cp "${TMPL_CLIENTPERM}" "${MNT_CLIENTPERM}"
        sed -i "s/name=BARO_OWNER_STEAMNAME/name=\"${DEFAULT_OWNER_STEAMNAME}\"/"   "${MNT_CLIENTPERM}"
        sed -i "s/steamid=BARO_OWNER_STEAMID/steamid=\"${DEFAULT_OWNER_STEAMID}\"/" "${MNT_CLIENTPERM}"
    else 
        cp "${LC_CLIENTPERM}" "${MNT_CLIENTPERM}"
    fi ;
fi ;

if [ -n "${FORCE_OWNER_STEAMNAME}" ] && [ -n "${FORCE_OWNER_STEAMID}" ] ; then
    echo "FORCE_OWNER_STEAMNAME and FORCE_OWNER_STEAMID are both set, changing in-game server admin."
    cp "${TMPL_CLIENTPERM}" "${MNT_CLIENTPERM}"
    sed -i "s/name=BARO_OWNER_STEAMNAME/name=\"${FORCE_OWNER_STEAMNAME}\"/"   "${MNT_CLIENTPERM}"
    sed -i "s/steamid=BARO_OWNER_STEAMID/steamid=\"${FORCE_OWNER_STEAMID}\"/" "${MNT_CLIENTPERM}"
fi

##############################
# karmasettings.xml
##############################
if [ ! -f "${MNT_KARMASETTG}" ] ; then
    echo "Creating new <karmasettings.xml>."
    cp "${LC_KARMASETTG}" "${MNT_KARMASETTG}"
fi ;

##############################

echo "Linking files to persistence volume..."

rm "${LC_PLAYERCONF}"
rm "${LC_SERVERSETT}"
rm "${LC_CLIENTPERM}"
rm "${LC_KARMASETTG}"

ln -s "${MNT_PLAYERCONF}" "${LC_PLAYERCONF}"
ln -s "${MNT_SERVERSETT}" "${LC_SERVERSETT}"
ln -s "${MNT_CLIENTPERM}" "${LC_CLIENTPERM}"
ln -s "${MNT_KARMASETTG}" "${LC_KARMASETTG}"

# Try copy (but not overwrite) local directory to persistence volume.
# Then delete and make symlink.
mkdir -p "${GAMEPATH}/Submarines/Added/."

cp -nR "${GAMEPATH}/LocalMods/."             "${MOUNTPATH}/mods/"
cp -nR "${GAMEPATH}/Submarines/Added/." "${MOUNTPATH}/submarines"
cp -nR "${SAVEPATH}/."                  "${MOUNTPATH}/multiplayer-saves"

rm -rf "${GAMEPATH}/LocalMods"
rm -rf "${GAMEPATH}/Submarines/Added"
rm -rf "${SAVEPATH}"

ln -sf "${MOUNTPATH}/mods"              "${GAMEPATH}/LocalMods"
ln -sf "${MOUNTPATH}/submarines"        "${GAMEPATH}/Submarines/Added"
ln -sf "${MOUNTPATH}/multiplayer-saves" "${SAVEPATH}"

echo "Starting Barotrauma Dedicated Server..."

"${GAMEPATH}/DedicatedServer"
