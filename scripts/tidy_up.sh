#!/bin/bash
echo "**** WARNING THIS WILL DELETE THE RESOURCE GROUPS CREATED FOR THE Azure PaaS Blueprint, ALL Resources will be lost...  ****"
echo "**** You should manually grant yourself purge permissions and delete / purge the keyvaults as they have soft delete on... *****"
echo -n "Please enter the base resource group name:"
read baseResourceGroupName

az group delete --name $baseResourceGroupName --yes --no-wait
az group delete --name $baseResourceGroupName-AppService --yes --no-wait
az group delete --name $baseResourceGroupName-AzureSQL --yes --no-wait
az group delete --name $baseResourceGroupName-Storage --yes --no-wait
az group delete --name $baseResourceGroupName-KeyVault --yes --no-wait

echo "Script complete, please note it may take time for the resource groups to be fully deleted."
