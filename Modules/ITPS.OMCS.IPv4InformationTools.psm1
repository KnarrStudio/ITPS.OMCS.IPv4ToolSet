function Get-Ipv4SbubnetFromHostCount
{
  <#
      .SYNOPSIS
      Returns the CIDR number for a host count that will support the number of hosts you entered.
  #>
  [Alias('Get-CidrFromHostCount')]
  param(
    [Parameter(
        Mandatory = $true,
        ValueFromPipeline = $true,
    HelpMessage = 'Integer between 1 - 4294967293')]
    [ValidateScript({
          if(($_ -gt 0) -and ($_ -lt 4294967294))
          {
            $true
          }
          Else
          {
            Throw 'Input file needs to be an integer between 1 - 4294967293'
          }
    })]
    [UInt32]$HostCount
  )
  begin
  {
    $MyInvocation.Line
    If ($MyInvocation.Line -match 'Get-CidrFromHostCount') 
    {
      Write-Warning -Message 'The "Get-CidrFromHostCount" is depreciated.  Use: Get-Ipv4SbubnetFromHostCount'
    }
  }
  process
  {
    #Calculate available host addresses
    $i = $maxHosts = 0
    do
    {
      $i++
      $maxHosts = ([math]::Pow(2, $i) - 2)
      $prefix = 32 - $i
    }
    until ($maxHosts -ge $HostCount)
    $Subnet = Convert-CIDRToNetMask -PrefixLength $prefix
    $Binary = Convert-IPv4AddressToBinaryString -IPAddress $Subnet
    $NetworkSize = [PSCustomObject]@{
      PrefixLength = $prefix
      Subnet       = $Subnet
      Binary       = $Binary
    }

    return $NetworkSize
  }
}

