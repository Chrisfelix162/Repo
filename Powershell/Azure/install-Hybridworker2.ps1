function install-Hybridworker2{
        param
        (
            [string]$RG = "",
        
            [string]$vm = ",
        
            [string]$Automationaccountname = '',
        
            [string]$vmid = (get-azvm -name $vm).id,
        
            [string]$location = "eastus",
        
            [string]$HWG = "",
        
            [string]$guid = [guid]::NewGuid().tostring(),
        
            [string]$AutomationAccountURL = (Get-AzAutomationRegistrationInfo -ResourceGroupName $RG -AutomationAccountName $AC).Endpoint,
          
            [string]$ScriptString = 'cd C:\Packages\Plugins\Microsoft.Azure.Automation.HybridWorker.HybridWorkerForWindows\*\bin\ -ErrorAction SilentlyContinue
            Import-Module .\HybridWorkerExtensionHandler.psm1
            Import-Module .\HybridWorkerExtensionStatus.psm1
            Import-Module ..\bin\Log.psm1
            .\disable.cmd -ErrorAction SilentlyContinue
            .\uninstall.ps1 -ErrorAction SilentlyContinue
            get-item HKLM:\SOFTWARE\Microsoft\Azure\HybridWorker\ | Remove-Item -Recurse -force -ErrorAction SilentlyContinue
            get-Item HKLM:\SOFTWARE\Microsoft\HybridRunbookWorkerV2\ | Remove-Item -Recurse -force -ErrorAction SilentlyContinue
            get-Item HKLM:\SOFTWARE\Microsoft\HybridRunbookWorker\ | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue'
        )

        $token = (Get-AzAccessToken).Token
        $ac = "Aptify70auto"
        $url = "https://eastus.management.azure.com/subscriptions/fd7747d0-6fa3-4604-8810-848b5aa126ca/resourcegroups/Aptify70POC/providers/Microsoft.Automation/automationAccounts/${ac}?api-version=2021-06-22"
        $data = Invoke-RestMethod -Method Get $url -Headers @{"Authorization" = "Bearer $token"}
        $automationHybridServiceUrl = $data.properties.automationHybridServiceUrl
        $automationHybridServiceUrl
        $settings2 = @{
            "AutomationAccountURL"  = "$automationHybridServiceUrl";    
        };

Invoke-AzVMRunCommand -ResourceGroupName $RG -VMName $vm -CommandId 'RunPowerShellScript' -ScriptString $ScriptString -Verbose

Remove-AzVMExtension -ResourceGroupName $RG -VMName $vm -Name HybridWorkerExtension -Force -Verbose -ErrorAction SilentlyContinue

Set-AzVMExtension -ResourceGroupName $RG -Location $location -VMName $vm -Name "HybridWorkerExtension" -Publisher "Microsoft.Azure.Automation.HybridWorker" `
-ExtensionType HybridWorkerForWindows -TypeHandlerVersion 1.1 -Settings $settings2 -EnableAutomaticUpgrade $true -Verbose
}

install-Hybridworker2 
