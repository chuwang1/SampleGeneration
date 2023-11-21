#!/bin/bash
echo "Starting job on " `date`
echo "Running on: `uname -a`"

echo "i am here ${PWD}"

seed=$((${1} + ${2} + 189))
#seed=123
basePath=${PWD}
# step1=CMSSW_10_6_30_patch1

mkdir -p /eos/cms/store/group/phys_higgs/nonresonant_HH/Run3/NODE/
outDir=/eos/cms/store/group/phys_higgs/nonresonant_HH/Run3/NODE/

[ ! -d "${outDir}" ] && mkdir -p "${outDir}"



if [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el8:amd64" ]; then
  CONTAINER_NAME="el8:amd64"
elif [ -e "/cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/el8:x86_64" ]; then
  CONTAINER_NAME="el8:x86_64"
else
  echo "Could not find amd64 or x86_64 for el8"
  exit 1
fi
# Run in singularity container
# Mount afs, eos, cvmfs
# Mount /etc/grid-security for xrootd
export SINGULARITY_CACHEDIR="/tmp/$(whoami)/singularity"

for i in {1..4}
do
cp Step${i}.sh Step${i}_NODE_run.sh
sed -i "s#mySEED#${seed}#g" Step${i}_NODE_run.sh
sed -i "s#FNAME#NODE#g" Step${i}_NODE_run.sh

echo "Now Step ${i}"
# cat Step${i}_NODE_run.sh
singularity run -B /afs -B /eos -B /cvmfs -B /etc/grid-security -B /etc/pki/ca-trust --home $PWD:$PWD /cvmfs/unpacked.cern.ch/registry.hub.docker.com/cmssw/$CONTAINER_NAME $(echo $(pwd)/Step${i}_NODE_run.sh)
done
$PWD
ls ./

cp HIG-Run3Summer22EEwmLHEGS-00126.root ${outDir}/HIG-Run3Summer22EEwmLHEGS-00126_${seed}.root
cp HIG-Run3Summer22EEDRPremix-00097.root ${outDir}/HIG-Run3Summer22EEDRPremix-00097_${seed}.root
cp HIG-Run3Summer22EEDRPremix-00097_0.root ${outDir}/HIG-Run3Summer22EEDRPremix-00097_0_${seed}.root
cp HIG-Run3Summer22EENanoAODv11-00079.root ${outDir}/HIG-Run3Summer22EENanoAODv11-00079_${seed}.root



echo "Ending job on " `date`
