Function Search-Google {
    <#
    .SYNOPSIS
        Opens a google search in the default browser.

    .DESCRIPTION
        Credit goes to https://github.com/nickbeau/PowerShellScripting/blob/master/scripts/googlefunction.ps1
    #>
        $query = 'https://www.google.com/search?q='
        foreach ($arg in $ARGS) { $query += "${arg}+" }
        $url = $query.Substring(0, $query.Length - 1)
        start "$url"
}

Set-Alias glg Search-Google
