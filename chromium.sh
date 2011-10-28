function logical_core_nums()
{
    echo `cat /proc/cpuinfo|grep processor|wc -l`
}

function setup_ASAN_build()
{
    export GYP_DEFINES="$GYP_DEFINES asan=1 linux_use_tcmalloc=0 release_extra_cflags=\"-g\""

    # ASAN
    export ASAN=$CHROMIUM_ROOT/third_party/asan
    export ASAN_BIN=$ASAN/asan_clang_Linux/bin
    export BLACKLIST="-mllvm -asan-blacklist=$ASAN/asan_blacklist.txt"
    export CC="$ASAN_BIN/clang $BLACKLIST"
    export CXX="$ASAN_BIN/clang++ $BLACKLIST"
    if [ ! -d $ASAN ]
    then
        update_chromium
        if [ ! -d $ASAN ]
        then
            echo "Error: ASAN not installed. Make sure you follow the instruction to set it up."
            return 1
        fi
    fi
    gclient runhooks
}

function setup_Chromium_Env()
{
    if [ -z $1 ]
    then
        echo "Need a Chromium root directory!"
        return 1
    fi


    export TRYBOT_RESULTS_EMAIL_ADDRESS="jchaffraix@chromium.org"

    # Enable profiling by default but not ASAN (it slows down debug builds and can break the build)
    export GYP_DEFINES="$GYP_DEFINES profiling=1"
    # Use those to enable heapchecker. For now it is too fragile!
    #export GYP_DEFINES="$GYP_DEFINES linux_use_heapchecker=1 linux_keep_shadow_stacks=1 linux_use_tcmalloc=1"

    ### Webkit Info
    # FIXME: Share them somehow.
    export CHROMIUM_ROOT=$1
    export CHANGE_LOG_NAME="Julien Chaffraix"
    export EMAIL_ADDRESS="jchaffraix@webkit.org"

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

    # --delete_unversioned: delete any dependency that have been removed from
    # last sync as long as there is no local modification (from the help).
    gclient sync --delete_unversioned

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

    profile_test_shell "out/Release" $1
}

function profile_test_shell()
{
    if [ -z $1 ]
    then
        echo "Need a build directory!"
        return 1
    fi
    if [ -z $2 ]
    then
        echo "Usage profile_test_shell URL";
        return 1
    fi

    # FIXME: Debug is hardcoded and we don't check for compiled bits!
    url=`echo $2 | sed -e 's/\&/\\\&/'`
    $1/test_shell --profiler "javascript:(new chromium.Profiler).start(); window.location=\"$url\""
}
