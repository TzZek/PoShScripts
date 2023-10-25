# Add necessary .NET assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Printer Management"
$form.Size = New-Object System.Drawing.Size(1100,500)
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
    $dataGridViewPrinters.Rows.Clear()
    $printers = Get-Printer -ComputerName $textBoxServer.Text

    $printerData = $printers | ForEach-Object -Parallel {
        $printer = $_
        $online = "No"
        # Check if printer is reachable
        if (Test-Connection -ComputerName $printer.PrinterName -Count 1 -Quiet) {
            $online = "Yes"
        }
        return @{
            Name        = $printer.Name
            DriverName  = $printer.DriverName
            PortName    = $printer.PortName
            Location    = $printer.Location
            Shared      = $printer.Shared
            ShareName   = $printer.ShareName
            Comment     = $printer.Comment
            PrinterStatus = $printer.PrinterStatus
            Online      = $online
            JobCount    = $printer.JobCount
            Default     = $printer.Default
        }
    }

    $count = 0
    $printerData | ForEach-Object {
        $count++
        $dataGridViewPrinters.Rows.Add($count, $_.Name, $_.DriverName, $_.PortName, $_.Location, $_.Shared, $_.ShareName, $_.Comment, $_.PrinterStatus, $_.Online, $_.JobCount, $_.Default)
    }
    $printerCountLabel.Text = "Number of Printers: " + $count
})
$form.Controls.Add($button)

# DataGridView to display printers
$dataGridViewPrinters = New-Object System.Windows.Forms.DataGridView
$dataGridViewPrinters.Location = New-Object System.Drawing.Point(10,80)
$dataGridViewPrinters.Size = New-Object System.Drawing.Size(970,240)
$dataGridViewPrinters.ColumnCount = 12
$dataGridViewPrinters.Columns[0].Name = "Count"
$dataGridViewPrinters.Columns[1].Name = "Name"
$dataGridViewPrinters.Columns[2].Name = "Driver"
$dataGridViewPrinters.Columns[3].Name = "Port"
$dataGridViewPrinters.Columns[4].Name = "Location"
$dataGridViewPrinters.Columns[5].Name = "Shared"
$dataGridViewPrinters.Columns[6].Name = "Share Name"
$dataGridViewPrinters.Columns[7].Name = "Comment"
$dataGridViewPrinters.Columns[8].Name = "Status"
$dataGridViewPrinters.Columns[9].Name = "Online"
$dataGridViewPrinters.Columns[10].Name = "Job Count"
$dataGridViewPrinters.Columns[11].Name = "Default"
$dataGridViewPrinters.AutoSizeColumnsMode = "Fill"
$dataGridViewPrinters.RowHeadersVisible = $false
$form.Controls.Add($dataGridViewPrinters)

# Label to display count of printers
$printerCountLabel = New-Object System.Windows.Forms.Label
$printerCountLabel.Location = New-Object System.Drawing.Point(10,330)
$printerCountLabel.Size = New-Object System.Drawing.Size(360,20)
$printerCountLabel.Text = "Number of Printers: 0"
$form.Controls.Add($printerCountLabel)

# Components for Adding/Removing Printers (on $tabManage)
# ... [Place components related to managing printers here, and add them to $tabManage]

# For demonstration, I'll add simple components for the "Manage Printers" tab
$addPrinterLabel = New-Object System.Windows.Forms.Label
$addPrinterLabel.Location = New-Object System.Drawing.Point(10,20)
$addPrinterLabel.Size = New-Object System.Drawing.Size(150,20)
$addPrinterLabel.Text = "Printer Name to Add:"
$tabManage.Controls.Add($addPrinterLabel)

$addPrinterTextBox = New-Object System.Windows.Forms.TextBox
$addPrinterTextBox.Location = New-Object System.Drawing.Point(170,20)
$tabManage.Controls.Add($addPrinterTextBox)

$addPrinterButton = New-Object System.Windows.Forms.Button
$addPrinterButton.Location = New-Object System.Drawing.Point(340,20)
$addPrinterButton.Text = "Add Printer"
$addPrinterButton.Add_Click({
    # Logic to add printer (for demonstration, it's just a message box)
    [System.Windows.Forms.MessageBox]::Show("Functionality to add '$($addPrinterTextBox.Text)' not implemented in this demo.")
})
$tabManage.Controls.Add($addPrinterButton)

$removePrinterLabel = New-Object System.Windows.Forms.Label
$removePrinterLabel.Location = New-Object System.Drawing.Point(10,60)
$removePrinterLabel.Size = New-Object System.Drawing.Size(150,20)
$removePrinterLabel.Text = "Printer Name to Remove:"
$tabManage.Controls.Add($removePrinterLabel)

$removePrinterTextBox = New-Object System.Windows.Forms.TextBox
$removePrinterTextBox.Location = New-Object System.Drawing.Point(170,60)
$tabManage.Controls.Add($removePrinterTextBox)

$removePrinterButton = New-Object System.Windows.Forms.Button
$removePrinterButton.Location = New-Object System.Drawing.Point(340,60)
$removePrinterButton.Text = "Remove Printer"
$removePrinterButton.Add_Click({
    # Logic to remove printer (for demonstration, it's just a message box)
    [System.Windows.Forms.MessageBox]::Show("Functionality to remove '$($removePrinterTextBox.Text)' not implemented in this demo.")
})
$tabManage.Controls.Add($removePrinterButton)

# Show the form
$form.ShowDialog()
