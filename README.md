# Terraform Cloud/Enterprise Import Guide using import.tf and backend.tf

This guide explains how to import existing Azure resources into Terraform Cloud/Enterprise using dedicated `import.tf` and `backend.tf` files.

## Prerequisites

- Terraform CLI installed (version 1.9.0 or later)
- Azure CLI installed and authenticated
- Access to Terraform Cloud/Enterprise

## Step 1: Login to Terraform Cloud

### 1.1 Get API Token from Terraform Cloud
1. Go to https://app.terraform.io/app/settings/tokens
2. Click "Create an API token"
3. Give it a description (e.g., "CLI Access")
4. Copy the generated token (you won't see it again)

### 1.2 Login using Terraform CLI
```powershell
# Login to Terraform Cloud
terraform login

# Enter your API token when prompted
# The token will be stored securely for future use
```

**Alternative: Set Environment Variable**
```powershell
# Set environment variable for Terraform Cloud
$env:TF_TOKEN_app_terraform_io = "your-api-token-here"
```

## Step 2: Create backend.tf File

Create a `backend.tf` file in your Terraform directory:

```hcl
# backend.tf
terraform {
  cloud {
    organization = "your-organization-name"
    workspaces {
      name = "your-workspace-name"
    }
    # For Terraform Enterprise, uncomment and modify:
    # hostname = "your-tfe-instance.com"
  }
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

**Important Notes:**
- Replace `your-organization-name` with your actual Terraform Cloud organization
- Replace `your-workspace-name` with your target workspace
- For Terraform Enterprise, uncomment the `hostname` line and set your TFE instance URL

## Step 3: Initialize Terraform

```powershell
# Navigate to your Terraform directory
cd tfe-webapp-network-dev

# Initialize Terraform with the backend configuration
terraform init
```

This will:
- Connect to Terraform Cloud/Enterprise
- Download required providers
- Set up the remote backend

## Step 4: Check Current State

```powershell
# List all resources currently in state
terraform state list

# This will show empty if no resources are imported yet
```

## Step 5: Create import.tf File

Create an `import.tf` file to define the resources you want to import:

```hcl
# import.tf

# Example: Import an existing Resource Group
resource "azurerm_resource_group" "example_rg" {
  name     = "existing-resource-group-name"
  location = "East US"
}

# Example: Import an existing Virtual Network
resource "azurerm_virtual_network" "example_vnet" {
  name                = "existing-vnet-name"
  resource_group_name = azurerm_resource_group.example_rg.name
  location            = azurerm_resource_group.example_rg.location
  address_space       = ["10.0.0.0/16"]
}

# Example: Import an existing Subnet
resource "azurerm_subnet" "example_subnet" {
  name                 = "existing-subnet-name"
  resource_group_name  = azurerm_resource_group.example_rg.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Example: Import an existing Storage Account
resource "azurerm_storage_account" "example_storage" {
  name                     = "existingstorageaccount"
  resource_group_name      = azurerm_resource_group.example_rg.name
  location                 = azurerm_resource_group.example_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

**Important:**
- Use the exact resource names that exist in Azure
- Match the configuration as closely as possible to the existing resources
- You can get resource details using Azure CLI commands

## Step 6: Get Resource Information from Azure

Before importing, get the exact resource details:

```powershell
# List all resources in a resource group
az resource list --resource-group "your-resource-group-name" --output table

# Get specific resource details
az resource show --name "resource-name" --resource-group "rg-name" --resource-type "Microsoft.Storage/storageAccounts"

# Get subscription ID
az account show --query id --output tsv
```

## Step 7: Using Import Blocks (Modern Approach)

Terraform 1.5+ supports **import blocks** which allow you to declare imports directly in your Terraform configuration files. This is more declarative and easier to manage than CLI import commands.

### Import Block Syntax

```hcl
import {
  to = resource_type.resource_name
  id = "azure_resource_id"
}
```

### Example: Import Individual Resources

```hcl
# import.tf

# Resource definitions
resource "azurerm_resource_group" "example_rg" {
  name     = "existing-resource-group-name"
  location = "East US"
}

resource "azurerm_storage_account" "example_storage" {
  name                     = "existingstorageaccount"
  resource_group_name      = azurerm_resource_group.example_rg.name
  location                 = azurerm_resource_group.example_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Import blocks
import {
  to = azurerm_resource_group.example_rg
  id = "/subscriptions/58d48d30-bf14-416f-92ed-254430cc6772/resourceGroups/existing-resource-group-name"
}

import {
  to = azurerm_storage_account.example_storage
  id = "/subscriptions/58d48d30-bf14-416f-92ed-254430cc6772/resourceGroups/existing-resource-group-name/providers/Microsoft.Storage/storageAccounts/existingstorageaccount"
}
```

### Example: Import Module Resources

```hcl
# import.tf

# Module definition
module "resource-group" {
  source = "./modules/resource-group"
  
  resource_group_name = "we-idev-azrg-abcd-testing-rg"
  location           = "East US"
  
  tags = {
    Environment = "Testing"
    Project     = "ABCD"
  }
}

# Import block for module resource
import {
  to = module.resource-group.azurerm_resource_group.rg["testing"]
  id = "/subscriptions/58d48d30-bf14-416f-92ed-254430cc6772/resourceGroups/we-idev-azrg-abcd-testing-rg"
}
```

### Example: Import Multiple Module Resources

```hcl
# import.tf

module "network" {
  source = "./modules/network"
  
  vnet_name                    = "existing-vnet-name"
  subnet_name                  = "existing-subnet-name"
  resource_group_name          = "existing-resource-group-name"
  location                     = "East US"
  address_space                = ["10.0.0.0/16"]
  subnet_address_prefixes      = ["10.0.1.0/24"]
}

# Import blocks for multiple module resources
import {
  to = module.network.azurerm_virtual_network.vnet
  id = "/subscriptions/58d48d30-bf14-416f-92ed-254430cc6772/resourceGroups/existing-resource-group-name/providers/Microsoft.Network/virtualNetworks/existing-vnet-name"
}

import {
  to = module.network.azurerm_subnet.subnet
  id = "/subscriptions/58d48d30-bf14-416f-92ed-254430cc6772/resourceGroups/existing-resource-group-name/providers/Microsoft.Network/virtualNetworks/existing-vnet-name/subnets/existing-subnet-name"
}
```

### Using Import Blocks with Terraform Cloud/Enterprise

```powershell
# Commit and push your import.tf file with import blocks
git add import.tf
git commit -m "Add import blocks for resource import"
git push origin main

# Terraform Cloud/Enterprise will automatically trigger a plan
# Review the plan in the UI and apply if correct
```

### Benefits of Import Blocks

1. **Declarative**: Imports are declared in code, not executed via CLI
2. **Version Control**: Import operations are tracked in your Terraform files
3. **Repeatable**: Can be run multiple times safely
4. **Reviewable**: Import operations appear in plan output for review
5. **Batch Operations**: Can import multiple resources in one plan/apply cycle
6. **Git Integration**: Works seamlessly with Terraform Cloud/Enterprise Git workflows

### Import Block Syntax for Different Scenarios

#### Individual Resources
```hcl
import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}"
}

import {
  to = azurerm_storage_account.storage
  id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Storage/storageAccounts/{storage-account-name}"
}
```

#### Module Resources
```hcl
import {
  to = module.resource_group.azurerm_resource_group.rg
  id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}"
}

import {
  to = module.network.azurerm_virtual_network.vnet
  id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Network/virtualNetworks/{vnet-name}"
}
```

#### Resources with Count or For Each
```hcl
# For count-based resources
import {
  to = azurerm_storage_account.storage[0]
  id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Storage/storageAccounts/{storage-account-name}"
}

# For for_each resources
import {
  to = azurerm_storage_account.storage["key1"]
  id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Storage/storageAccounts/{storage-account-name}"
}
```

### Important Notes for Import Blocks

1. **Terraform Version**: Requires Terraform 1.5 or later
2. **Resource Definition**: The resource must be defined before the import block
3. **Resource ID**: Must be the exact Azure resource ID
4. **Git Workflow**: Import blocks are executed during Terraform Cloud/Enterprise plan operations
5. **State Management**: Imports are applied to the current workspace state

### Workflow with Import Blocks and Terraform Cloud/Enterprise

1. **Define Resources**: Add resource definitions to your Terraform files
2. **Add Import Blocks**: Declare imports using import blocks
3. **Commit and Push**: Push changes to your Git repository
4. **Review Plan**: Review the plan in Terraform Cloud/Enterprise UI
5. **Apply**: Apply the changes through the UI
6. **Remove Import Blocks**: After successful import, remove the import blocks and push again

### Example: Complete Workflow

```hcl
# Step 1: Define resources
resource "azurerm_resource_group" "example_rg" {
  name     = "existing-resource-group-name"
  location = "East US"
}

# Step 2: Add import block
import {
  to = azurerm_resource_group.example_rg
  id = "/subscriptions/58d48d30-bf14-416f-92ed-254430cc6772/resourceGroups/existing-resource-group-name"
}
```

```powershell
# Step 3: Commit and push
git add import.tf
git commit -m "Add import block for resource group"
git push origin main

# Step 4: Review and apply in Terraform Cloud/Enterprise UI
# - Go to your workspace
# - Review the triggered plan
# - Apply if correct

# Step 5: Remove import blocks after successful import
# - Edit the file to remove import blocks
# - Commit and push again
git add import.tf
git commit -m "Remove import blocks after successful import"
git push origin main
```

### Troubleshooting Import Blocks

#### Common Issues:
1. **Resource not found**: Ensure the Azure resource ID is correct
2. **Resource already imported**: Import blocks will fail if resource is already in state
3. **Version compatibility**: Ensure Terraform version supports import blocks
4. **State conflicts**: Resolve any state conflicts before using import blocks
5. **Git integration**: Ensure workspace is connected to version control

#### Verification:
```powershell
# Check if resources are imported (via Terraform Cloud/Enterprise UI)
# - Go to "States" tab in your workspace
# - View current state and imported resources
# - Check "Runs" tab for plan/apply history
```

## Step 8: Verify Imports

After the import is complete, verify in Terraform Cloud/Enterprise UI:

1. **Check State:**
   - Go to your workspace in Terraform Cloud/Enterprise UI
   - Navigate to "States" tab
   - Verify that imported resources appear in the state

2. **Review Runs:**
   - Go to "Runs" tab
   - Check the latest run for successful import operations
   - Review logs for any warnings or errors

3. **Run Plan:**
   - Go to "Actions" → "Start new plan"
   - Select "Plan only"
   - Verify that the plan shows no changes (indicating successful import)

## Step 9: Remove Import Blocks

After successful import, clean up your configuration:

```powershell
# Remove import blocks from import.tf
# Edit the file to remove all import blocks

# Commit and push the cleaned configuration
git add import.tf
git commit -m "Remove import blocks after successful import"
git push origin main
```

## Step 10: Removing Resources from State

Sometimes you need to remove resources from Terraform state without destroying the actual Azure resources. This is useful when you want to stop managing a resource with Terraform or when reorganizing your Terraform configuration.

### 10.1 List Current Resources

First, check what resources are currently in your state:

```powershell
# List all resources in state
terraform state list
```

Example output:
```
module.resource-group.azurerm_resource_group.rg["testing"]
module.network.azurerm_virtual_network.vnet
azurerm_storage_account.example
```

### 10.2 Remove Individual Resources

#### Simple Resource Removal
For basic resources without complex addressing:

```powershell
# Remove a simple resource
terraform state rm azurerm_storage_account.example

# Remove with version ignore flag (useful for version mismatches)
terraform state rm -ignore-remote-version azurerm_storage_account.example
```

#### Complex Resource Addresses (Modules with for_each)

For resources with complex addresses like modules with `for_each` keys, you have several options:

**Option 1: Use Command Prompt (Recommended)**
```cmd
# Open Command Prompt and navigate to your directory
cd E:\devops\git-azure\tfe-webapp-network-dev

# Remove the specific resource instance
terraform state rm -ignore-remote-version module.resource-group.azurerm_resource_group.rg["testing"]
```

**Option 2: PowerShell with Proper Escaping**
```powershell
# Method A: Single quotes with escaped inner quotes
terraform state rm -ignore-remote-version 'module.resource-group.azurerm_resource_group.rg[\"testing\"]'    (working)

# Method B: Double quotes with backtick escaping
terraform state rm -ignore-remote-version "module.resource-group.azurerm_resource_group.rg[\`"testing\`"]"

# Method C: Use call operator
& terraform state rm -ignore-remote-version 'module.resource-group.azurerm_resource_group.rg["testing"]'
```

**Option 3: Simplified Address (When Applicable)**
```powershell
# Remove entire module resource (all instances)
terraform state rm -ignore-remote-version module.resource-group.azurerm_resource_group.rg
```

### 10.3 Understanding the -ignore-remote-version Flag

The `-ignore-remote-version` flag is useful when:
- Your local Terraform version doesn't match workspace constraints
- You want to bypass version compatibility checks
- You're working with Terraform Cloud/Enterprise and have version mismatches

```powershell
# Example with version mismatch warning
terraform state rm -ignore-remote-version module.resource-group.azurerm_resource_group.rg["testing"]
```

### 10.4 Common Resource Address Patterns

#### Module Resources
```powershell
# Module with simple name
terraform state rm -ignore-remote-version module.network.azurerm_virtual_network.vnet

# Module with for_each key
terraform state rm -ignore-remote-version 'module.storage.azurerm_storage_account.account["prod"]'

# Module with count index
terraform state rm -ignore-remote-version module.vm.azurerm_virtual_machine.vm[0]
```

#### Resources with Count or For_Each
```powershell
# Count-based resources
terraform state rm -ignore-remote-version azurerm_virtual_machine.vm[0]
terraform state rm -ignore-remote-version azurerm_virtual_machine.vm[1]

# For_each resources
terraform state rm -ignore-remote-version 'azurerm_resource_group.rg["dev"]'
terraform state rm -ignore-remote-version 'azurerm_resource_group.rg["prod"]'
```

### 10.5 Troubleshooting Resource Removal

#### Common Errors and Solutions

**Error: Index value required**
```
Error: Index value required
Index brackets must contain either a literal number or a literal string.
```

**Solution:** Use Command Prompt or proper PowerShell escaping:
```cmd
# Use Command Prompt
terraform state rm -ignore-remote-version module.resource-group.azurerm_resource_group.rg["testing"]
```

**Error: Invalid character**
```
Error: Invalid character
This character is not used within the language.
```

**Solution:** Check your quoting and escaping:
```powershell
# Correct escaping in PowerShell
terraform state rm -ignore-remote-version 'module.resource-group.azurerm_resource_group.rg[\"testing\"]'
```

**Error: Terraform version mismatch**
```
Warning: Incompatible Terraform version
The local Terraform version (1.10.3) does not meet the version requirements
```

**Solution:** Use the `-ignore-remote-version` flag:
```powershell
terraform state rm -ignore-remote-version module.resource-group.azurerm_resource_group.rg
```

### 10.6 Verification After Removal

Always verify that the resource was successfully removed:

```powershell
# Check that resource is no longer in state
terraform state list

# Verify specific resource is gone
terraform state list | findstr "resource-group"
```

### 10.7 Alternative Methods for Complex Cases

#### Using Environment Variables
```powershell
# Set the resource address as an environment variable
$env:RESOURCE_ADDRESS = 'module.resource-group.azurerm_resource_group.rg["testing"]'

# Use it in the command
terraform state rm -ignore-remote-version $env:RESOURCE_ADDRESS
```

#### Using Temporary Files
```powershell
# Create a temporary file with the resource address
echo 'module.resource-group.azurerm_resource_group.rg["testing"]' > temp_address.txt

# Use the file content
$address = (Get-Content temp_address.txt -Raw).Trim()
terraform state rm -ignore-remote-version $address

# Clean up
Remove-Item temp_address.txt
```

### 10.8 Best Practices for Resource Removal

1. **Always List First**: Use `terraform state list` to see exact resource addresses
2. **Use Command Prompt**: For complex addresses, Command Prompt handles special characters better
3. **Backup State**: Consider backing up state before major removals
4. **Verify Removal**: Always check that the resource was actually removed
5. **Document Changes**: Keep track of what resources you've removed and why
6. **Use -ignore-remote-version**: When working with Terraform Cloud/Enterprise and version mismatches

### 10.9 When to Remove Resources from State

Common scenarios for removing resources from state:
- **Resource Migration**: Moving resources between Terraform configurations
- **Resource Cleanup**: Removing resources that are no longer needed in Terraform management
- **State Reorganization**: Restructuring your Terraform state organization
- **Import Corrections**: Fixing incorrectly imported resources
- **Module Refactoring**: Changing module structure or resource organization

**Important Note:** Removing a resource from state does **not** delete the actual Azure resource. It only stops Terraform from managing it.

## Step 11: Using import.tf with Terraform Cloud/Enterprise UI

After importing resources via import blocks, you can use Terraform Cloud/Enterprise UI for ongoing plan and apply operations.

### 10.1 Version Control Integration (Recommended)

1. **Connect your repository to Terraform Cloud/Enterprise:**
   - Go to your workspace in Terraform Cloud/Enterprise UI
   - Navigate to "Settings" → "Version Control"
   - Connect your Git repository (GitHub, GitLab, Azure DevOps, etc.)

2. **Commit and push your files:**
```powershell
# Add all files to git
git add .

# Commit the changes
git commit -m "Add import.tf and backend.tf for resource import"

# Push to your repository
git push origin main
```

### 10.2 Using Terraform Cloud/Enterprise UI for Plan and Apply

#### Plan Operations:
1. **Automatic Plans:** When you push to your connected repository, Terraform Cloud/Enterprise automatically triggers a plan
2. **Manual Plans:** 
   - Go to your workspace in Terraform Cloud/Enterprise UI
   - Click "Actions" → "Start new plan"
   - Select "Plan and apply" or "Plan only"
   - Add any variables if needed
   - Click "Start plan"

#### Apply Operations:
1. **After Plan Review:**
   - Review the plan output in Terraform Cloud/Enterprise UI
   - If the plan looks correct, click "Confirm & Apply"
   - Terraform Cloud/Enterprise will apply the changes

2. **Direct Apply:**
   - Go to "Actions" → "Start new apply"
   - This will run plan and apply in sequence

### 10.3 Workspace Configuration for UI Operations

Ensure your workspace is properly configured:

1. **Variables:**
   - Go to "Variables" tab in your workspace
   - Add any required variables (e.g., Azure credentials)
   - Set variable categories (Terraform, Environment, etc.)

2. **Azure Authentication:**
   - Add Azure credentials as environment variables:
     - `ARM_CLIENT_ID`
     - `ARM_CLIENT_SECRET` 
     - `ARM_SUBSCRIPTION_ID`
     - `ARM_TENANT_ID`

3. **Terraform Version:**
   - Go to "Settings" → "General"
   - Set the Terraform version constraint (e.g., `~> 1.9.0`)

### 10.4 Monitoring Imported Resources in UI

1. **State Management:**
   - Go to "States" tab to view current state
   - Download state files if needed
   - View state history and changes

2. **Runs History:**
   - Monitor all plan and apply operations
   - View logs and outputs
   - Track resource changes over time

### 10.5 Updating import.tf via UI Workflow

When you need to modify imported resources:

1. **Update import.tf locally:**
```hcl
# Example: Add tags to imported resources
resource "azurerm_resource_group" "example_rg" {
  name     = "existing-resource-group-name"
  location = "East US"
  
  tags = {
    Environment = "Production"
    Project     = "WebApp"
    ManagedBy   = "Terraform"
  }
}
```

2. **Commit and push changes:**
```powershell
git add import.tf
git commit -m "Add tags to imported resources"
git push origin main
```

3. **Review and apply in UI:**
   - Terraform Cloud/Enterprise will automatically trigger a plan
   - Review the plan to see tag additions
   - Apply the changes through the UI

### 10.6 Best Practices for UI Workflows

1. **Use Pull Request Workflows:**
   - Enable "Require approval before apply" in workspace settings
   - Create pull requests for changes
   - Require plan approval before merging

2. **Environment Separation:**
   - Use different workspaces for different environments
   - Configure workspace-specific variables
   - Use workspace-specific Terraform versions

3. **State Management:**
   - Regularly backup state files
   - Use state locking (automatic in Terraform Cloud/Enterprise)
   - Monitor state file sizes

4. **Security:**
   - Use workspace-specific API tokens
   - Implement proper access controls
   - Audit all operations through logs

## File Structure Example

Your directory should look like this:

```
tfe-webapp-network-dev/
├── backend.tf          # Backend configuration for Terraform Cloud
├── import.tf           # Resource definitions for import
├── main.tf             # Main Terraform configuration (optional)
├── variables.tf        # Variable definitions (optional)
└── outputs.tf          # Output definitions (optional)
```

## Common Import Block Examples

### Resource Groups
```hcl
import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}"
}
```

### Virtual Networks
```hcl
import {
  to = azurerm_virtual_network.vnet
  id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Network/virtualNetworks/{vnet-name}"
}
```

### Subnets
```hcl
import {
  to = azurerm_subnet.subnet
  id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Network/virtualNetworks/{vnet-name}/subnets/{subnet-name}"
}
```

### Storage Accounts
```hcl
import {
  to = azurerm_storage_account.storage
  id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Storage/storageAccounts/{storage-account-name}"
}
```

### Network Security Groups
```hcl
import {
  to = azurerm_network_security_group.nsg
  id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Network/networkSecurityGroups/{nsg-name}"
}
```

## Troubleshooting

### Authentication Issues
```powershell
# Verify login status
terraform login

# Check if token is set
echo $env:TF_TOKEN_app_terraform_io
```

### State Lock Issues
If you get state lock errors:
1. Check Terraform Cloud/Enterprise UI for running operations
2. Wait for operations to complete
3. Check workspace settings

### Resource Not Found
```powershell
# Verify resource exists in Azure
az resource show --name "resource-name" --resource-group "rg-name" --resource-type "Microsoft.Storage/storageAccounts"

# Check resource group
az group show --name "resource-group-name"
```

### Import Block Errors
- Ensure resource names in `import.tf` match Azure exactly
- Verify you have proper permissions in Azure
- Check that the resource actually exists
- Ensure Terraform version is 1.5 or later
- Verify Git integration is properly configured

### UI Workflow Issues
- Ensure workspace is connected to version control
- Check that variables are properly configured
- Verify Terraform version constraints match your local version
- Check workspace permissions and access controls
- Review plan logs for detailed error messages

## Best Practices

1. **Import One Resource at a Time**: Import resources individually to avoid complex state issues
2. **Verify Before Import**: Use `az resource show` to get exact resource details
3. **Backup State**: Always backup state before major operations
4. **Test Configuration**: Review plans in Terraform Cloud/Enterprise UI after each import
5. **Document Changes**: Keep track of imported resources and their configurations
6. **Use Version Control**: Always use Git integration for Terraform Cloud/Enterprise workflows
7. **Review Plans**: Always review plans in UI before applying
8. **Environment Separation**: Use separate workspaces for different environments
9. **Remove Import Blocks**: Clean up import blocks after successful import
10. **Monitor Runs**: Regularly check the "Runs" tab for operation status

## Next Steps

After successful import:
1. Review the imported resources in Terraform Cloud/Enterprise UI
2. Update your `import.tf` file with any missing configurations
3. Consider moving resource definitions to `main.tf` for better organization
4. Set up proper variable definitions in `variables.tf`
5. Add outputs in `outputs.tf` if needed
6. Configure version control integration for automated workflows
7. Set up proper workspace permissions and access controls
8. Monitor ongoing operations through the UI


