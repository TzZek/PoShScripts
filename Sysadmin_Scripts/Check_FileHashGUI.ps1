Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to calculate file hash based on selected algorithm
function Get-FileHashCustom {
    param ([string]$filePath, [string]$algorithm)
    
    $hasher = [System.Security.Cryptography.HashAlgorithm]::Create($algorithm)
    $fileStream = [System.IO.File]::OpenRead($filePath)
    $hash = [System.BitConverter]::ToString($hasher.ComputeHash($fileStream)).Replace("-", "")
    $fileStream.Close()
    return $hash
}

# Variable to hold the selected file path
$script:path = $null

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Drag and Drop File with Hash Check'
$form.Size = New-Object System.Drawing.Size(500,200)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48) # Dark Gray Background

# Label for instructions
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(480,20)
$label.Text = 'Drag and drop a file onto this window, then enter the hash you want to check.'
$label.ForeColor = [System.Drawing.Color]::WhiteSmoke # Light text color
$form.Controls.Add($label)

# ComboBox for Hash Algorithm Selection
$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(10,40)
$comboBox.Size = New-Object System.Drawing.Size(200,20)
$comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$comboBox.Items.AddRange(@("MD5", "SHA1", "SHA256", "SHA512"))
$comboBox.SelectedIndex = 0
$comboBox.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30) # Darker Gray for ComboBox
$comboBox.ForeColor = [System.Drawing.Color]::WhiteSmoke # Light text color
$form.Controls.Add($comboBox)

# Label for File Name
$fileNameLabel = New-Object System.Windows.Forms.Label
$fileNameLabel.Location = New-Object System.Drawing.Point(10,70)
$fileNameLabel.Size = New-Object System.Drawing.Size(480,20)
$fileNameLabel.Text = 'No file selected'
$fileNameLabel.ForeColor = [System.Drawing.Color]::WhiteSmoke # Light text color
$form.Controls.Add($fileNameLabel)

# TextBox for Hash Input
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,100)
$textBox.Size = New-Object System.Drawing.Size(350,20)
$textBox.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30) # Darker Gray for TextBox
$textBox.ForeColor = [System.Drawing.Color]::WhiteSmoke # Light text color
$form.Controls.Add($textBox)

# Button to Check Hash
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(370,100)
$button.Size = New-Object System.Drawing.Size(100,20)
$button.Text = 'Check Hash'
$button.BackColor = [System.Drawing.Color]::FromArgb(104, 33, 122) # A darker shade for Button
$button.ForeColor = [System.Drawing.Color]::WhiteSmoke # Light text color
$form.Controls.Add($button)

# Label for Result
$resultLabel = New-Object System.Windows.Forms.Label
$resultLabel.Location = New-Object System.Drawing.Point(10,130)
$resultLabel.Size = New-Object System.Drawing.Size(480,20)
$resultLabel.ForeColor = [System.Drawing.Color]::WhiteSmoke # Light text color
$form.Controls.Add($resultLabel)

# Function to handle file drop
$form.AllowDrop = $true
$form.Add_DragEnter({
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        $_.Effect = [Windows.Forms.DragDropEffects]::Copy
    }
})

$form.Add_DragDrop({
    $files = $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    if ($files.Length -eq 1) {
        $script:path = $files[0]
        $fileNameLabel.Text = "Selected file: " + [System.IO.Path]::GetFileName($script:path)
    } else {
        $resultLabel.Text = 'Please drop only one file.'
    }
})

# Function to handle the button click
$button.Add_Click({
    if (!$script:path) {
        $resultLabel.Text = 'No file has been selected.'
        return
    }
    $inputHash = $textBox.Text.ToUpper()
    if (!$inputHash) {
        $resultLabel.Text = 'Please input a hash value.'
        return
    }
    
    $algorithm = $comboBox.SelectedItem
    $computedHash = Get-FileHashCustom -filePath $script:path -algorithm $algorithm
    if ($inputHash -eq $computedHash) {
        $resultLabel.Text = 'Hash match successful.'
    } else {
        $resultLabel.Text = 'Hash does not match.'
    }
})

# Show the form
$form.ShowDialog()