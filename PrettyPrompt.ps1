. "$PSScriptRoot\Format-ShortInterval.ps1"
. "$PSScriptRoot\Is-Administrator.ps1"
. "$PSScriptRoot\Utils.ps1"

Function PrettyPrompt([System.ConsoleColor] $UserColor = "Blue", [System.ConsoleColor] $AdminColor = "Red", [System.ConsoleColor] $HostColor = "White") {
    <#
    .SYNOPSIS
        My fav prompt for any terminal

    .DESCRIPTION
        This prompt is roughly based on https://github.com/pascal-so/bashprompt

        Result is roughly like this:
        (3.14s) (21:15) Pascal@Tuman D:\documents>

        No guarantee that this works with network drives or anything like that.

    .PARAMETER UserColor
        Print the username in this color.

    .PARAMETER AdminColor
        Print the username in this color if the current PowerShell is running as Administrator.

    .PARAMETER HostColor
        Print the computer name in this color.

    .EXAMPLE
        PrettyPrompt
        (3.14s) (21:15) Pascal@Tuman ~>
    #>

    function Get-LastExecutionTime {
        if ((Get-History).count -eq 0) {
            return [TimeSpan]0
        }

        return Get-HistoryEntryDuration((Get-History)[-1])
    }

    function Get-ShortLocation {
        <#
        .DESCRIPTION
            replace path to home with ~ in the pwd. this is
            not really windows style but idk
        #>

        $FullPathName = $(Get-Location).Path
        if ($FullPathName.ToLower().StartsWith($HOME.ToLower())) {
            return "~" + $FullPathName.Substring($HOME.length)
        } else {
            return $FullPathName
        }
    }

    # If the last command failed we print the execution time in red.
    $StatusColor = if ($?) {"White"} else {"Red"}

    if (Is-Administrator) {
        $UserColor = $AdminColor
    }

    Write-Host "($(Format-ShortInterval(Get-LastExecutionTime)))" -ForegroundColor $StatusColor -NoNewline
    Write-Host " ($(Get-Date -Format "HH:mm")) " -NoNewline
    Write-Host $env:USERNAME -ForegroundColor $UserColor -NoNewline
    Write-Host "@" -NoNewline
    Write-Host $env:COMPUTERNAME -ForegroundColor $HostColor -NoNewline
    Write-Host " $(Get-ShortLocation)$('>' * ($nestedPromptLevel + 1))" -NoNewline

    # This is required otherwise this function returns $null which indicates
    # an invalid prompt to PowerShell and therefore PowerShell adds its own
    # default PS> prompt... at least that's how I understood it from 1 minute
    # of digging around.
    return " "
}
