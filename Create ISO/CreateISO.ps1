# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms

# Create new form
$ISOConverter                    = New-Object system.Windows.Forms.Form
# Define the size, title and background color
$ISOConverter.ClientSize         = '350,200'
$ISOConverter.text               = "Folder to ISO"
$ISOConverter.BackColor          = "#ededed"
$ISOConverter.FormBorderStyle    = 'FixedDialog'
$ISOConverter.MaximizeBox        = $false
$ISOConverter.startposition    = "centerscreen"

# Display the button to select a folder
$FolderSelectBtn                   = New-Object system.Windows.Forms.Button
$FolderSelectBtn.BackColor         = "#03b1fc"
$FolderSelectBtn.text              = "Select Folder"
$FolderSelectBtn.width             = 120
$FolderSelectBtn.height            = 50
$FolderSelectBtn.location          = New-Object System.Drawing.Point(25,25)
$FolderSelectBtn.Font              = 'Microsoft Sans Serif,10'
$FolderSelectBtn.ForeColor         = "#000000"
$FolderSelectBtn.Visible           = $true

# Button to Create ISO
$CreateIsoBtn                   = New-Object system.Windows.Forms.Button
$CreateIsoBtn.BackColor         = "#03b1fc"
$CreateIsoBtn.text              = "Create"
$CreateIsoBtn.width             = 120
$CreateIsoBtn.height            = 50
$CreateIsoBtn.location          = New-Object System.Drawing.Point(25,100)
$CreateIsoBtn.Font              = 'Microsoft Sans Serif,10'
$CreateIsoBtn.ForeColor         = "#000000"
$CreateIsoBtn.Visible           = $true

$ISOConverter.controls.AddRange(@($FolderSelectBtn, $CreateIsoBtn))


$FolderSelectBtn.Add_Click({ SelectFolder })

# required functions
function SelectFolder { 
Add-Type -AssemblyName System.Windows.Forms
$ofd=New-Object System.Windows.Forms.OpenFileDialog
$ofd.InitialDirectory = "\\$env:Computername\c$\Windows"
$ofd.ShowDialog()
}

# Display the form
[void]$ISOConverter.ShowDialog()
