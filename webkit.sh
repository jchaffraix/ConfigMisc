function setup_WebKit_Env() {
    if [ -z $1 ]
    then
        echo "Need a WebKit root directory!"
        return 1
    fi

    # Needed by WebKit to run DRT.
    # FIXME: Qt specific?
    if [[ $OSTYPE =~ "linux" ]]
    then
        # Qt for now.
        export PATH=$HOME/Deps/bin:$PATH
        export QTDIR=$HOME/Deps/

        xhost +local: > /dev/null 2>&1
    fi

    ### Webkit Info
    export CHANGE_LOG_NAME="Julien Chaffraix"
    export EMAIL_ADDRESS="jchaffraix@webkit.org"

    export WEBKIT_ROOT=$1
    export PATH=$PATH:$WEBKIT_ROOT/Tools/Scripts

    export SVN_EDITOR="commit-log-editor"
    export GIT_EDITOR="commit-log-editor"

    cd $WEBKIT_ROOT
}

function safe_update_webkit()
{
    # FIXME: Check for some scripts if not setup_WebKit called?
    if [[ $OSTYPE =~ "darwin" ]]
    then
        echo "mac"
        update-webkit --mac
    fi

    update-webkit --chromium
}

# Apply an attachment making sure Chromium is up-to-date.
function safe_apply_attachment()
{
    if [ -z $1 ]
    then
        echo "Need a attachment id"
        return
    fi
    webkit-patch apply-attachment $1
    update-webkit-chromium
}
