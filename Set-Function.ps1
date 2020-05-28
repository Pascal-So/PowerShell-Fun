function Set-Function {
    <#
    .SYNOPSIS
        Create a PowerShell function

    .DESCRIPTION
        This is useful if you want to create a function where the name
        is given by an arbitrary string expression.

        When defining a function with the PowerShell "Function" keyword
        then a fixed name has to be given.

    .PARAMETER RemoveAlias
        If an alias exists with the given name, remove it. This is neccessary because
        aliases have higher precedence than functions.

    .EXAMPLE
        Set-Function "${funname}-asdf" {Write-Output "Hello World"}

    .EXAMPLE
        Set-Function "existingfunction" {Write-Output "new implementation"} -Confirm
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory)] [String] $Name,
        [Parameter(Mandatory)] [ScriptBlock] $Implementation,
        [Switch] $NoRemoveAlias
    )

    # Check if the function already exists
    if (Test-Path "Function:$Name") {
        if ($PSCmdlet.ShouldProcess("Function:$Name", 'Overwrite the function.')) {
            Remove-Item -Path "Function:$Name" -Confirm:$false
        } else {
            return
        }
    }

    # Check if an alias with this name exists
    if ((-not $NoRemoveAlias) -and (Test-Path "Alias:$Name")) {
        if ($PSCmdlet.ShouldProcess("Alias:$Name", 'Remove the alias.')) {
            Remove-Item "Alias:$Name" -Force -Confirm:$False

            # We need to run this a second time because if a local alias exists
            # inside the function scope then the first time we only remove
            # the local alias, the second time the global alias is removed.
            if (Test-Path "Alias:$Name") {Remove-Item "Alias:$Name" -Force}
        }
    }

    New-Item -Path "Function:global:$Name" -Value $Implementation -Confirm:$False | Out-Null
}
