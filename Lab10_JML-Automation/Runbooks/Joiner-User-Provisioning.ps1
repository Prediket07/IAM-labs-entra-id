param(
    [Parameter(Mandatory=$true)]
    [string]$FirstName,

    [Parameter(Mandatory=$true)]
    [string]$LastName,

    [Parameter(Mandatory=$true)]
    [string]$Department,

    [Parameter(Mandatory=$true)]
    [string]$JobTitle
)

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Groups

Write-Output "Starting Joiner Automation"

Connect-MgGraph -Identity

$UserPrincipalName = "$FirstName.$LastName@boclairindustries.com"
$MailNickname = "$FirstName$LastName"

$newUser = New-MgUser `
    -DisplayName "$FirstName $LastName" `
    -UserPrincipalName $UserPrincipalName `
    -MailNickname $MailNickname `
    -AccountEnabled:$true `
    -Department $Department `
    -JobTitle $JobTitle `
    -PasswordProfile @{
        Password = "TempPass123!"
        ForceChangePasswordNextSignIn = $true
    }

Write-Output "User created: $UserPrincipalName"

if ($Department -eq "Sales") {

    $group = Get-MgGroup | Where-Object { $_.DisplayName -eq "GG-Sales" }

    if ($group) {
        New-MgGroupMemberByRef `
            -GroupId $group.Id `
            -BodyParameter @{
                "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($newUser.Id)"
            }

        Write-Output "User added to GG-Sales"
    }
    else {
        Write-Output "Group GG-Sales not found"
    }
}

Write-Output "Joiner automation completed successfully."
