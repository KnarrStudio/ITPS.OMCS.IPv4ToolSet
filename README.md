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
To Briansworth, where the module was forked from. Many of the tools were written by him.  Some of his tools made the others more efficient and streamlined. The heavy lifting, the dependent functions are loaded with the _ITPS.OMCS.IPv4LinkedLibrary_ module.   

#### Reason for the fork
I wanted to expand on what I saw as a toolbox and felt that the direction was moving away from what was a specific set of tools.  Afterall the `Ping-IpRange` is helpful, but not really a Subnet item.


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


# Road Map 
Although not entirely clear, I have a vision for a IPv4 centric toolbox and it may be complete, now.  But, I still see that there is some room for improvement, such as cleaning up the code and minimizing possible errors.
 