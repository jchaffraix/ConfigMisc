function logical_core_nums()
{
    echo `cat /proc/cpuinfo|grep processor|wc -l`
}

function setup_Chromium()
{
    export TRYBOT_RESULTS_EMAIL_ADDRESS="jchaffraix@chromium.org"

    # Enable profiling by default
    export GYP_DEFINES="$GYP_DEFINES profiling=1"

    ### Webkit Info
    # FIXME: Share them somehow.
    export CHANGE_LOG_NAME="Julien Chaffraix"
    export EMAIL_ADDRESS="jchaffraix@webkit.org"

    export CHROMIUM_ROOT=$HOME/Sources/Chromium/src
    export WEBKIT_ROOT=$CHROMIUM_ROOT/third_party/WebKit/
    export PATH=$PATH:$WEBKIT_ROOT/Tools/Scripts
    cd $CHROMIUM_ROOT
}

# FIXME: Should be internal.
function build() {
    if [ -z $1 ]
    then
        echo "Need the build type!"
        return 1
    fi

    if [ -z $2 ]
    then
        echo "Need the build target!"
        return 2
    fi

    if [[ $OSTYPE =~ "darwin" ]]
    then
        xcodebuild -project all.xcodeproj -configuration $1 -target $2
    elif [[ $OSTYPE =~ "linux" ]]
    then
        make BUILDTYPE=$1 -j$(logical_core_nums) $2
    fi
    
}

function build_all()
{
    if [ ! -d "build" ]
    then
        echo "Not in the Chromium root!"
        return 1
    fi
    build "Debug" "All";
}

function build_chromium()
{
    if [ ! -d "build" ]
    then
        echo "Not in the Chromium root!"
        return 1
    fi
    build "Debug" "Chrome";
    return $?
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

function prof_release_test_shell()
{
    if [ ! -d "build" ]
    then
        echo "Not in the Chromium root!"
        return 1
    fi

    profile_test_shell "Release" $1
}

function profile_test_shell()
{
    if [ -z $1 ]
    then
        echo "Need a build type!"
        return 1
    fi
    if [ -z $2 ]
    then
        echo "Usage profile_test_shell URL";
        return 1
    fi

    # FIXME: Debug is hardcoded and we don't check for compiled bits!
    url=`echo $2 | sed -e 's/\&/\\\&/'`
    out/$1/test_shell --profiler "javascript:(new chromium.Profiler).start(); window.location=\"$url\""
}
