function setup_Blink_Env()
{
    if [ -z $1 ]
    then
        echo "Need a WebKit root directory!"
        return 1
    fi

    export CHROMIUM_ROOT=$1
    export PATH=$PATH:$CHROMIUM_ROOT/third_party/WebKit/Tools/Scripts

    cd $CHROMIUM_ROOT
}

function update_Blink()
{
    git pull -r && pushd third_party/WebKit/ && git pull -r && popd && gclient sync
}

# Define some alias to be shared.
alias aa="git cl patch"
alias upb="gclient sync"
alias up="git cl upload"

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
    if [[ $OSTYPE =~ "darwin" ]]
    then
        NUM_PROCS=80
    else
        NUM_PROCS=100
    fi
fi

alias bbd="echo \"Building Blink Debug\"; ninja -Cout/Debug -j$NUM_PROCS blink_tests"
alias bbr="echo \"Building Blink Release\"; ninja -Cout/Release -j$NUM_PROCS blink_tests"
alias bcd="echo \"Building Chrome Debug\"; ninja -Cout/Debug -j$NUM_PROCS chrome"
alias bcr="echo \"Building Chrome Release\"; ninja -Cout/Release -j$NUM_PROCS chrome"
alias upb="update_Blink"
