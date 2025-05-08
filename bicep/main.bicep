@description('Name of the virtual network')
param virtualNetworks_AzureProject_VNet_name string = 'AzureProject-VNet'

@description('Resource ID of the NSG to associate with the Public Subnet')
param networkSecurityGroups_PublicSubnetNSG_externalid string = '/subscriptions/db75716a-bc0d-4d76-872c-0c6179241fc3/resourceGroups/RG-AzureProject/providers/Microsoft.Network/networkSecurityGroups/PublicSubnetNSG'

@description('Resource ID of the NSG to associate with the Private Subnet')
param networkSecurityGroups_PrivateSubnetNSG_externalid string = '/subscriptions/db75716a-bc0d-4d76-872c-0c6179241fc3/resourceGroups/RG-AzureProject/providers/Microsoft.Network/networkSecurityGroups/PrivateSubnetNSG'

module vnetModule 'modules/vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    virtualNetworks_AzureProject_VNet_name: virtualNetworks_AzureProject_VNet_name
    networkSecurityGroups_PublicSubnetNSG_externalid: networkSecurityGroups_PublicSubnetNSG_externalid
    networkSecurityGroups_PrivateSubnetNSG_externalid: networkSecurityGroups_PrivateSubnetNSG_externalid
  }
}
