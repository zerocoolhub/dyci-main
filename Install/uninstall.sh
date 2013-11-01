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

echo
echo "======== Removing DYCI Xcode plugin ======="
DYCI_XCODE_PLUGIN_DIR="${USER_HOME}/Library/Application Support/Developer/Shared/Xcode/Plug-ins/SFDYCIPlugin.xcplugin"
if [[ -d  "${DYCI_XCODE_PLUGIN_DIR}" ]]; then
    log "rm -r ${DYCI_XCODE_PLUGIN_DIR}"
    rm -r "${DYCI_XCODE_PLUGIN_DIR}"
else
	echo "== Hm... no DYCI plugin found. Was DYCI really installed?"
	echo 
fi



