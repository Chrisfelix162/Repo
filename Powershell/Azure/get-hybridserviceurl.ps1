$token = (Get-AzAccessToken).Token
$ac = "AutomationAccount"
$url = "https://eastus.management.azure.com/subscriptions/fd7747d0-6fa3-4604-8810-848b5aa126ca/resourcegroups/$RG/providers/Microsoft.Automation/automationAccounts/${ac}?api-version=2021-06-22"
$data = Invoke-RestMethod -Method Get $url -Headers @{"Authorization" = "Bearer $token"}
$automationHybridServiceUrl = $data.properties.automationHybridServiceUrl
$automationHybridServiceUrl
