. "$PSScriptRoot\Set-Function.ps1"

Set-Function ga {git add @ARGS}
Set-Function gd {git diff @ARGS}
Set-Function gc {git commit @ARGS}
Set-Function gs {git status @ARGS}

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
