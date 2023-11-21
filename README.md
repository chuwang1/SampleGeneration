Sample Genaration
====
The full-generation procedure
---
For Run3 samples, there are 4 steps from gridpack to NANOAOD:
- Step1:LHE-GEN-SIM
	 we need to start from gridpack and fragment, which could be found in mcm website. Once we have the fragment, we can also copy the test command from official production site.  Eg:[mcm](https://cms-pdmv-prod.web.cern.ch/mcm/public/restapi/requests/get_test/HIG-Run3Summer22EEwmLHEGS-00208)

	Note:
	- Replace the fragment to your actual fragment
	- These settings might change for different campaign.

- Step2: DIGI-RECO
  Once the gen-sim was done, we can do the diginization and reconstruction in step2. The settings could also been downloaded from the offical website. Eg:[mcm](https://cms-pdmv-prod.web.cern.ch/mcm/public/restapi/requests/get_test/HIG-Run3Summer22EEDRPremix-00189)
  
	Note: Change the input and output names

- Step3: MINIAOD:
	In this step, we can generate MINIAOD samples.
	Also download the settings from offical web: [mcm](https://cms-pdmv-prod.web.cern.ch/mcm/public/restapi/requests/get_test/HIG-Run3Summer22EEMiniAODv4-00158)
- Step4: NANOAOD
	After the MINIAOD generation, we can generate NANOAOD, as the same as the previous steps. We can also download the settings from offical web: [mcm](https://cms-pdmv-prod.web.cern.ch/mcm/public/restapi/requests/get_test/HIG-Run3Summer22EENanoAODv12-00158)

Notes:
--- 
- For different campaign, the settings are different. Previous examples only works for `Run3Summer22EE` campaign. And there might be different setting versions. So you should choose suitable campaign and version for your own production. In this repo, I copied the Run3Summer22EE settings to Step*.sh. It's only suite with Run3Summer22EE HHto2B2G producation.

Usage of the code
----
```
sh sub.sh <Absolute path of Gridpack> <OutputDirectoryName>
```
It will submit 50 jobs, each job have 200 events.

	Note: you should change the path of the output, which was defined in RunAllSteps.sh



