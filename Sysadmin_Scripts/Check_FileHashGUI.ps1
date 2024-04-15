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

# Ensure $script:path is declared at the top to have script-wide scope
$script:path = $null

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Drag and Drop File with Hash Check'
$form.Size = New-Object System.Drawing.Size(500,200)
$form.StartPosition = 'CenterScreen'

# Label for instructions
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(480,20)
$label.Text = 'Drag and drop a file onto this window, then enter the hash you want to check.'
$form.Controls.Add($label)

# ComboBox for Hash Algorithm Selection
$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(10,40)
$comboBox.Size = New-Object System.Drawing.Size(200,20)
$comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$comboBox.Items.AddRange(@("MD5", "SHA1", "SHA256", "SHA512"))
$comboBox.SelectedIndex = 0
$form.Controls.Add($comboBox)

# Label for File Name
$fileNameLabel = New-Object System.Windows.Forms.Label
$fileNameLabel.Location = New-Object System.Drawing.Point(10,70)
$fileNameLabel.Size = New-Object System.Drawing.Size(480,20)
$fileNameLabel.Text = 'No file selected'
$form.Controls.Add($fileNameLabel)

# TextBox for Hash Input
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,100)
$textBox.Size = New-Object System.Drawing.Size(350,20)
$form.Controls.Add($textBox)

# Button to Check Hash
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(370,100)
$button.Size = New-Object System.Drawing.Size(100,20)
$button.Text = 'Check Hash'
$form.Controls.Add($button)

# Label for Result
$resultLabel = New-Object System.Windows.Forms.Label
$resultLabel.Location = New-Object System.Drawing.Point(10,130)
$resultLabel.Size = New-Object System.Drawing.Size(480,20)
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