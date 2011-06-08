function setup_WebKit() {
    # Qt for now.
    export PATH=$HOME/Deps/bin:$PATH
    export QTDIR=$HOME/Deps/

    # Needed by WebKit to run DRT.
    # FIXME: Qt specific?
    if [[ $OSTYPE =~ "linux" ]]
    then
        xhost +local: > /dev/null 2>&1
    fi

    ### Webkit Info
    export CHANGE_LOG_NAME="Julien Chaffraix"
    export EMAIL_ADDRESS="jchaffraix@webkit.org"

    # FIXME: Should be conditional!!!
    export WEBKIT_ROOT="$HOME/Sources/WebKit"
    export SVN_EDITOR="$WEBKIT_ROOT/Tools/Scripts/commit-log-editor"

    cd $WEBKIT_ROOT
}
