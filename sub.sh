cp bbgg_fragment.py bbgg_fragment_$2.py
sed -i "s#FRAGMENT#$1#g" bbgg_fragment_$2.py
cp RunAllSteps.sh RunAllSteps_$2.sh
sed -i "s#NODE#$2#g" RunAllSteps_$2.sh
cp submit.sub   submit_$2.sub
sed -i "s#NODE#$2#g" submit_$2.sub
sed -i "s#WORKDIR#${PWD}#g" submit_$2.sub
# condor_submit submit_$2.sub
 
