#!/bin/bash

force=0
check=0
debug=false

# $debug && set -x

if [ -z "$yocto_base_dir" ]; then
  default_base_dir="${HOME}/rpi"
else
  default_base_dir=$yocto_base_dir
fi
default_project_uri="https://github.com/zerch/meta-haos.git"
default_project_rev="morty"
while getopts "b:cd:r:fp:" OPT; do
  case $OPT in
    b)
      base_dir=$OPTARG
      ;;
    c)
      check=1
      ;;
    d)
      prj_dir=$OPTARG
      ;;
    r)
      project_rev=$OPTARG
      ;;
    f)
      force=1
      ;;
    p)
      project_uri=$OPTARG
      ;;
    *)
      echo "Usage: $(basename $0) [-b <base_dir>] [-d <dir>] [-f] [-c] [-p <project_uri>]"
      echo "  -b <base_dir> Base checkout directory"
      echo "  -d <dir>      Project checkout directory"
      echo "  -f            Force checkout - will wipe project directory if it exists"
      echo "  -c            Check project setup"
      echo "  -p <prj_uri>  Project URI"
      echo "  -r <prj_rev>  Project Revision"
      exit 1
      ;;
  esac
done

echo ------------------------------------------------------------
echo Testing prerequisites

#check repo availability
which repo > /dev/null 2>&1
if  [ $? != 0 ] ; then
  echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  echo You are missing repo tool! Follow instructions on
  echo https://source.android.com/source/downloading.html
  echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  exit 1
fi

echo Done - Successful
echo ------------------------------------------------------------

#start cloning project
if [ "$prj_dir" = "" ] && [ "$base_dir" = "" ]; then
        read -e -p "Enter base directory for Yocto project setup(default: $default_base_dir): " base_dir
        [ "$base_dir" = "" ] && base_dir=$default_base_dir
fi
if [ "$project_uri" = "" ]; then
        read -e -p "Enter project URI(default: $default_project_uri): " project_uri
        [ "$project_uri" = "" ] && project_uri=$default_project_uri
fi
if [ "$project_rev" = "" ]; then
        read -e -p "Enter project URI(default: $default_project_rev): " project_rev
        [ "$project_rev" = "" ] && project_rev=$default_project_rev
fi

if [ "$prj_dir" = "" ]; then
  last_segment=${project_uri##*/}
  prj_dir_name=${last_segment%.*}

  prj_dir=${base_dir%%/}/$prj_dir_name
  read -e -p "Enter project directory(default: $prj_dir): " prj_dir
	[ "${prj_dir}" = "" ] && prj_dir=${base_dir%%/}/${prj_dir_name}
fi

$debug && echo base_dir=${base_dir};
$debug && echo prj_dir=${prj_dir};
$debug && echo prj_dir_name=${prj_dir_name};
$debug && echo project_uri=${project_uri};

if [ -d ${prj_dir} ]; then
  if [ ${force} = 0 ]; then
    echo "Folder ${prj_dir} already exists."
    default_answer="n"
    read -e -p "Wipe the folder and continue [y/N]? " answer
    [ "$answer" = "" ] && answer="$default_answer"
    if [ "$answer" != "Y" -a "$answer" != "y" ]; then
      echo "Setup aborted!"
      exit 1
    fi
  fi
  echo Wiping folder $prj_dir...
  rm -rf "${prj_dir}"
  if [ ! $? ]; then
    echo ------------------------------------------------------------
    echo Failed to wipe folder $prj_dir. Aborting...
    exit 1
  fi
fi
mkdir -p ${prj_dir} >/dev/null 2>&1

cd ${prj_dir}
if [ ! $? ]; then
  echo ------------------------------------------------------------
  echo Failed to create folder ${prj_dir}. Aborting...
  exit 1
fi

echo
echo ------------------------------------------------------------
echo Initializing repo


repo init -u ${project_uri} -b ${project_rev}
if [ ! $? ]; then
  echo Failed to initialize repo. Aborting...
  echo ------------------------------------------------------------
  exit 1
fi
echo Done - Successful 
echo ------------------------------------------------------------

echo ------------------------------------------------------------
echo Synchronizing repo
repo sync -c --no-clone-bundle
if [ ! $? ]; then
  echo Failed to synchronize repo. Aborting...
  echo ------------------------------------------------------------
  exit 1
fi
echo Done - Successful
echo ------------------------------------------------------------

if [ ${check} != 0 ]; then
    echo ------------------------------------------------------------
    echo Check project setup
    source setup-environment
    if [ "$(pwd)" != "${prj_dir}/build" ] ; then
      echo Failed to source the settings. Aborting...
      echo ------------------------------------------------------------
      exit 1
    fi

    bitbake -p
    if [ ! $? ]; then
      echo Failed to check project setup. Aborting...
      echo ------------------------------------------------------------
      unset TEMPLATECONF
      unset BUILDDIR
      exit 1
    fi
    unset TEMPLATECONF
    unset BUILDDIR
    echo Done - Successful
    echo ------------------------------------------------------------
fi

echo ------------------------------------------------------------
echo "The project is set up and synced, to work with it"
echo "please change to project folder and source the settings:"
echo " cd ${prj_dir}"
echo " source setup-environment"
echo ------------------------------------------------------------

