function logical_core_nums()
{
    echo `cat /proc/cpuinfo|grep processor|wc -l`
}

function setup_Chromium()
{
    export CHROMIUM_ROOT=$HOME/Sources/Chromium/src
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