function Get-IPv4Subnet
{
  <#
      .SYNOPSIS
      Get information about an IPv4 subnet based on an IP Address and a subnet mask or prefix length

      .DESCRIPTION
      Get information about an IPv4 subnet based on an IP Address and a subnet mask or prefix length

      .PARAMETER IPAddress
      The IP Address to use for determining subnet information.

      .PARAMETER PrefixLength
      The prefix length of the subnet.

      .PARAMETER SubnetMask
      The subnet mask of the subnet.

      .EXAMPLE
      Get-IPv4Subnet -IPAddress 192.168.34.76 -SubnetMask 255.255.128.0

      CidrID       : 192.168.0.0/17
      NetworkID    : 192.168.0.0
      SubnetMask   : 255.255.128.0
      PrefixLength : 17
      HostCount    : 32766
      FirstHostIP  : 192.168.0.1
      LastHostIP   : 192.168.127.254
      Broadcast    : 192.168.127.255

      Description
      -----------
      This command will get the subnet information about the IPAddress 192.168.34.76, with the subnet mask of 255.255.128.0

      .EXAMPLE
      Get-IPv4Subnet -IPAddress 10.3.40.54 -PrefixLength 25

      CidrID       : 10.3.40.0/25
      NetworkID    : 10.3.40.0
      SubnetMask   : 255.255.255.128
      PrefixLength : 25
      HostCount    : 126
      FirstHostIP  : 10.3.40.1
      LastHostIP   : 10.3.40.126
      Broadcast    : 10.3.40.127

      Description
      -----------
      This command will get the subnet information about the IPAddress 10.3.40.54, with the subnet prefix length of 25.
      Prefix length specifies the number of bits in the IP address that are to be used as the subnet mask.

  #>
  [CmdletBinding(DefaultParameterSetName = 'PrefixLength')]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      ValueFromRemainingArguments = $false,
      HelpMessage = 'IP Address in the form of XXX.XXX.XXX.XXX',
      Position = 0
    )]
    [IPAddress]$IPAddress
    ,
    [Parameter(
      Position = 1,
      ParameterSetName = 'PrefixLength',
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [Int16]$PrefixLength = 24
    ,
    [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'SubnetMask')]
    [IPAddress]$SubnetMask
    ,
    [Parameter(
      Mandatory = $true,
      Position = 1,
      ParameterSetName = 'Hosts',
      HelpMessage = 'Number of hosts in need of IP Addresses'
    )]
    [Int64]$HostCount
  )
  begin
  {
  }
  process
  {
    try
    {
      if ($PSCmdlet.ParameterSetName -eq 'SubnetMask')
      {
        $PrefixLength = Convert-NetMaskToCIDR -SubnetMask $SubnetMask `
          -ErrorAction Stop
      }
      else
      {
        $SubnetMask = Convert-CIDRToNetMask -PrefixLength $PrefixLength `
          -ErrorAction Stop
      }
      if ($PSCmdlet.ParameterSetName -eq 'Hosts')
      {
        $PrefixLength = (Get-CidrFromHostCount -HostCount $HostCount).PrefixLength
        $SubnetMask = Convert-CIDRToNetMask -PrefixLength $PrefixLength `
          -ErrorAction Stop
      }
      $maxHosts = [math]::Pow(2, (32 - $PrefixLength)) - 2

      $netMaskInt = ConvertIPv4ToInt -IPv4Address $SubnetMask
      $ipInt = ConvertIPv4ToInt -IPv4Address $IPAddress

      $networkID = ConvertIntToIPv4 -Integer ($netMaskInt -band $ipInt)

      $broadcast = Add-IntToIPv4Address -IPv4Address $networkID `
        -Integer ($maxHosts + 1)

      $firstIP = Add-IntToIPv4Address -IPv4Address $networkID -Integer 1
      $lastIP = Add-IntToIPv4Address -IPv4Address $broadcast -Integer (-1)

      if ($PrefixLength -eq 32)
      {
        $broadcast = $networkID
        $firstIP = $null
        $lastIP = $null
        $maxHosts = 0
      }

      $outputObject = New-Object -TypeName PSObject

      $memberParam = @{
        InputObject = $outputObject
        MemberType  = 'NoteProperty'
        Force       = $true
      }
      Add-Member @memberParam -Name CidrID -Value ('{0}/{1}' -f $networkID, $PrefixLength)
      Add-Member @memberParam -Name NetworkID -Value $networkID
      Add-Member @memberParam -Name SubnetMask -Value $SubnetMask
      Add-Member @memberParam -Name PrefixLength -Value $PrefixLength
      Add-Member @memberParam -Name HostCount -Value $maxHosts
      Add-Member @memberParam -Name FirstHostIP -Value $firstIP
      Add-Member @memberParam -Name LastHostIP -Value $lastIP
      Add-Member @memberParam -Name Broadcast -Value $broadcast

      Write-Output -InputObject $outputObject
    }
    catch
    {
      Write-Error -Exception $_.Exception `
        -Category $_.CategoryInfo.Category
    }
  }
  end
  {
  }
}

function Get-SubnetCheatSheet
{
  <#
      .SYNOPSIS
      Creates a little cheatsheet for subnets.

      .DESCRIPTION
      Creates and send a cheatsheet for subnets to the console or send it to a file such as a CSV for opening in a spreadsheet.
      The default is formated for the console.  

      .PARAMETER Raw
      Use this parameter to output an object for more manipulation

      .EXAMPLE
      Get-SubnetCheatSheet  

      .EXAMPLE
      Get-SubnetCheatSheet -Raw | Where-Object {($_.CIDR -gt 15) -and ($_.CIDR -lt 22)} | Select-Object CIDR,Netmask
      
      .EXAMPLE
      Get-SubnetCheatSheet -Raw | Export-Csv .\SubnetSheet.csv -NoTypeInformation
      Sends the data to a csv file

      .EXAMPLE
      Get-SubnetCheatSheet -Raw | Where-Object {$_.NetMask -like '255.255.*.0' }
      Selects only one class of subnets

      .Example
      Get-SubnetCheatSheet | Out-Printer -Name (Get-Printer | Out-GridView -PassThru).Name 
  #>
  [CmdletBinding()]
  [Alias('SubnetList','ListSubnets')]
  param(
    [Switch]$Raw
  )
  Begin{
    $OutputFormatting = '{0,4} | {1,13:#,#} | {2,13:#,#} | {3,-15}  '

    $CheatSheet = @()
  }
  Process{
    for($CIDR = 32;$CIDR -gt 0;$CIDR--)
    {
      $netmask = Convert-CIDRToNetMask -PrefixLength $CIDR
      $Addresses = [math]::Pow(2,32-$CIDR)
      $HostCount = (&{
          if($Addresses -le 2)
          {
            '0'
          }
          else
          {
            $Addresses -2
          }
      })
  
      $hash = [PsCustomObject]@{
        CIDR      = $CIDR
        NetMask   = $netmask
        HostCount = $HostCount
        Addresses = $Addresses
      }
      $CheatSheet += $hash
    }
  }
  End{
    if(-not $Raw)
    {
      $OutputFormatting  -f 'CIDR', 'Host Count', 'Addresses', 'NetMask'
      '='*55
      foreach($item in $CheatSheet)
      {
        $OutputFormatting -f $item.CIDR, $item.HostCount, $item.Addresses, $item.NetMask
      }
    }
    Else
    {
      $CheatSheet
    }
  }
}


