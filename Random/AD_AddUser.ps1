# Define the username of the user to add
$username = "DOMAIN\USERNAME"

# Add the user to the local administrators group
net localgroup Administrators $username /add
