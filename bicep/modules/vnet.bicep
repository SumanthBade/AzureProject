param virtualNetworks_AzureProject_VNet_name string
param networkSecurityGroups_PublicSubnetNSG_externalid string
param networkSecurityGroups_PrivateSubnetNSG_externalid string

resource virtualNetworks_AzureProject_VNet_name_resource 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: virtualNetworks_AzureProject_VNet_name
  location: 'eastus'
  tags: {
    environment: 'dev'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'PublicSubnet'
        id: virtualNetworks_AzureProject_VNet_name_PublicSubnet.id
        properties: {
          addressPrefixes: [
            '10.0.0.0/28'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_PublicSubnetNSG_externalid
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'PrivateSubnet'
        id: virtualNetworks_AzureProject_VNet_name_PrivateSubnet.id
        properties: {
          addressPrefixes: [
            '10.0.4.0/22'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_PrivateSubnetNSG_externalid
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_AzureProject_VNet_name_PrivateSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  name: '${virtualNetworks_AzureProject_VNet_name}/PrivateSubnet'
  properties: {
    addressPrefixes: [
      '10.0.4.0/22'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_PrivateSubnetNSG_externalid
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_AzureProject_VNet_name_resource
  ]
}

resource virtualNetworks_AzureProject_VNet_name_PublicSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  name: '${virtualNetworks_AzureProject_VNet_name}/PublicSubnet'
  properties: {
    addressPrefixes: [
      '10.0.0.0/28'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_PublicSubnetNSG_externalid
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_AzureProject_VNet_name_resource
  ]
}

