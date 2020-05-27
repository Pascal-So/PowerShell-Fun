Function Is-Administrator {
    <#
    .SYNOPSIS
        Check if running as admin

    .DESCRIPTION
        Taken from here: https://devblogs.microsoft.com/scripting/check-for-admin-credentials-in-a-powershell-script/
    #>

    $current = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    return $current.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}
