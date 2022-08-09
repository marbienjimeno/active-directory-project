# Import the AD Module
Import-Module ActiveDirectory

# Default password for all new users 
$DEFAULT_PASS = "Password1234!"

# Get the path for the target CSV file
$filepath = Read-Host -Prompt "Enter path to CSV file containing New Users"

# Import users from CSV file as array
$users = Import-CSV $filepath

# For each user in the extracted from the CSV file
ForEach ($user in $users) {
    # Make first and last names all lower-cased
    $firstName = $user.'First Name'.ToLower()
    $lastName = $user.'Last Name'.ToLower()
    
    # Format username based on full name. Ex. Full Name: Marbien Jimeno -> Username: mjimeno
    $username = "$($firstName.Substring(0,1))$($lastName)"

    # Add new user to active directory
    New-ADUser `
        # Enters values of new user based on data from CSV file
        -Name ($user.'First Name' + " " + $user.'Last Name') `
        -GivenName $user.'First Name' `
        -Surname $user.'Last Name' `
        # Previously formatted username object is used
        -UserPrincipalName $username `
        # The variable holding the default password is used and encryption is performed
        -AccountPassword (ConvertTo-SecureString $DEFAULT_PASS -AsPlainText -Force) `
        -Description $user.Description `
        -EmailAddress $users.'Email Address' `
        -Title $user.'Job Title' `
        -OfficePhone $user.Phone `
        -Path $user.'Organizational Unit' `
        -Enabled ([System.Convert]::ToBoolean($user.Enabled)) `
        # The user does not have the change their password at next logon. This is normally
        # set to true but, for lab purposes, the feature is turned off
        -ChangePasswordAtLogon 1
}
