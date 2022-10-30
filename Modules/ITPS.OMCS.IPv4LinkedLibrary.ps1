# Non-Published Functions referenced by other modules

function ConvertIPv4ToInt
{
  [CmdletBinding()]
  param(
    [String]$IPv4Address
  )
  try
  {
    $ipAddress = [IPAddress]::Parse($IPv4Address)

    $bytes = $IPAddress.GetAddressBytes()
    [Array]::Reverse($bytes)

    return [BitConverter]::ToUInt32($bytes, 0)
  }
  catch
  {
    Write-Error -Exception $_.Exception `
      -Category $_.CategoryInfo.Category
  }
}

function ConvertIntToIPv4
{
  [CmdletBinding()]
  param(
    [uint32]$Integer
  )
  try
  {
    $bytes = [BitConverter]::GetBytes($Integer)
    [Array]::Reverse($bytes)
    ([IPAddress]($bytes)).ToString()
  }
  catch
  {
    Write-Error -Exception $_.Exception `
      -Category $_.CategoryInfo.Category
  }
}
