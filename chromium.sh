function logical_core_nums()
{
    echo `cat /proc/cpuinfo|grep processor|wc -l`
}

function setup_Chromium()
{
    export TRYBOT_RESULTS_EMAIL_ADDRESS="jchaffraix@chromium.org"

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
