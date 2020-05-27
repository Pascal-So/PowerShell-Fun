<#
.SYNOPSIS
Aliases ¯\_(ツ)_/¯
#>

# Make sure Define-Command is available
. "$PSScriptRoot\Define-Function.ps1"

Define-Function ga {git add @ARGS}    -Force
Define-Function gd {git diff @ARGS}   -Force
Define-Function gc {git commit @ARGS} -Force
Define-Function gs {git status @ARGS} -Force

Function Find-ProgramPath ([String] $name, [uint32] $depth=2) {
    Function find-in([String] $path) {
        return Get-ChildItem "$path" -Filter "$name" -Recurse -Depth $depth -ErrorAction SilentlyContinue
    }

    $file_list = find-in("C:\Program Files\")
    if ($file_list.count -gt 0) {
        return $file_list[0].FullName
    }

    $file_list = find-in("C:\Program Files (x86)\")
    if ($file_list.count -gt 0) {
        return $file_list[0].FullName
    }

    throw "Could not find program $name"
}

New-Alias -Name subl -Value $(Find-ProgramPath "subl.exe")
New-Alias s subl
