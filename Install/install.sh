#!/bin/bash

# ============= Logging support ======================
_V=0

while getopts "v" OPTION
do
  case $OPTION in
    v) _V=1
       ;;
  esac
done


function log () {
    if [[ $_V -eq 1 ]]; then
        echo
        echo "$@"
    fi
}

# ============= Logging support ends ======================

# determining from which directory script is executed
DIR="$( cd -P "$( dirname "$0" )" && pwd )"
# going to that directory
cd "${DIR}"
cd ..

chmod +x Scripts/dyci-recompile.rb

USER_HOME=$(eval echo ~${SUDO_USER})
log "USER_HOME = ${USER_HOME}"

DYCI_ROOT_DIR="${USER_HOME}/.dyci"
log "DYCI_ROOT_DIR='${USER_HOME}/.dyci'" 

#Copying scripts
echo -n "== Copying scripts : "
cp Scripts/dyci-recompile.rb "${DYCI_ROOT_DIR}/scripts/"

echo "Done."

if [[ -d "${USER_HOME}/Library/Preferences/appCode20" ]]; then
  echo -n "== AppCode found. Installing DYCI as AppCode plugin : "

  PLUGINS_DIRECTORY="${USER_HOME}/Library/Application Support/appCode20"    
  PLUGIN_NAME="Dyci Plugin.jar"
  if [[ ! -d "${PLUGINS_DIRECTORY}" ]]; then
     mkdir -p "${PLUGINS_DIRECTORY}"
  fi

  log "cp Support/AppCode/${PLUGIN_NAME} ${PLUGINS_DIRECTORY}"
  cp "Support/AppCode/${PLUGIN_NAME}" "${PLUGINS_DIRECTORY}"/

  echo "Done."

  echo "   Restart Appcode. Plugin should be loaded automaticaly. If not, you may need to install it manually"

fi

echo -n "== Installing Xcode DYCI plugin : "
if [[ ! -d "${USER_HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins" ]]; then
    mkdir -p "${USER_HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
fi

cp -R Support/Xcode/Binary/*.* "${USER_HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins/"
echo Done. 
echo "  Now you can use DYCI from the Xcode :P (^X)"


echo
echo "DYCI was successfully installed!"
echo