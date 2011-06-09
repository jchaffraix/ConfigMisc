function setup_WebKit() {
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

    # FIXME: Should be conditional!!!
    export WEBKIT_ROOT="$HOME/Sources/WebKit"
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
