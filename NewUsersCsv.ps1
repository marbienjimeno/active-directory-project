# Import the AD Module
Import-Module ActiveDirectory

# Default password for new users 
$DEFAULT_PASS = "Password1234!"

# Get the path for the target CSV file
$filepath = Read-Host -Prompt "Enter path to CSV file containing New Users"

# Import CSV data as array
$users = Import-CSV $filepath

# For each user in the CSV file
ForEach ($user in $users) {
    # Make first and last names lower-cased
    $firstName = $user.'First Name'.ToLower()
    $lastName = $user.'Last Name'.ToLower()
    
    # Formats username based on full name 
    $username = "$($firstName.Substring(0,1))$($lastName)"

    # Adds new user to active directory
    New-ADUser `
        -Name ($user.'First Name' + " " + $user.'Last Name') `
        -GivenName $user.'First Name' `
        -Surname $user.'Last Name' `
        -UserPrincipalName $username `
        -AccountPassword (ConvertTo-SecureString $DEFAULT_PASS -AsPlainText -Force) `
        -Description $user.Description `
        -EmailAddress $users.'Email Address' `
        -Title $user.'Job Title' `
        -OfficePhone $user.Phone `
        -Path $user.'Organizational Unit' `
        -Enabled ([System.Convert]::ToBoolean($user.Enabled)) `
        -ChangePasswordAtLogon 1
}