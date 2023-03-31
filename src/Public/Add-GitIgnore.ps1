Function Add-GitIgnore {
  <#
  .SYNOPSIS
    Adds a .gitignore file to the current directory.
  .DESCRIPTION
    Adds a .gitignore file to the current directory by invoking the gitignore API 
    from toptal.com: <https://www.toptal.com/developers/gitignore/api/:list>, where 
    `:list` is a comma-separated list of items to add or append to the 
    generated/pre-existing `.gitignore`. If no list is provided, the default is
    `Windows`.
  .PARAMETER List
    (Optional) The list of items or languages to add to the .gitignore file 
    (comma-separated). By default, this is just `Windows`.

    The list of items can be found at <https://www.toptal.com/developers/gitignore/api/list>.
  .PARAMETER Path
    (Optional) The path to the `.gitignore` file. By default, this is just 
    `.gitignore` in the current directory.
  .EXAMPLE
    Add-GitIgnore -List "Windows,VisualStudioCode"

    Adds the `Windows` and `VisualStudioCode` items to the `.gitignore` file.

  .EXAMPLE
    Add-GitIgnore -List "Python,R,PowerShell" -Path "C:\Temp\.gitignore"

    Adds ignores associate with Python, R, and PowerShell to the `.gitignore`
    file located at `C:\Temp\.gitignore`.
  
  .NOTES
    As stated in the description, this function uses the gitignore API from
    toptal.com. This API is open-source and can be found at 
    <https://www.toptal.com/developers/gitignore/api/>.

    This function is based on the `gig` function from:
    https://docs.gitignore.io/install/command-line#powershell-v3-script.

    Supported items can be found at by calling the `/api/list` endpoing here:
    <https://www.toptal.com/developers/gitignore/api/list>.
  #>
  [CmdletBinding()]
  [Alias("gitignore")]
  Param (
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $true,
      HelpMessage = "The list of items or languages to add to the .gitignore file."
    )][string[]]$List = @("Windows"),
    
    [Parameter(
      Mandatory = $false,
      HelpMessage = "The path to the .gitignore file."
    )][string]$Path = $(Join-Path -path $PWD -ChildPath ".gitignore") 
  )

  $params = ($List | ForEach-Object { [uri]::EscapeDataString($_) }) -join ","
  $uri = "https://www.toptal.com/developers/gitignore/api/$params"
  
  try {
    $content = Invoke-WebRequest -Uri $uri | Select-Object -ExpandProperty content
  } catch {
    Write-Error "Unable to retrieve .gitignore file from $uri - check internet connection and try again."
    return
  }  
  
  $content | Out-File -FilePath $Path -Encoding ascii -Force -Append 
  
  $listSep = ($List -join ', ')
  Write-Verbose "Added/Appended Items for $listSep to $Path"
  
}
