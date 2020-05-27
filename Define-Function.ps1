function Define-Function {
    <#
    .SYNOPSIS
        Create a PowerShell function

    .DESCRIPTION
        This is useful if you want to create a function where the name
        is given by an arbitrary string expression.

        When defining a function with the PowerShell "Function" keyword
        then a fixed name has to be given.

    .PARAMETER Force
        Equivalent to RemoveAlias and RemoveFunction

    .PARAMETER RemoveAlias
        If an alias exists with the given name, remove it. This is neccessary because
        aliases have higher precedence than functions.

    .PARAMETER RemoveFunction
        If a function exists with the given name, remove it. Without this switch, an error
        would be thrown.

    .EXAMPLE
        Define-Function "${funname}-asdf" {Write-Host "Hello World"}

    .EXAMPLE
        Define-Function "existingfunction" {Write-Host "new implementation"} -RemoveFunction
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [String] $Name,
        [Parameter(Mandatory)] [ScriptBlock] $Implementation,
        [Switch] $RemoveAlias,
        [Switch] $RemoveFunction,
        [Switch] $Force
    )

    if ($Force) {
        $RemoveAlias = $True
        $RemoveFunction = $True
    }

    # Check if the function already exists
    if (Test-Path "Function:$Name") {
        if ($RemoveFunction) {
            Remove-Item -Path "Function:$Name"
        } else {
            throw "Function $Name already exists."
        }
    }

    # Check if an alias with this name exists
    if ($RemoveAlias) {
        # We need to run this twice because if a local alias exists
        # inside the function scope then the first time we only remove
        # the local alias, the second time the global alias is removed.
        if (Test-Path "Alias:$Name") {Remove-Item "Alias:$Name" -Force}
        if (Test-Path "Alias:$Name") {Remove-Item "Alias:$Name" -Force}
    }

    New-Item -Path "Function:global:$Name" -Value $Implementation
}
