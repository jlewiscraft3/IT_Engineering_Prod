<#
.Synopsis
	Get List of all users
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
    [string]$ou = "OU=Regular,OU=Users,OU=ORG,DC=SEP,DC=LOCAL",

    [parameter(mandatory = $false)]
    [string[]]$adProperties = @("Name", "UserPrincipalName", "DistinguishedName", "HomePhone", "OfficePhone")

)

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

#variables
#device list CSV's
$devicesCSV = "$env:SystemDrive\Temp\userList-$(Get-Date -Format yyyy-MM-dd-hh-mm).csv"
$adObjLog = "$env:SystemDrive\Temp\userLog-$(Get-Date -Format yyyy-MM-dd-hh-mm).txt"

#attempt to get list of devices
Try
{
Write-Host "Attempting to get users in $ou. " -ForegroundColor Green
Write-Output $(Get-Date -Format yyyy-MM-dd-hh-mm) "Attempting to get users in $ou" | Out-File -FilePath $adObjLog -Append
$users = Get-ADUser -Filter * -SearchBase $ou -Properties $adProperties


#output log to C:\temp
$users | Select-Object $adProperties | Export-CSV -Path $devicesCSV -NoTypeInformation -Append
Write-Output $(Get-Date -Format yyyy-MM-dd-hh-mm) "All users added from $ou" | Out-File -FilePath $adObjLog -Append
}

catch
{
    Write-Host "Failed to get list of users" -ForegroundColor Red
    $failUserList = $_
    $(Get-Date -Format yyyy-MM-dd-hh-mm)-$failUserList | Out-File -FilePath $adObjLog -Append
    Write-Host $failUserList
    Read-Host "Press Enter to Exit"
    Exit
}

Write-Host "List Complete"
Write-Output $(Get-Date -Format yyyy-MM-dd-hh-mm) "List Complete" | Out-File -FilePath $adObjLog -Append
Read-Host -Prompt "Press Enter to Exit"
Exit