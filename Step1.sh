#!/bin/bash

export SCRAM_ARCH=el8_amd64_gcc10

source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_12_4_11_patch3/src ] ; then
  echo release CMSSW_12_4_11_patch3 already exists
else
  scram p CMSSW CMSSW_12_4_11_patch3
fi
cd CMSSW_12_4_11_patch3/src
eval `scram runtime -sh`

# Download fragment from McM
mkdir -p Configuration/GenProduction/python/
cp ../../bbgg_fragment_FNAME.py Configuration/GenProduction/python/HIG-Run3Summer22EEwmLHEGS-00126-fragment_FNAME.py

# Check if fragment contais gridpack path ant that it is in cvmfs
scram b
cat Configuration/GenProduction/python/HIG-Run3Summer22EEwmLHEGS-00126-fragment_FNAME.py
cd ../..

# Maximum validation duration: 28800s
# Margin for validation duration: 30%
# Validation duration with margin: 28800 * (1 - 0.30) = 20160s
# Time per event for each sequence: 42.1234s
# Threads for each sequence: 1
# Time per event for single thread for each sequence: 1 * 42.1234s = 42.1234s
# Which adds up to 42.1234s per event
# Single core events that fit in validation duration: 20160s / 42.1234s = 478
# Produced events limit in McM is 10000
# According to 1.0000 efficiency, validation should run 10000 / 1.0000 = 10000 events to reach the limit of 10000
# Take the minimum of 478 and 10000, but more than 0 -> 478
# It is estimated that this validation will produce: 478 * 1.0000 = 478 events
EVENTS=200

# Random seed between 1 and 100 for externalLHEProducer
SEED="mySEED"


# cmsDriver command
cmsDriver.py Configuration/GenProduction/python/HIG-Run3Summer22EEwmLHEGS-00126-fragment_FNAME.py --python_filename HIG-Run3Summer22EEwmLHEGS-00126_1_cfg_FNAME.py --eventcontent RAWSIM,LHE --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM,LHE --fileout file:HIG-Run3Summer22EEwmLHEGS-00126.root --conditions 124X_mcRun3_2022_realistic_postEE_v1 --beamspot Realistic25ns13p6TeVEarly2022Collision --customise_commands process.RandomNumberGeneratorService.externalLHEProducer.initialSeed="int(${SEED})"\\nprocess.source.numberEventsInLuminosityBlock="cms.untracked.uint32(100)" --step LHE,GEN,SIM --geometry DB:Extended --era Run3 --no_exec --mc -n $EVENTS

export PYTHONPATH=/cvmfs/cms.cern.ch/slc7_amd64_gcc10/external/lhapdf/6.4.0-68defff11ffd434c73727d03802bfb85/lib/python3.9/site-packages/LHAPDF-6.4.0-py3.9-linux-x86_64.egg/:$PYTHONPATH
# Run the cmsRun
cmsRun  HIG-Run3Summer22EEwmLHEGS-00126_1_cfg_FNAME.py seedval=${seed} -n 0; 


# End of HIG-Run3Summer22EEwmLHEGS-00126_test.sh file
