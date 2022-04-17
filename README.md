# License Fetcher

## Usage

### Bash

Import script: `source $PATH_TO_SCRIPT/license-fetcher.sh`

#### Find license

```bash
license-list | grep $QUERY
```

#### Get license

```bash
license-get -l $LICENSE -o $PATH_TO_OUTPUT
```

### PowerShell

Import script: `Import-Module $PathToScript/license-fetcher.psm1`

#### Find license

```powershell
Find-License -Query $Query
```

#### Get license

```powershell
Get-License -License $License -Destination $Destination -Source github
```

## License

GNU General Public License Version 3