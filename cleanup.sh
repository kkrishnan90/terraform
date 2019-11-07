#! /bin/bash

echo "Emptying contents of hosts.yml in ansible..."
> ansible/hosts.yml
sleep 1
echo "Emptying contents of privateips generated templates..."
rm -rf privateips/*
sleep 1
reg='^[0-9]{8}$'
echo "How many(count) HAProxy do you want to provision ?"
read hap_count
while [[ ! $hap_count =~ $reg ]]
do
 echo 'Count is only numbers...'
done
echo "Checking app server count matches with HAProxy..."
app_count=$(wc -l ansible/app-servers.conf | awk '{print $1}')
sleep 1
if (($hap_count < $app_count))
then
  echo "Risk forseen !!!!! Your HAProxy counts are less than app server counts. Modify /terraform/ansible/app-servers.conf file (Add more app servers) !"
else
  echo "Let's check once again before we proceed..."
  if (($app_count % 2 == 0))
  then
    echo "Good to go ! Launch bash init.sh script to start provisioning infrastructure"
  else
    echo "Your app servers counts in odd number. Do you want to recheck ? If not, proceed launching bash init.sh script to provision infrastructure"
  fi
fi