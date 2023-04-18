filenametime=$(date +"%m%d%Y%H%M%S")

#Set variables. Directories have already been made
export BASE='/home/umerghani/WCD/Lab1'
export SCRIPT=${BASE}'/scripts'
export INPUT=${BASE}'/input'
export OUTPUT=${BASE}'/output'
export LOGDIR=${BASE}'/logs'
export SHELL_SCRIPT='shell_script'
export LOG_FILE=${LOGDIR}/${SHELL_SCRIPT}_${filenametime}.log

cd ${SCRIPT}

#Set log rules
exec > >(tee ${LOG_FILE}) 2>&1

#Pull data using canada.gov API
for year in {2020..2022}; # or use (seq 2019 2022)
do wget -N --content-disposition "https://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=48549&Year=${year}&Month=2&Day=14&timeframe=1&submit= Download+Data" -O ${INPUT}/${year}.csv;
done;

#Setting up error commands

RC1=$?
if [ ${RC1} != 0 ]; then
        echo "Unable to download data"
        echo "Error Code {$RC1}"
        echo "Refer to logs for reason of failure"
        exit 1
fi

#Run python script
echo "run python script"
python3 ${SCRIPT}/.python_file.py

RC1=$?
if [ ${RC1} !=0 ]; then
        echo "python script failed"
        echo "Error Code {$RC1}"
        echo "Refer to logs for reason of failure"
        exit 1
fi

echo "Program Succeeded"

exit 0


