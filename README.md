# ITPS.OMCS.IPv4ToolSet
IP v4 tool set has the following functions.  The original idea was to provide a set of networking tools for the Sys Admin/Eng.  Of Course some of these may be useful to our Networking brothers and sisters.

- Add-IntToIPv4Address
- Convert-NetMaskToCIDR
- Convert-CIDRToNetMask
- Convert-IPv4AddressToBinaryString
- Get-IPv4Subnet
- Get-SubnetCheatSheet 
- Get-CidrFromHostCount
- Find-MtuSize
- Ping-IpRange
- Test-TheInternet

#### Shout Out and Thanks
To Briansworth, where the module was forked from. Many of the tools were written by him.  Some of his tools made the others more efficient and streamlined.  Specificlly, the few functions that provide some heavy lifting for the exported functions.  These dependent functions are loaded with the _ITPS.OMCS.IPv4LinkedLibrary_ module.   

#### Reason for the fork
We wanted to expand on what we saw as a toolbox and felt that direction was moving away from what was a specific set of tools.  Afterall the `Ping-IpRange` is helpful, but not really a Subnet item.  

## Exported Functions 

#### Convert-IPv4AddressToBinaryString
Converts an IP v4 Address to Binary String 

    192.168.1.5 = 11000000101010000000000100000101


#### Add-IntToIPv4Address
Adds an integer to an IP Address and get the new IP Address.  This is helpful when you are trying to get a range.        An integer to add to the IP Address. Can be a positive or negative number.

	10.10.0.252 + 100 = 10.10.1.96


#### Convert-CIDRToNetMask
Converts a CIDR to a netmask 

    /26 = 255.255.255.192/26

#### Convert-NetMaskToCIDR 
Converts a netmask to a CIDR

    255.255.255.192 = /26


#### Get-SubnetCheatSheet
Creates a little cheatsheet for subnets to the console or send it to a file such as a CSV for opening in a spreadsheet.

    CIDR |    Host Count |     Addresses | NetMask       
    ========================================================
      32 |             0 |             1 | 255.255.255.255 | 
      31 |             0 |             2 | 255.255.255.254 | 
      30 |             2 |             4 | 255.255.255.252 | 
      29 |             6 |             8 | 255.255.255.248 | 
      28 |            14 |            16 | 255.255.255.240 | 
      27 |            30 |            32 | 255.255.255.224 | 
      26 |            62 |            64 | 255.255.255.192 | 


#### Get-IPv4Subnet
The primary function for this tools set.  The function gets information about an IPv4 subnet based on an IP Address and a subnet mask or prefix length

      CidrID       : 192.168.0.0/17
      NetworkID    : 192.168.0.0
      SubnetMask   : 255.255.128.0
      PrefixLength : 17
      HostCount    : 32766
      FirstHostIP  : 192.168.0.1
      LastHostIP   : 192.168.127.254
      Broadcast    : 192.168.127.255

#### Ping-IpRange
Pings through the range of IP addresses based on the First and Last Address provided.

      Address      Available
      -------      ---------
      192.168.0.22     False
      192.168.0.23     False
      192.168.0.25     False
      192.168.0.20      True
      192.168.0.21      True
      192.168.0.24      True


#### Test-TheInternet 
Tests the path to the interenet from the local host outwards.  The idea behind this was to help the normal user "ping" the gateway.  

	Checking for an Authentication Server
	Authentication Server  : Not Available           
	Finding the Web facing IP Address
	External IP            : 70.171.18.19           
	Testing Loopback connection:
	127.0.0.1              : Passed                  
	Testing IPAddress:
	192.168.0.98           : Passed                  
	Testing DefaultIPGateway:
	192.168.0.1            : Passed                  
	Testing DNSServerSearchOrder:
	9.9.9.9                : Passed                  
	8.8.8.8                : Passed                  
	Testing DHCPServer:
	192.168.0.1            : Passed                  
	Testing ExternalIp:
	70.171.18.19          : Passed        


## Road Map 
Although not entirely clear, we have a vision for a IPv4 centric toolbox and it may be complete, now.  But, we know that there is some room for improvement.  Simple items like, cleaning up the code and minimizing possible errors.
 

## Install / Setup
1. Find your local PSModule paths.  `$env:PSModulePath.Split(';')` 
1. Download the [latest release zip file](https://github.com/KnarrStudio/ITPS.OMCS.IPv4ToolSet/releases)
1. Unzip the files and save the module to the module path as Module\Version in your profile `$env:USERPROFILE`. _See example below_    
1. Naveigate to that folder in powershell and run `Get-ChildItem -Recurse | Unblock-File` 
1. At this point it is ready to use anytime
1. Run `Import-Module ITPS.OMCS.IPv4ToolSet`

*Path example of version 1.1.2.17* 
```
E:\Users\UserName\Documents\PowerShell\Modules\ITPS.OMCS.IPv4ToolSet\1.1.2.17 
```

## Troubleshooting

#### Path is not correct  
Check to ensure the files are located under the _Version Number_.  
```
Get-ChildItem 'C:\Users\UserName\Documents\PowerShell\Modules\ITPS.OMCS.IPv4ToolSet\1.1.2.17'

    Directory: C:\Users\erika\Documents\PowerShell\Modules\ITPS.OMCS.IPv4ToolSet\1.1.2.17

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----           11/9/2022    21:02                .github
d----           11/9/2022    21:02                Modules
d----           11/9/2022    21:02                Scripts
d----           11/9/2022    21:02                Tester
-a---           11/6/2022    12:55           9342 ITPS.OMCS.IPv4ToolSet.psd1
-a---          10/11/2022    21:45           1089 LICENSE
-a---          10/29/2022    10:54            126 loader.psm1
-a---          10/29/2022    13:15            557 Publish-Install.ps1
-a---           11/6/2022    12:35           4164 README.md
-a---           11/6/2022    12:55           2011 Update-ManifestModule.ps1
```

#### Files blocked 
`Get-ChildItem 'E:\Users\UserName\Documents\PowerShell\Modules\ITPS.OMCS.IPv4ToolSet' -Recurse | Unblock-File`


