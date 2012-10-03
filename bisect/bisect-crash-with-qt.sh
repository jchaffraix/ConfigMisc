#!/bin/sh

# FIXME: Warn if no QTDIR!

if [ $# -eq "0" ]
then
    echo "Which URL should I test?"
    # Abort git-bisect.
    exit 266
fi

url=$0

# Handle older version of WebKit by faking a Tools directory.
# Needed by Qt to run the tests.
needsCleanup="0"
if [ ! -d Tools ]
then
    needsCleanup="1"
    ln -s WebKitTools Tools
    export PATH=$PATH:Tools/Scripts
fi

# FIXME: Handle release / debug
BUILD_TYPE="release"
# Bash syntax to capitalize the first letter.
BUILD_DIR="${BUILD_TYPE[@]^}"

# Do a clean build to avoid any bad previous state.
rm -rf WebKitBuild/$BUILD_DIR/
Tools/Scripts/build-webkit --$BUILD_TYPE --qt --makeargs="-j15" || exit 125

# FIXME: Externalize the URL to reuse that script!
WebKitBuild/$BUILD_DIR/bin/DumpRenderTree $1

returnCode=$?

if [ "x$needsCleanUp" = "x1" ]
then
    rm -f Tools
fi

echo "Got -> $returnCode"
if [ $returnCode -ne 0 ]
then
    returnCode=1
fi

echo "Returning -> $returnCode"

# Start the DBUS session that is needed by notify-send
# FIXME: Should be guarded somehow?
eval `dbus-launch --sh-syntax --exit-with-session`
notify-send -i gtk-dialog-info -t 5000 "Finished" "Script done with return code -> $returnCode"

if [ $? -ne 0 ]
then
    # Desperate attempt to notify that something is definitely wrong!
    echo "notify send failed!" | wall
fi

exit $returnCode
