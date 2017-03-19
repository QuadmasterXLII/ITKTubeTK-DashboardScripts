#!/bin/sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/Trolltech/Qt-4.8.7/lib
export ITK_BUILD_DIR=$HOME/src/dashboards/ITKTubeTK-Build-Debug/ITK-build
export TubeTK_BUILD_DIR=$HOME/src/dashboards/ITKTubeTK-Build-Debug/TubeTK-build

MachineName=MicroTumorLinux1_Amazon
BuildType=Debug
CTestCommand=/usr/local/bin/ctest
DashboardDir=/home/ubuntu/src/dashboards

echo "Running ITKTubeTK Dashboard script"
if [ $# -eq 0 ] || [ "$1" != "NoUpdate" ]; then

  echo "Updating"
  rm -rf ${DashboardDir}/ITKTubeTK-Build-${BuildType}

  # Update Dashboard repository
  cd ${DashboardDir}/ITKTubeTK-DashboardScripts
  git pull -f

  echo "Bootstrapping"
  # Get new nightly script
  cp -f ${MachineName}_TubeTK_Nightly-${BuildType}.sh ..
  cd ..
  chmod +x ${MachineName}_TubeTK_Nightly-${BuildType}.sh

  # Run new nightly script without updating again
  ./${MachineName}_TubeTK_Nightly-${BuildType}.sh NoUpdate

else

# Run the nightly
echo "Running nightly ctest"
${CTestCommand} -D Nightly -D SITE_CTEST_MODE:STRING=Nightly -D SITE_BUILD_TYPE:STRING=${BuildType} -S ITKTubeTK-DashboardScripts/${MachineName}_TubeTK.cmake -V -VV -O ${MachineName}_TubeTK_Nightly-${BuildType}.log

echo "Running continuous ctest"
${CTestCommand} -D Continuous -D SITE_CTEST_MODE:STRING=Continuous -D SITE_BUILD_TYPE:STRING=${BuildType} -S ITKTubeTK-DashboardScripts/${MachineName}_TubeTK.cmake -V -VV -O ${MachineName}_TubeTK_Continuous-${BuildType}.log

fi

echo "Ending ITKTubeTK dashboard script"
