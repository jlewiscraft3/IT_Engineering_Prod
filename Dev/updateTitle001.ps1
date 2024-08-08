<#
.Synopsis
	Update title of all users
.Description
    Assumes AD module is installed.
    Gets list of all users in certain OU specified by parameter
    exports to a .csv
.Author
	James Lewis
#>


#Set paramaters to change what is selected

[CmdletBinding()]
Param(
    [parameter(mandatory = $false)]
    [string]$ou = "OU=Regular,OU=Users,OU=ORG,DC=ARC,DC=LOCAL",

    [parameter(mandatory = $false)]
    [string]$adTitle = @("Senior Engineer"),

    [parameter(mandatory = $false)]
    [string]$adName = @("bhop@barn.org"),

    [parameter(mandatory = $false)]
    [string]$secCreds = "$env:SystemDrive\secCred.xml"

)

#variables
#device list CSV's
$devicesCSV = "$env:SystemDrive\Temp\userList-$(Get-Date -Format yyyy-MM-dd-hh-mm).csv"
$adObjLog = "$env:SystemDrive\Temp\userLog-$(Get-Date -Format yyyy-MM-dd-hh-mm).txt"

#set script to stop on error
$ErrorActionPreference = 'stop'

#attempt to get ActiveDirectory Module
Try
{
    Import-Module -Name ActiveDirectory
}
catch
{
    Write-Host "Failed to import module " -ForegroundColor Red
    $failModule = $_
    $(Get-Date -Format yyyy-MM-dd-hh-mm)-$failModule | Out-File -FilePath $adObjLog -Append
    Write-Host $failModule
    Read-Host "Press Enter to Exit"
    Exit
}



#update Title in AD
Try
{
    Get-ADUser
    Set-ADUser -Identity $userDN -Title $newTitle
}
catch
{
    Write-Host "Failed to import module " -ForegroundColor Red
    $failModule = $_
    $(Get-Date -Format yyyy-MM-dd-hh-mm)-$failModule | Out-File -FilePath $adObjLog -Append
    Write-Host $failModule
    Read-Host "Press Enter to Exit"
    Exit
}