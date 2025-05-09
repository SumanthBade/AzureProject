param env string = 'dev'
param location string = 'eastus'
param vnetAddressPrefix string = '10.0.0.0/16'
param publicSubnetPrefix string = '10.0.0.0/28'
param privateSubnetPrefix string = '10.0.4.0/22'

var vnetName = 'AzureProject-VNet-${env}'
var publicNsgName = 'PublicSubnetNSG-${env}'
var privateNsgName = 'PrivateSubnetNSG-${env}'

resource privateNsg_resource 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: privateNsgName
  location: location
  tags: {
    environment: env
  }
  properties: {
    securityRules: []
  }
}

resource publicNsg_resource 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: publicNsgName
  location: location
  tags: {
    environment: env
  }
  properties: {
    securityRules: [
      {
        name: 'Allow-SSH-Inbound'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vnet_resource 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  tags: {
    environment: env
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    enableDdosProtection: false
    virtualNetworkPeerings: []
    subnets: [
      {
        name: 'PublicSubnet'
        properties: {
          addressPrefixes: [
            publicSubnetPrefix
          ]
          networkSecurityGroup: {
            id: publicNsg_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'PrivateSubnet'
        properties: {
          addressPrefixes: [
            privateSubnetPrefix
          ]
          networkSecurityGroup: {
            id: privateNsg_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}
