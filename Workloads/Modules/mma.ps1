$PublicSettings = @{"workspaceId" = "1b19d8fe-a921-449e-9ecc-ce7711cbfe6e"}
$ProtectedSettings = @{"workspaceKey" = "a63ozG8BHGquHrwW+5jKdVKYFKOaTpHatLsc/YimqK7ewgkf/0v6GV+Ehx0xh1HKlKaJHXfboVMyofPi8WOn7Q=="}
Set-AzVMExtension -ExtensionName "MicrosoftMonitoringAgent" `
    -ResourceGroupName "rg-vm-eastus-dev" `
    -VMName "vm-eastus-dev" `
    -Publisher "Microsoft.EnterpriseCloud.Monitoring" `
    -ExtensionType "MicrosoftMonitoringAgent" `
    -TypeHandlerVersion 1.0 `
    -Settings $PublicSettings `
    -ProtectedSettings $ProtectedSettings `
    -Location EastUS

