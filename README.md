# PSGitFiles

> PowerShell Module for managing git repository files (i.e. `.gitignore`, `.gitattributes`, etc.)

## Install

```powerShell
Install-Module PSGitFiles
```

## Usage

```powershell
Import-Module PSGitFiles

Add-GitIgnore -List @("Windows", "PowerShell")

Add-GitAttributes -List @("Common", "Markdown", "PowerShell")
```
