function Get-License {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)][string]$License,
        [Parameter(Position = 1)][string]$Destination = "$($PWD.Path)\LICENSE",
        [Parameter(Position = 2)][string]$Source = 'github'
    )

    if ($Source -eq 'github') {
        $sourceComposition = 'https://raw.githubusercontent.com/spdx/license-list-data/{0}/text/{1}.txt'        
    }
    elseif ($Source -eq 'fastgit') {
        $sourceComposition = 'https://raw.fastgit.org/spdx/license-list-data/{0}/text/{1}.txt'
    }
    elseif ($source -eq 'jsdelivr') {
        $sourceComposition = 'https://cdn.jsdelivr.net/gh/spdx/license-list-data@{0}/text/{1}.txt'
    }

    $sourceBranch = (Invoke-RestMethod -UseBasicParsing -Uri 'https://api.github.com/repos/spdx/license-list-data').default_branch

    Invoke-WebRequest -UseBasicParsing -OutFile $Destination -Uri ($sourceComposition -f $sourceBranch, $License)
}

function Find-License {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)][string]$Query
    )

    $licenses = @()

    $res = (Invoke-RestMethod -UseBasicParsing -Uri 'https://api.github.com/repos/spdx/license-list-data/contents/text')
    foreach ($i in $res) {
        if ($i.name.IndexOf($Query) -gt -1) {
            $licenses += $i.name.Substring(0, $i.name.Length - 4)
        }
    }

    return $licenses
}