# Add necessary .NET assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Printers on Server"
$form.Size = New-Object System.Drawing.Size(400,400)
$form.StartPosition = "CenterScreen"

# Label for entering server name
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(100,20)
$label.Text = "Server Name:"
$form.Controls.Add($label)

# Textbox for server name input
$textBoxServer = New-Object System.Windows.Forms.TextBox
$textBoxServer.Location = New-Object System.Drawing.Point(120,10)
$textBoxServer.Size = New-Object System.Drawing.Size(250,20)
$form.Controls.Add($textBoxServer)

# Button to fetch printer list
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10,40)
$button.Size = New-Object System.Drawing.Size(100,30)
$button.Text = "Get Printers"
$button.Add_Click({
    $listBoxPrinters.Items.Clear()
    $printers = Get-Printer -ComputerName $textBoxServer.Text
    $printers | ForEach-Object {
        $listBoxPrinters.Items.Add($_.Name)
    }
})
$form.Controls.Add($button)

# Listbox to display printers
$listBoxPrinters = New-Object System.Windows.Forms.ListBox
$listBoxPrinters.Location = New-Object System.Drawing.Point(10,80)
$listBoxPrinters.Size = New-Object System.Drawing.Size(360,280)
$form.Controls.Add($listBoxPrinters)

# Show the form
$form.ShowDialog()