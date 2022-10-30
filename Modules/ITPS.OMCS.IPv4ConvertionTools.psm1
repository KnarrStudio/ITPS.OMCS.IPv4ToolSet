function Add-IntToIPv4Address
{
  <#
      .SYNOPSIS
      Add an integer to an IP Address and get the new IP Address.

      .DESCRIPTION
      Add an integer to an IP Address and get the new IP Address.

      .PARAMETER IPv4Address
      The IP Address to add an integer to.

      .PARAMETER Integer
      An integer to add to the IP Address. Can be a positive or negative number.

      .EXAMPLE
      Add-IntToIPv4Address -IPv4Address 10.10.0.252 -Integer 10

      10.10.1.6

      Description
      -----------
      This command will add 10 to the IP Address 10.10.0.1 and return the new IP Address.

      .EXAMPLE
      Add-IntToIPv4Address -IPv4Address 192.168.1.28 -Integer -100

      192.168.0.184

      Description
      -----------
      This command will subtract 100 from the IP Address 192.168.1.28 and return the new IP Address.
  #>
  param(
    [Parameter(Mandatory = $true)]
    [String]$IPv4Address
    ,
    [Parameter(Mandatory = $true)]
    [int64]$Integer
  )
  try
  {
    $ipInt = ConvertIPv4ToInt -IPv4Address $IPv4Address `
      -ErrorAction Stop
    $ipInt += $Integer

    return (ConvertIntToIPv4 -Integer $ipInt)
  }
  catch
  {
    Write-Error -Exception $_.Exception `
      -Category $_.CategoryInfo.Category
  }
}

function Convert-IPv4AddressToBinaryString
{
  <#
      .SYNOPSIS
      Converts an IPv4 Address to Binary String

      .PARAMETER IPAddress
      The IP Address to convert to a binary string representation

      .EXAMPLE
      Convert-IPv4AddressToBinaryString -IPAddress 10.130.1.52
  #>
  Param(
    [IPAddress]$IPAddress = '0.0.0.0'
  )
  $addressBytes = $IPAddress.GetAddressBytes()

  $strBuilder = New-Object -TypeName Text.StringBuilder
  foreach ($byte in $addressBytes)
  {
    $8bitString = [Convert]::ToString($byte, 2).PadLeft(8, '0')
    $null = $strBuilder.Append($8bitString)
  }
  return $strBuilder.ToString()
}

function Convert-CIDRToNetMask
{
  <#
      .SYNOPSIS
      Converts a CIDR to a netmask

      .EXAMPLE
      Convert-CIDRToNetMask -PrefixLength 26

      Returns: 255.255.255.192/26

      .NOTES
      To convert back use "Convert-NetMaskToCIDR"
  #>
  [CmdletBinding()]
  [Alias('ToMask')]
  param(
    [ValidateRange(0, 32)]
    [int16]$PrefixLength = 0
  )
  $bitString = ('1' * $PrefixLength).PadRight(32, '0')
  $strBuilder = New-Object -TypeName Text.StringBuilder

  for ($i = 0; $i -lt 32; $i += 8)
  {
    $8bitString = $bitString.Substring($i, 8)
    $null = $strBuilder.Append(('{0}.' -f [Convert]::ToInt32($8bitString, 2)))
  }

  return $strBuilder.ToString().TrimEnd('.')
}

function Convert-NetMaskToCIDR
{
  <#
      .SYNOPSIS
      Converts a netmask to a CIDR

      .EXAMPLE
      Convert-NetMaskToCIDR -SubnetMask 255.255.255.192

      Returns: 26

      .NOTES
      To convert back use "Convert-CIDRToNetMask"
  #>
  [CmdletBinding()]
  [Alias('ToCIDR')]
  param(
    [String]$SubnetMask = '255.255.255.0'
  )
  $byteRegex = '^(0|128|192|224|240|248|252|254|255)$'
  $invalidMaskMsg = ('Invalid SubnetMask specified [{0}]' -f $SubnetMask)
  try
  {
    $netMaskIP = [IPAddress]$SubnetMask
    $addressBytes = $netMaskIP.GetAddressBytes()

    $strBuilder = New-Object -TypeName Text.StringBuilder

    $lastByte = 255
    foreach ($byte in $addressBytes)
    {
      # Validate byte matches net mask value
      if ($byte -notmatch $byteRegex)
      {
        Write-Error -Message $invalidMaskMsg `
          -Category InvalidArgument `
          -ErrorAction Stop
      }
      elseif ($lastByte -ne 255 -and $byte -gt 0)
      {
        Write-Error -Message $invalidMaskMsg `
          -Category InvalidArgument `
          -ErrorAction Stop
      }

      $null = $strBuilder.Append([Convert]::ToString($byte, 2))
      $lastByte = $byte
    }

    return ($strBuilder.ToString().TrimEnd('0')).Length
  }
  catch
  {
    Write-Error -Exception $_.Exception `
      -Category $_.CategoryInfo.Category
  }
}

