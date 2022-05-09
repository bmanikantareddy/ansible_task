#!/bin/bash
AVAIL_DOMAIN=$(jq .availabilityDomain /var/log/vminfo | head -1 | sed 's/"//g')
COMPARTMENT_ID=$(jq .compartmentId /var/log/vminfo | head -1 | sed 's/"//g')
VM_OCID=$(jq .id /var/log/vminfo | head -1 | sed 's/"//g')
VM_SHAPE=$(jq .shape /var/log/vminfo | head -1 | sed 's/"//g')
VM_IP=$(jq -r '.[0]|.privateIp' /var/log/vcninfo)
REGION=$(jq .canonicalRegionName /var/log/vminfo | head -1 | sed 's/"//g')
FAULTDOMAIN=$(jq .faultDomain /var/log/vminfo | head -1 | sed 's/"//g')
HOST_NAME=$(jq .hostname /var/log/vminfo | head -1 | sed 's/"//g')
VNET_ID=$(jq -r '.[0]|.vnicId' /var/log/vcninfo)
SUBNET_CIDR_BLOCK=$(jq -r '.[0]|.subnetCidrBlock' /var/log/vcninfo  | sed 's/"//g')

echo AVAIL_DOMAIN=${AVAIL_DOMAIN}
echo COMPARTMENT_ID=${COMPARTMENT_ID}
echo VM_OCID=${VM_OCID}
echo VM_SHAPE=${VM_SHAPE}
echo VM_IP=${VM_IP}
echo REGION=${REGION}
echo FAULTDOMAIN=${FAULTDOMAIN}
echo HOST_NAME=${HOST_NAME}
echo VNET_ID=${VNET_ID}
echo SUBNET_CIDR_BLOCK=${SUBNET_CIDR_BLOCK}

sed -i "s/\bavailabilityDomain\b/&\: \"$AVAIL_DOMAIN\"/" /etc/filebeat/filebeat.yml
sed -i "s/\bcompartmentId\b/&\: \"$COMPARTMENT_ID\"/" /etc/filebeat/filebeat.yml
sed -i "s/\binstanceId\b/&\: \"$VM_OCID\"/" /etc/filebeat/filebeat.yml
sed -i "s/\bvm_shape\b/&\: \"$VM_SHAPE\"/" /etc/filebeat/filebeat.yml
sed -i "s/\bhost_ip\b/&\: \"$VM_IP\"/" /etc/filebeat/filebeat.yml
sed -i "s/\boci_region\b/&\: \"$REGION\"/" /etc/filebeat/filebeat.yml
sed -i "s/\bfaultDomain\b/&\: \"$FAULTDOMAIN\"/" /etc/filebeat/filebeat.yml
sed -i "s/\bhostname\b/&\: \"$HOST_NAME\"/" /etc/filebeat/filebeat.yml
sed -i "s/\bvnic_id\b/&\: \"$VNET_ID\"/" /etc/filebeat/filebeat.yml
sed -i "s|\bsubnet_cidr\b|&\: \"$SUBNET_CIDR_BLOCK\"|" /etc/filebeat/filebeat.yml  

sed -i "s/logstashurl/${logstashurl}/" /etc/filebeat/filebeat.yml
# changes / tp | as cidr has forward slash and sed getting confused.