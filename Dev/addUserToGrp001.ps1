<#
.Synopsis
	Add users to a distribution list or Security Group
.Description
    Assumes AD module is installed.
    Add users to list
    writes output to log
.Author
	James Lewis
#>


#Set paramaters to change what is selected

[CmdletBinding()]
Param(
    [parameter(mandatory = $false)]
    [string]$ou = "OU=Regular,OU=Users,OU=ORG,DC=ARC,DC=LOCAL",

    [parameter(mandatory = $false)]
    [string]$adGrpName = @("QbackupGRP"),

    [parameter(mandatory = $false)]
    [string[]]$adUser = @("bhop@barn.org", "bhop2@barn.org"),

    [parameter(mandatory = $false)]
    [string]$secCreds = "$env:SystemDrive\secCred.xml"

)

#variables
#device list CSV's
$userCSV = "$env:SystemDrive\Temp\userList-$(Get-Date -Format yyyy-MM-dd-hh-mm).csv"
$adObjLog = "$env:SystemDrive\Temp\userGrpAddLog-$(Get-Date -Format yyyy-MM-dd-hh-mm).txt"

#set script to stop on error
$ErrorActionPreference = 'stop'

#attempt to get ActiveDirectory Module
Try
{
    Import-Module -Name ActiveDirectory
}
catch
{
    Write-Verbose "Failed to import module " -ForegroundColor Red
    $failModule = $_
    Write-Output $(Get-Date -Format yyyy-MM-dd-hh-mm)-$failModule | Out-File -FilePath $adObjLog -Append
    Write-Verbose $failModule
    Read-Host "Press Enter to Exit"
    Exit
}



#update Title in AD
Try
{
    Get-ADGroup $adName
    foreach ($adName in $adNames) {
    Set-ADUser -Identity $adName -Title $adTitle
    }
}
catch
{
    Write-Verbose "Failed to update group membership " -ForegroundColor Red
    $failTitle = $_
    Write-Output $(Get-Date -Format yyyy-MM-dd-hh-mm)-$failTitle | Out-File -FilePath $adObjLog -Append
    Write-Verbose $failTitle
    Read-Host "Press Enter to Exit"
    Exit
}