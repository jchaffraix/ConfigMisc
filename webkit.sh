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
    update-webkit
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

function fetch_attachment()
{
    if [ -z $1 ]
    then
        echo "Need an attachment #"
        return
    fi

    # FIXME: Check that $1 is a number.
    curl -L -o $1.diff "https://bugs.webkit.org/attachment.cgi?id=$1"
}

# Define some alias to be shared.
alias aa="safe_apply_attachment"
alias upw="safe_update_webkit"
alias wp="webkit-patch"
alias wpu="webkit-patch upload"

# Handle distributed computing.
if [ -z $DISTRIBUTED_COMPILING ]
then
    if [[ $OSTYPE =~ "linux" ]]
    then
        NUM_PROCS=`cat /proc/cpuinfo|grep processor|wc -l`
    else
        # FIXME: Hardcoded.
        NUM_PROCS=5
    fi
else
    NUM_PROCS=4000
fi

alias bcd="echo \"Building Chromium Debug\"; build-webkit --debug --chromium --makeargs=\"-j$NUM_PROCS\""
alias bcr="echo \"Building Chromium Release\"; build-webkit --release --chromium --makeargs=\"-j$NUM_PROCS\""
alias bqd="echo \"Building Qt Debug\"; build-webkit --debug --qt --makeargs=\"-j$NUM_PROCS\" --qmakearg=\"CONFIG+=force_static_libs_as_shared\""
alias bqr="echo \"Building Qt Release\"; build-webkit --release --qt --makeargs=\"-j$NUM_PROCS\" --qmakearg=\"CONFIG+=force_static_libs_as_shared\""
