function setup_Blink_Env()
{
    if [ -z $1 ]
    then
        echo "Need a WebKit root directory!"
        return 1
    fi

    export CHROMIUM_ROOT=$1
    export PATH=$PATH:$CHROMIUM_ROOT/third_party/WebKit/Tools/Scripts

    # Force the component build, better for incremental builds.
    export GYP_DEFINES+=" component=shared_library"

    cd $CHROMIUM_ROOT
}

function update_Blink()
{
    git pull -r && gclient sync
}

# Define some alias to be shared.
alias upb="update_Blink"
alias gcp="git cl patch"
alias gcu="git cl upload"

function blink_move_to() {
    if [ -z $1 ]
    then
        cd $CHROMIUM_ROOT
        return 0
    fi

    # Handle web.
    if [ $1 = "web" ]
    then
        cd "$CHROMIUM_ROOT/third_party/WebKit/Source/web"
        return 0
    fi

    directory="$CHROMIUM_ROOT/third_party/WebKit/Source/core/$1"
    if [ -d $directory ]
    then
        cd $directory
        return 0
    else
        echo "Unknow directory $directory"
        return 1
    fi
}

alias cb=blink_move_to

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
    export GYP_DEFINES="$GYP_DEFINES use_goma=1"
    if [[ $OSTYPE =~ "darwin" ]]
    then
        NUM_PROCS=80
    else
        NUM_PROCS=4000
    fi
fi

alias bbd="echo \"Building Blink Debug\"; ninja -Cout/Debug -j$NUM_PROCS blink_tests"
alias bbr="echo \"Building Blink Release\"; ninja -Cout/Release -j$NUM_PROCS blink_tests"
alias bcd="echo \"Building Chrome Debug\"; ninja -Cout/Debug -j$NUM_PROCS chrome"
alias bcr="echo \"Building Chrome Release\"; ninja -Cout/Release -j$NUM_PROCS chrome"
