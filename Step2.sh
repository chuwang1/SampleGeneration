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
cp bbgg_fragment_FNAME.py Configuration/GenProduction/python/HIG-Run3Summer22EEDRPremix-00097-fragment_NODE.py
scram b
cd ../..

# Maximum validation duration: 28800s
# Margin for validation duration: 30%
# Validation duration with margin: 28800 * (1 - 0.30) = 20160s
# Time per event for each sequence: 42.1234s
# Threads for each sequence: 4, 4
# Time per event for single thread for each sequence: 4 * 42.1234s = 168.4937s
# Which adds up to 168.4937s per event
# Single core events that fit in validation duration: 20160s / 168.4937s = 119
# Produced events limit in McM is 10000
# According to 1.0000 efficiency, validation should run 10000 / 1.0000 = 10000 events to reach the limit of 10000
# Take the minimum of 119 and 10000, but more than 0 -> 119
# It is estimated that this validation will produce: 119 * 1.0000 = 119 events
EVENTS=-1


# cmsDriver command
cmsDriver.py Configuration/GenProduction/python/HIG-Run3Summer22EEDRPremix-00097-fragment_NODE.py --python_filename HIG-Run3Summer22EEDRPremix-00097_1_cfg.py --eventcontent PREMIXRAW --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM-RAW --fileout file:HIG-Run3Summer22EEDRPremix-00097_0.root --filein file:HIG-Run3Summer22EEwmLHEGS-00126.root --pileup_input "dbs:/Neutrino_E-10_gun/Run3Summer21PrePremix-Summer22_124X_mcRun3_2022_realistic_v11-v2/PREMIX" --conditions 124X_mcRun3_2022_realistic_postEE_v1 --step DIGI,DATAMIX,L1,DIGI2RAW,HLT:2022v14 --procModifiers premix_stage2,siPixelQualityRawToDigi --geometry DB:Extended --datamix PreMix --era Run3 --no_exec --mc -n $EVENTS
# cp WORKDIR/HIG-Run3Summer22EEDRPremix-00097_1_cfg.py  HIG-Run3Summer22EEDRPremix-00097_1_cfg_run.py 
# cmsRun  HIG-Run3Summer22EEDRPremix-00097_1_cfg.py 
cmsRun  HIG-Run3Summer22EEDRPremix-00097_1_cfg.py 

cmsDriver.py Configuration/GenProduction/python/HIG-Run3Summer22EEDRPremix-00097-fragment_NODE.py --python_filename HIG-Run3Summer22EEDRPremix-00097_2_cfg.py --eventcontent AODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier AODSIM --fileout file:HIG-Run3Summer22EEDRPremix-00097.root --conditions 124X_mcRun3_2022_realistic_postEE_v1 --step RAW2DIGI,L1Reco,RECO,RECOSIM --procModifiers siPixelQualityRawToDigi --geometry DB:Extended --filein file:HIG-Run3Summer22EEDRPremix-00097_0.root --era Run3 --no_exec --mc -n $EVENTS 

cmsRun  HIG-Run3Summer22EEDRPremix-00097_2_cfg.py 

