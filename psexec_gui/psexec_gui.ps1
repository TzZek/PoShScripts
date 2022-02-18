# GUI Application to perform operations on remote computers
# i.e. Remove Files, Run Commands, Custom Options

# Textbox (Enter the command you wish to run?)

# checkboxes (add switches like -force)
# log all commandsthat go across the network

# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms

# Create new form
$PSExec_Commander                    = New-Object system.Windows.Forms.Form
# Define the size, title and background color
$PSExec_Commander.ClientSize         = '400,400'
$PSExec_Commander.text               = "PSExec Commander"
$PSExec_Commander.BackColor          = "#ededed"
$PSExec_Commander.FormBorderStyle    = 'FixedDialog'
$PSExec_Commander.MaximizeBox        = $false
$PSExec_Commander.startposition    = "centerscreen"

# Tab Stuff TODO
$TabControl = New-Object System.Windows.Forms.TabControl

$tabPage1 = New-Object System.Windows.Forms.TabPage
$tabPage1.Name = "Tab1"
$tabPage1.Text = "Tab1"

$tabPage2 = New-Object System.Windows.Forms.TabPage
$tabPage2.Name = "Tab2"
$tabPage2.Text = "Tab2"

$TabControl.TabPages.Add($tabPage1)
$TabControl.TabPages.Add($tabPage2) 

$TabControl.SelectedIndexChanged($TabControl_SelectedIndexChanged)

$TabControl_SelectedIndexChanged
{
    ({$selectedTab = $TabControl.SelectedTab;

    [System.Windows.Forms.MessageBox]::Show($selectedTab)})
}
$PSExec_Commander.Controls.Add($TabControl)

# Display the form
[void]$PSExec_Commander.ShowDialog()
