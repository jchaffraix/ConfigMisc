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

# Update WebKit and make sure Chromiue is up-to-date.
function safe_update_webkit()
{
    # FIXME: Check if update-webkit is in the path?
    extra_flags=""
    if [[ $OSTYPE =~ "darwin" ]]
    then
        extra_flags+="--mac"
    fi

    update-webkit $extra_flags
    if [ $? -ne 0 ]
    then
        return;
    fi
    update-webkit-chromium
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
    if [ $? -ne 0 ]
    then
        return;
    fi
    update-webkit-chromium
}

function debug_chromium()
{
    if [ -z $1 ]
    then
        echo "Need to know what to debug"
        return
    fi

    if [[ $1 =~ "^/" ]]
    then
        pass=`pwd`
        $1 = $pass/$1
    fi

    gdb --args out/Debug/DumpRenderTree --no-timeout $1
}

