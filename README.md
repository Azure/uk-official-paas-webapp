# Solution Overview
For more information about this solution, see [Azure Security and Compliance Blueprint - PaaS Web Application Hosting for UK OFFICIAL Workloads](https://aka.ms/ukofficial-paaswa).

For deployment this blueprint uses linked Azure Resource Manager templates. There are a series of individual templates for each component that can be used to deploy each component indivudually; each of these templates have their own series of paramters and defaults. In the root folder, azuredeploy.json exposes a subset of parameters which has been derived to enable a simple deployment.  More advanced configurations can be achived via customising the templates.

# Deploy the Solution

These templates will deploy a web application hosting architecture using Azure platform as a service components. Progress can be monitored from the Resource Group blade and Deployment output blade in the Azure Portal.

There are two methods that users may use to deploy this solution. The first method uses a Bash script, whereas the second method utilises Azure Portal to deploy the solution. These two methods are detailed in the sections below.

 As a pre-requisite to deployment, users should ensure that they have:

- An Azure Subscription
- Contributor or Owner rights to the Subscription

> If you would like to configure an Azure Active Directory Group as part of the scripted deployment you will need to have suitable permissions within your Azure Active Directory.

Other Azure architectural best practices and guidance can be found in [Azure Reference Architectures](https://docs.microsoft.com/azure/guidance/guidance-architecture). Supporting Microsoft Visio templates are available from the [Microsoft download center](http://download.microsoft.com/download/1/5/6/1569703C-0A82-4A9C-8334-F13D0DF2F472/RAs.vsdx) with the corresponding ARM templates found at [Azure Reference Architectures ARM Templates](https://github.com/mspnp/reference-architectures).

## Method 1: Azure CLI 2 (Express version)
To deploy this solution through the Azure CLI, you will need the latest version of the [Azure CLI 2](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) to use the BASH script that deploys the solution. Alternatively you can use the [Azure Cloud Shell](https://shell.azure.com/). To deploy the reference architecture, follow these steps:
1. If you have access to multiple subscriptions use the command ```az account set --subscription <the subscription id you wish to use>``` to ensure you are targetting the correct subscription
2. Download the BASH script pre_reqs.sh, for example with the command ```wget https://raw.githubusercontent.com/Azure/uk-official-three-tier-paas-webapp/master/scripts/pre_reqs.sh```
3. Execute the script by using the command ```bash pre_reqs.sh```
4. If you do not know the short name of the region you wish to deploy to enter ```Y``` else enter ```N```
5. Enter the short name of the region you wish to deploy to e.g. ```northeurope```

> Note: The parameter files include hard-coded passwords in various places. It is strongly recommended that you change these values.
> If the parameters files are not updated, the default values will be used which may not be compatible with your on-premises environment.

### Method 1a: Azure CLI 2 (Configuring the deployment via script arguments)
The ```pre_reqs.sh``` script supports a number of command line arguments that allow you to customise the deployment.  These are:

1. Region - should be a valid shortname for a region
2. Base Resource Name (used for uniqueness) - should be less than 15 chars and all lower case
3. Base Resource Group Name
4. SQL Admin configuration - valid options are ```Group```, ```User```, ```None```
5. Log Analytics SKU - valid options are ```Free``` or ```pergb2018```

>As the arguments are positional rather than named, you need to add them in the correct order.  If you specify arguments, you don't have to specify all of them. For example, you could provide just the first argument, or arguments 1,2 & 3. You cannot supply them out of order.

```bash pre_reqs.sh northeurope paasbp rg-ne-paas-blueprint```

## Method 2: Azure Portal Deployment Process

A deployment for this reference architecture is available on
[GitHub](https://aka.ms/ukofficial-paaswa-repo). The templates can be cloned or downloaded if customisation of parameters is requried.  To deploy the architecture, follow the steps below.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fuk-official-three-tier-paas-webapp%2Fmaster%2Fazuredeploy.json" target="_blank">
<img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/>
</a>

1. Click on the **Deploy to Azure** button to begin the first stage of the deployment. The link takes you to the Azure Portal.
2. Select **Create New** and enter a value such as `rg-uks-paas-blueprint` in the **Resource group** textbox.
3. Select a region such as `UKSouth` or `UKWest`, from the **Location** drop down box. **All Resource Groups required for this architecture should be in the same Azure region (e.g., `UKSouth` or `UKWest`).**
4. Review the available parameters and enter the appropriate values for your deployment - note that you will need to replace the function based defaults such as ```[uniqueString(resourceGroup().id)]```
5. Unlike the bash script in Method 1 the portal method will not create the additional resource groups, you can enter the resource group name from step 2 in **App Service Resource Group**, **Key Vault Resource Group**, **Storage Resource Group** and **Azure SQL Resource Group** - if you would like to deploy these resources to different resource groups you must create them seperately first.
6. Review the terms and conditions, then click the **I agree to the terms and conditions stated above** checkbox.
7. Click on the **Purchase** button.
8. Check the Azure Portal notifications for a message stating that this stage of deployment is complete, and proceed to the next deployment stage if completed.
9. If for some reason your deployment fails, it is advisable to delete the resource group in its entirety to avoid incurring cost and orphan resources, fix the issue, and redeploy the resource groups and template.

## Deployment parameters
The table below provides additional information about deployment parameters.

  Parameter|Default|Comment|
  ---|---|---
  baseResourceName|uniqueString(resourceGroup().id)|Base resource name to use for the deployed resources.  For example a value of "bpdemo" would provide a keyvault name kvbpdemo
  appServiceResourceGroup|Deployment Resource Group|Name of the Resource Group to deploy the App Service Plan to
  keyVaultResourceGroup|Deployment Resource Group|Name of the Resource Group to deploy the Key Vaults to
  storageResourceGroup|Deployment Resource Group|Name of the Resource Group to deploy the storage and log analytics workspace to
  azureSQLResourceGroup|Deployment Resource Group|Name of the Resource Group to deploy the Azure SQL instance to
  LogsWorkspaceLocation|westeurope|Which Azure Region to deploy the Log Analytics workspace to
  LogAnalyticsSKU|N/A|The SKU for provisioning the Log Analytics solution.  Note if your subscription has been moved to the "new" pricing only "pergb2018" will work, if not it is "Free"
  databaseServerName|concat('svr-', uniqueString(resourceGroup().id))|Name of the database server to deploy
  sqlServerAdminPassword|concat('L1',uniqueString(subscription().id),'#')|The default password for the SQL Admin user
  useAADForSQLAdmin|No|Allowed Values "Yes", "No".  Sets whether Azure Active Directory will be used for SQL Server Administration
  AADAdminLogin|ignore|The Login ID for the Azure Active Directory user or group to be Server Admin, e.g., sg_azure_sql_dbo@contoso.com
  AADAdminObjectID|ignore|The underlying ObjectID (in the form of a GUID) representing the assigned Azure Active Directory user / group
  AlertSendToEmailAddress|N/A|The email address to send alerts to

# UK Government Private Network Connectivity

Microsoft's customers are able to use [private connections](https://news.microsoft.com/2016/12/14/microsoft-now-offers-private-internet-connections-to-its-uk-data-centres/#sm.0001dca7sq10r1couwf4vvy9a85zx)
to the Microsoft UK datacentres (UK West and UK South). Microsoft's partners a providing a gateway from PSN/N3 to [ExpressRoute](https://azure.microsoft.com/services/expressroute/) and into Azure, and this is just one of the new services the group has unveiled since Microsoft launched its [**Azure**](https://azure.microsoft.com/blog/) and Office 365 cloud offering in the UK. (https://news.microsoft.com/2016/09/07/not-publish-microsoft-becomes-first-company-open-data-centres-uk/). Since then, [**thousands of customers**](https://enterprise.microsoft.com/industries/public-sector/microsoft-uk-data-centres-continue-to-build-momentum/?wt.mc_id=AID563187_QSG_1236), including the Ministry of Defence, the Met Police, and parts of the NHS, have signed up to take advantage of the sites. These UK datacentres offer UK data residency, security and reliability.

# Cost

Deploying this template will create one or more Azure resources. You will be responsible for the costs generated by these resources, so it is important that you review the applicable pricing and legal terms associated with all resources and offerings deployed as part of this template. For cost estimates, you can use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator).

The **indicative cost** based on the services defined in the Blueprint are below. These are based on Standard pricing tiers for App Services and Database and free tiers for Log Analytics, Security Centre and Active Directory. As your solution expands to meet demand you may need to use different pricing tier and further cost could be incurred.

- App Service - UK West - Standard Tier; 1 S1 (1 Core(s), 1.75 GB RAM, 50 GB Storage) x 730 Hours; Windows OS £68.01
- Key Vault UK West 100000 operations/mo, 0 advanced operations/mo, 0 renewals/mo, 0 protected keys/mo 0 advanced protected keys/mo £0.22
- Azure SQL Database UK West Single Database, DTU Purchase Model, Standard Tier, S1: 20 DTUs, 250 GB included storage per DB, 1 Database(s) x 730 Hours, 5 GB Retention £27.43
- Azure Advanced Threat detection for SQL Server charged at $15 per server per month (free for first 60 days)
- Storage UK West Block Blob Storage, General Purpose V2, LRS Redundancy, Hot Access Tier, 1000 GB Capacity, 100,000 Write operations, 100,000 List and Create Container Operations, 100,000 Read operations, 1 Other operations. 1,000 GB Data Retrieval, 1,000 GB Data Write £15.22
- Azure Active Directory West Europe Free tier, per-user MFA billing model, 10 MFA user(s), 25001-100000 directory objects, 0 Hours £10.43
-Log Analytics West Europe 0 VMs monitored, 0 GB average log size, 0 additional days of data retention £0.00
- Application Insights West Europe 1 GB Logs collected, 0 Multi-step Web Tests £0.00
- Azure Monitor West Europe 1,000,000 Standard API calls, 1 VM(s) monitored and 1 metric(s) monitored per VM, 1 Log Alert(s) at 5 Minutes Frequency, 1,000 emails, 1,000 push notifications, 100,000 web hooks, 100 SMS in United States (+1) £1.19
- Security Center Free tier £0.00
- Azure DNS West Europe 1 hosted DNS zones, 5 DNS queries £1.86

Monthly Total £139.38 Annual Total £1,672.56


# Further Reading

Information on linked templates as used within this blueprint can be found in [Using linked and nested templates when deploying Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-linked-templates)

Details on security best practices can be found in [Azure security best practices and patterns](https://docs.microsoft.com/en-us/azure/security/security-best-practices-and-patterns)

App Service best practices can be found in [Best Practices for Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/app-service-best-practices)

Azure SQL Database best practices are available in the docs page [Azure database security best practices](https://docs.microsoft.com/en-us/azure/security/azure-database-security-best-practices)

Further information for key vault can be found in [Azure Key Vault Developer's Guide](https://docs.microsoft.com/en-us/azure/key-vault/key-vault-developers-guide)

Guidance on Azure storage can be found in [Azure Storage security guide](https://docs.microsoft.com/en-us/azure/storage/common/storage-security-guide) and [Azure Storage security overview](https://docs.microsoft.com/en-us/azure/security/security-storage-overview)

# Disclaimer

- This document is for informational purposes only. MICROSOFT MAKES NO WARRANTIES, EXPRESS, IMPLIED, OR STATUTORY, AS TO THE INFORMATION IN THIS DOCUMENT. This document is provided "as-is." Information and views expressed in this document, including URL and other Internet website references, may change without notice. Customers reading this document bear the risk of using it.  
- This document does not provide customers with any legal rights to any intellectual property in any Microsoft product or solutions.  
- Customers may copy and use this document for internal reference purposes.  
- Certain recommendations in this document may result in increased data, network, or compute resource usage in Azure, and may increase a customer's Azure license or subscription costs.  
- This architecture is intended to serve as a foundation for customers to adjust to their specific requirements and should not be used as-is in a production environment.
- This document is developed as a reference and should not be used to define all means by which a customer can meet specific compliance requirements and regulations. Customers should seek legal support from their organization on approved customer implementations.

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
