# Load necessary assemblies
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Load XAML
[xml]$xaml = @"
<Window x:Class="MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="PowerShell Dark GUI" Height="350" Width="525" Background="#222">
    <Grid>
        <TextBlock HorizontalAlignment="Center" VerticalAlignment="Top" Margin="0,20,0,0" FontSize="24" Foreground="White">
            Dark Theme PowerShell GUI
        </TextBlock>
        
        <TextBox Name="InputBox" HorizontalAlignment="Center" VerticalAlignment="Center" Width="300" Height="30" Background="#333" Foreground="White" BorderBrush="#444" Padding="10"/>
        
        <Button Name="SubmitButton" Content="Submit" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="0,50,0,0" Width="100" Height="35" Background="#555" Foreground="White" BorderBrush="#666" Cursor="Hand"/>
    </Grid>
</Window>
"@

# Create GUI from XAML
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Handle the button click event
$submitButton = $window.FindName("SubmitButton")
$inputBox = $window.FindName("InputBox")

$submitButton.Add_Click({
    [System.Windows.MessageBox]::Show("You entered: $($inputBox.Text)", "Information", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
})

# Display the window
$window.ShowDialog() | Out-Null