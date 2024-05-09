//=============================================================================
// Naming Conventions for Azure Resources
//=============================================================================

// Get resource name based on the naming convention taken from the Cloud Adoptation Framework.
// Convention: <resourceType>-<workload>-<environment>-<region>-<instance>
// Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
@export()
func getResourceName(resourceType string, workload string, environment string, region string, instance string) string => 
  shouldBeNormalized(resourceType) 
    ? normalizeResourceName(resourceType, workload, environment, region, instance)
    : getResourceNameByConvention(resourceType, workload, environment, region, instance)

func getResourceNameByConvention(resourceType string, workload string, environment string, region string, instance string) string => 
  sanitizeResourceName('${getPrefix(resourceType)}-${workload}-${abbreviateEnvironment(environment)}-${abbreviateRegion(region)}-${instance}')


//=============================================================================
// Sanitize
//=============================================================================

// Sanitize the resource name by removing illegal characters and converting it to lower case.
func sanitizeResourceName(value string) string => toLower(removeWhiteSpaces(removeUnderScores(removeDots(removeCommas(removeColons(removeSemiColons(value)))))))
func removeWhiteSpaces(value string) string => replace(value, ' ', '')
func removeUnderScores(value string) string => replace(value, '_', '')
func removeDots(value string) string => replace(value, '.', '')
func removeCommas(value string) string => replace(value, ',', '')
func removeColons(value string) string => replace(value, ':', '')
func removeSemiColons(value string) string => replace(value, ';', '')


//=============================================================================
// Normalize / Shorten
//=============================================================================

// Check if the resource name should be normalized.
func shouldBeNormalized(resourceType string) bool => contains(getResourcesTypesToNormalize(), resourceType)

// We'll remove hyphens because it's an illegal character or to shorten the name, preventing errors when deploying.
func normalizeResourceName(resourceType string, workload string, environment string, region string, instance string) string =>
  removeHyphens(getResourceNameByConvention(resourceType, workload, environment, region, instance))

func removeHyphens(value string) string => replace(value, '-', '')

// This is a list of resources that should be 'normalized'.
func getResourcesTypesToNormalize() array => [
  'keyVault'        // Has max length of 24
  'storageAccount'  // Has max length of 24 and only allows letters and numbers
  'virtualMachine'  // Has max length of 15 for Windows
]


//=============================================================================
// Prefixes
//=============================================================================

func getPrefix(resourceType string) string => getPrefixMap()[resourceType]

// Prefixes for commonly used resources.
// Source for abbreviations: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
func getPrefixMap() object => {
  actionGroup: 'ag'
  alert: 'al'
  apiManagement: 'apim'
  applicationGateway: 'agw'
  applicationInsights: 'appi'
  appServiceEnvironment: 'ase'
  appServicePlan: 'asp'
  containerInstance: 'ci'
  functionApp: 'func'
  integrationAccount: 'ia'
  keyVault: 'kv'
  loadBalancerInternal: 'lbi'
  loadBalancerExternal: 'lbe'
  loadBalancerRule: 'rule'
  logAnalyticsWorkspace: 'log'
  logAnalyticsQueryPack: 'pack'
  logicApp: 'logic'
  managedIdentity: 'id'
  networkInterface: 'nic'
  networkSecurityGroup: 'nsg'
  publicIpAddress: 'pip'
  resourceGroup: 'rg'
  serviceBusNamespace: 'sbns'
  serviceBusQueue: 'sbq'
  serviceBusTopic: 'sbt'
  serviceBusTopicSubscription: 'sbts'
  sqlDatabaseServer: 'sql'
  staticWebapp: 'stapp'
  storageAccount: 'st'
  subnet: 'snet'
  synapseWorkspace: 'syn'
  virtualMachine: 'vm'
  virtualNetwork: 'vnet'
  webApp: 'app' 
  
  // Custom prefixes not specified on the Microsoft site
  webtest: 'webtest'
}


//=============================================================================
// Environments
//=============================================================================

func abbreviateEnvironment(environment string) string => getEnvironments()[toLower(environment)]

// By using a map for the environments, we can keep the names short but also only allow a specific set of values.
func getEnvironments() object => {
  dev: 'dev'
  development: 'dev'
  tst: 'tst'
  test: 'tst'
  acc: 'acc'
  acceptance: 'acc'
  prd: 'prd'
  prod: 'prd'
  production: 'prd'
}

//=============================================================================
// Regions
//=============================================================================

func abbreviateRegion(region string) string => getRegionMap()[region]

// Map Azure region name to Short Name (CAF) abbrevation taken from: https://www.jlaundry.nz/2022/azure_region_abbreviations/
func getRegionMap() object => {
  australiacentral: 'acl'
  australiacentral2: 'acl2'
  australiaeast: 'ae'
  australiasoutheast: 'ase'
  brazilsouth: 'brs'
  brazilsoutheast: 'bse'
  canadacentral: 'cnc'
  canadaeast: 'cne'
  centralindia: 'inc'
  centralus: 'cus'
  centraluseuap: 'ccy'
  eastasia: 'ea'
  eastus: 'eus'
  eastus2: 'eus2'
  eastus2euap: 'ecy'
  francecentral: 'frc'
  francesouth: 'frs'
  germanynorth: 'gn'
  germanywestcentral: 'gwc'
  italynorth: 'itn'
  japaneast: 'jpe'
  japanwest: 'jpw'
  jioindiacentral: 'jic'
  jioindiawest: 'jiw'
  koreacentral: 'krc'
  koreasouth: 'krs'
  northcentralus: 'ncus'
  northeurope: 'ne'
  norwayeast: 'nwe'
  norwaywest: 'nww'
  qatarcentral: 'qac'
  southafricanorth: 'san'
  southafricawest: 'saw'
  southcentralus: 'scus'
  southindia: 'ins'
  southeastasia: 'sea'
  swedencentral: 'sdc'
  swedensouth: 'sds'
  switzerlandnorth: 'szn'
  switzerlandwest: 'szw'
  uaecentral: 'uac'
  uaenorth: 'uan'
  uksouth: 'uks'
  ukwest: 'ukw'
  westcentralus: 'wcus'
  westeurope: 'we'
  westindia: 'inw'
  westus: 'wus'
  westus2: 'wus2'
  westus3: 'wus3'
  chinaeast: 'sha'
  chinaeast2: 'sha2'
  chinanorth: 'bjb'
  chinanorth2: 'bjb2'
  chinanorth3: 'bjb3'
  germanycentral: 'gec'
  germanynortheast: 'gne'
  usdodcentral: 'udc'
  usdodeast: 'ude'
  usgovarizona: 'uga'
  usgoviowa: 'ugi'
  usgovtexas: 'ugt'
  usgovvirginia: 'ugv'
  usnateast: 'exe'
  usnatwest: 'exw'
  usseceast: 'rxe'
  ussecwest: 'rxw'
}
