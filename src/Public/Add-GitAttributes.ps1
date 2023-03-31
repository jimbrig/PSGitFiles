# PSGitIgnore Module

# This module is used to create a .gitignore file for a project.

Function Add-GitAttributes {
  <#
  .SYNOPSIS
    Adds a .gitignore file to the current directory.
  .DESCRIPTION
    Adds a .gitattributes file to the current directory by invoking the GitHub API 
    from the repo: alexkaratarakis/gitattributes. If no list is provided, the 
    default is `Common`.
  .PARAMETER List
    (Optional) The list of items or languages to add to the .gitignore file 
    (comma-separated). By default, this is just `Common`.

    The list of items can be found at <https://github.com/alexkaratarakis/gitattributes>.
  .PARAMETER Path
    (Optional) The path to the `.gitignore` file. By default, this is just 
    `.gitattributes` in the current directory.
  .EXAMPLE
    Add-GitAttributes -List "Common,PowerShell"

    Adds the `Common` and `PowerShell` items to the `.gitattributes` file.
  .EXAMPLE
    Add-GitAttributes -List @("R", "Markdown", "Python") -Path "C:\Temp\.gitattributes"

    Adds attributes for R, Markdown, and Python to the `.gitattributes`
    file located at `C:\Temp\.gitattributes`.
  #>
  [CmdletBinding()]
  [Alias("gitattributes")]
  Param (
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $true,
      HelpMessage = "The list of items or languages to add to the .gitattributes file."
    )][string[]]$List = @("Common"),
    
    [Parameter(
      Mandatory = $false,
      HelpMessage = "The path to the .gitattributes file."
    )][string]$Path = $(Join-Path -path $PWD -ChildPath ".gitattributes") 
  )


  If(-not (Test-Path -Path $Path)) {
    New-Item -Path $Path -ItemType File -Force
    Set-Content -Path $Path -Value ""
  }

  $BaseURI = "https://raw.githubusercontent.com/alexkaratarakis/gitattributes/master/"
  $URIs = $List | ForEach-Object { "$BaseURI$_.gitattributes" }

  ForEach ($URI in $URIs) {
    $Content = ""
    Write-Verbose "Retrieving .gitattributes from $URI..."
    try {
      $Content = (Invoke-WebRequest -Uri $URI).Content + "`n" + "`n"
    } catch {
      Write-Error "Unable to retrieve .gitattributes file from $URI."
    }

    If ($Content -ne "") {
      Add-Content -Path $Path -Value $Content
    }
    Write-Verbose "Added/Appended Items for $URI to $Path"
  }  
  
  $listSep = ($List -join ', ')
  Write-Verbose "Added/Appended Items for $listSep to $Path"
  
}
