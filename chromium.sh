function logical_core_nums()
{
    echo `cat /proc/cpuinfo|grep processor|wc -l`
}

function setup_Chromium()
{
    export TRYBOT_RESULTS_EMAIL_ADDRESS="jchaffraix@chromium.org"

    # Enable profiling by default
    export GYP_DEFINES="$GYP_DEFINES profiling=1"

    export CHROMIUM_ROOT=$HOME/Sources/Chromium/src
    export WEBKIT_ROOT=$CHROMIUM_ROOT/third_party/WebKit/
    export PATH=$PATH:$WEBKIT_ROOT/Tools/Scripts
    cd $CHROMIUM_ROOT
}

# FIXME: Merge the 2 build methods!
function build_all()
{
    if [ ! -d "build" ]
    then
        echo "Not in the Chromium root!"
        return 1
    fi
    if [[ $OSTYPE =~ "darwin" ]]
    then
        pushd build/
        xcodebuild -project all.xcodeproj -configuration Debug -target All
        popd
    elif [[ $OSTYPE =~ "linux" ]]
    then
        make -j$(logical_core_nums)
    fi
}

function build_chromium()
{
    if [ ! -d "build" ]
    then
        echo "Not in the Chromium root!"
        return 1
    fi
    if [[ $OSTYPE =~ "darwin" ]]
    then
        pushd chrome/
        xcodebuild -project chrome.xcodeproj -configuration Debug -target chrome
        popd
    elif [[ $OSTYPE =~ "linux" ]]
    then
        make -j$(logical_core_nums) chrome
    fi
}

function update_chromium()
{
    if [ ! -d "build" ]
    then
        echo "Not in the Chromium root!"
        return 1
    fi

    gclient sync

    if [ -d $WEBKIT_ROOT/.git ]
    then
        tools/sync-webkit-git.py
    fi
}

function profile_test_shell()
{
    if [ ! -d "build" ]
    then
        echo "Not in the Chromium root!"
        return 1
    fi

    if [ -z $1 ]
    then
        echo "USage profile_test_shell URL";
        return 1
    fi

    # FIXME: Debug is hardcoded and we don't check for compiled bits!
    url=`echo $1 | sed -e 's/\&/\\\&/'`
    out/Debug/test_shell --profiler "javascript:(new chromium.Profiler).start(); window.location=\"$url\""
}
