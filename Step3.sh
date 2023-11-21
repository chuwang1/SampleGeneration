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
mkdir -p  Configuration/GenProduction/python/
# cp WORKDIR/bbgg_fragment_FNAME.py Configuration/GenProduction/python/HIG-Run3Summer22EEMiniAODv3-00102-fragment.py

# Check if fragment contais gridpack path ant that it is in cvmfs

scram b
cd ../..

# Maximum validation duration: 28800s
# Margin for validation duration: 30%
# Validation duration with margin: 28800 * (1 - 0.30) = 20160s
# Time per event for each sequence: 42.1234s
# Threads for each sequence: 2
# Time per event for single thread for each sequence: 2 * 42.1234s = 84.2469s
# Which adds up to 84.2469s per event
# Single core events that fit in validation duration: 20160s / 84.2469s = 239
# Produced events limit in McM is 10000
# According to 1.0000 efficiency, validation should run 10000 / 1.0000 = 10000 events to reach the limit of 10000
# Take the minimum of 239 and 10000, but more than 0 -> 239
# It is estimated that this validation will produce: 239 * 1.0000 = 239 events
EVENTS=-1


# cmsDriver command
cmsDriver.py Configuration/GenProduction/python/HIG-Run3Summer22EEwmLHEGS-00126-fragment.py --filein file:HIG-Run3Summer22EEDRPremix-00097.root --python_filename HIG-Run3Summer22EEMiniAODv3-00102_1_cfg.py --eventcontent MINIAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier MINIAODSIM --fileout file:HIG-Run3Summer22EEMiniAODv3-00102.root --conditions 124X_mcRun3_2022_realistic_postEE_v1 --step PAT --geometry DB:Extended --era Run3 --no_exec --mc -n $EVENTS 

# Run the cmsRun
cmsRun HIG-Run3Summer22EEMiniAODv3-00102_1_cfg.py 


# End of HIG-Run3Summer22EEMiniAODv3-00102_test.sh file
