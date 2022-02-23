#New-IsoFile AUTHOR: Chris Wu LASTEDIT: 03/23/2016 14:46:50
# GUI Designed by Derek Kirby - 2/17/2022 

# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms

# Create new form
$ISOConverter                    = New-Object system.Windows.Forms.Form
# Define the size, title and background color
$ISOConverter.ClientSize         = '300,200'
$ISOConverter.text               = "Folder to ISO"
$ISOConverter.BackColor          = "#0f0f0f"
$ISOConverter.FormBorderStyle    = 'FixedDialog'
$ISOConverter.MaximizeBox        = $false
$ISOConverter.startposition    = "centerscreen"

# Display the button to select a folder
$FolderSelectBtn                   = New-Object system.Windows.Forms.Button
$FolderSelectBtn.BackColor         = "#171717"
$FolderSelectBtn.text              = "Select Folder"
$FolderSelectBtn.ForeColor         = '#f2f2f2'
$FolderSelectBtn.width             = 240
$FolderSelectBtn.height            = 50
$FolderSelectBtn.location          = New-Object System.Drawing.Point(25,25)
$FolderSelectBtn.Font              = 'Microsoft Sans Serif,10'
$FolderSelectBtn.ForeColor         = "#f2f2f2"
$FolderSelectBtn.Visible           = $true

# Button to Create ISO
$CreateIsoBtn                   = New-Object system.Windows.Forms.Button
$CreateIsoBtn.BackColor         = "#171717"
$CreateIsoBtn.text              = "CREATE"
$CreateIsoBtn.width             = 240
$CreateIsoBtn.height            = 50
$CreateIsoBtn.location          = New-Object System.Drawing.Point(25,100)
$CreateIsoBtn.Font              = 'Microsoft Sans Serif,10'
$CreateIsoBtn.ForeColor         = "#f2f2f2"
$CreateIsoBtn.Visible           = $true

$ISOConverter.controls.AddRange(@($FolderSelectBtn, $CreateIsoBtn))


$FolderSelectBtn.Add_Click({ SelectFolder }) 

# required functions
Function SelectFolder($initialDirectory) {
    Add-Type -AssemblyName System.Windows.Forms
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $null = $browser.ShowDialog()
    $global:UserSelectedPath = $browser.SelectedPath
    write-host("You selected the Path: "+ $UserSelectedPath)
}

$CreateIsoBtn.Add_Click({ Run-Script })


function Run-Script()
{  
 New-IsoFile $UserSelectedPath
 [System.Windows.MessageBox]::Show('ISO created. You can find it here: ' + $env:USERPROFILE + ' Click Ok to Open the Containing Folder')
 explorer.exe $env:USERPROFILE
}  

# Display the form
[void]$ISOConverter.ShowDialog()

# Function to create the ISO File
function New-IsoFile 
{  
    
  [CmdletBinding(DefaultParameterSetName='Source')]Param( 
    [parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true, ParameterSetName='Source')]$Source,  
    [parameter(Position=2)][string]$Path = "$env:USERPROFILE\$((Get-Date).ToString('yyyyMMdd-HHmmss.ffff')).iso",  
    [ValidateScript({Test-Path -LiteralPath $_ -PathType Leaf})][string]$BootFile = $null, 
    [ValidateSet('CDR','CDRW','DVDRAM','DVDPLUSR','DVDPLUSRW','DVDPLUSR_DUALLAYER','DVDDASHR','DVDDASHRW','DVDDASHR_DUALLAYER','DISK','DVDPLUSRW_DUALLAYER','BDR','BDRE')][string] $Media = 'DVDPLUSRW_DUALLAYER', 
    [string]$Title = (Get-Date).ToString("yyyyMMdd-HHmmss.ffff"),  
    [switch]$Force, 
    [parameter(ParameterSetName='Clipboard')][switch]$FromClipboard 
  ) 
  
  Begin {  
    ($cp = new-object System.CodeDom.Compiler.CompilerParameters).CompilerOptions = '/unsafe' 
    if (!('ISOFile' -as [type])) {  
      Add-Type -CompilerParameters $cp -TypeDefinition @'
public class ISOFile  
{ 
  public unsafe static void Create(string Path, object Stream, int BlockSize, int TotalBlocks)  
  {  
    int bytes = 0;  
    byte[] buf = new byte[BlockSize];  
    var ptr = (System.IntPtr)(&bytes);  
    var o = System.IO.File.OpenWrite(Path);  
    var i = Stream as System.Runtime.InteropServices.ComTypes.IStream;  
   
    if (o != null) { 
      while (TotalBlocks-- > 0) {  
        i.Read(buf, BlockSize, ptr); o.Write(buf, 0, bytes);  
      }  
      o.Flush(); o.Close();  
    } 
  } 
}  
'@  
    } 
   
    if ($BootFile) { 
      if('BDR','BDRE' -contains $Media) { Write-Warning "Bootable image doesn't seem to work with media type $Media" } 
      ($Stream = New-Object -ComObject ADODB.Stream -Property @{Type=1}).Open()  # adFileTypeBinary 
      $Stream.LoadFromFile((Get-Item -LiteralPath $BootFile).Fullname) 
      ($Boot = New-Object -ComObject IMAPI2FS.BootOptions).AssignBootImage($Stream) 
    } 
  
    $MediaType = @('UNKNOWN','CDROM','CDR','CDRW','DVDROM','DVDRAM','DVDPLUSR','DVDPLUSRW','DVDPLUSR_DUALLAYER','DVDDASHR','DVDDASHRW','DVDDASHR_DUALLAYER','DISK','DVDPLUSRW_DUALLAYER','HDDVDROM','HDDVDR','HDDVDRAM','BDROM','BDR','BDRE') 
  
    Write-Verbose -Message "Selected media type is $Media with value $($MediaType.IndexOf($Media))"
    ($Image = New-Object -com IMAPI2FS.MsftFileSystemImage -Property @{VolumeName=$Title}).ChooseImageDefaultsForMediaType($MediaType.IndexOf($Media)) 
   
    if (!($Target = New-Item -Path $Path -ItemType File -Force:$Force -ErrorAction SilentlyContinue)) { Write-Error -Message "Cannot create file $Path. Use -Force parameter to overwrite if the target file already exists."; break } 
  }  
  
  Process { 
    if($FromClipboard) { 
      if($PSVersionTable.PSVersion.Major -lt 5) { Write-Error -Message 'The -FromClipboard parameter is only supported on PowerShell v5 or higher'; break } 
      $Source = Get-Clipboard -Format FileDropList 
    } 
  
    foreach($item in $Source) { 
      if($item -isnot [System.IO.FileInfo] -and $item -isnot [System.IO.DirectoryInfo]) { 
        $item = Get-Item -LiteralPath $item
      } 
  
      if($item) { 
        Write-Verbose -Message "Adding item to the target image: $($item.FullName)"
        try { $Image.Root.AddTree($item.FullName, $true) } catch { Write-Error -Message ($_.Exception.Message.Trim() + ' Try a different media type.') } 
      } 
    } 
  } 
  
  End {  
    if ($Boot) { $Image.BootImageOptions=$Boot }  
    $Result = $Image.CreateResultImage()  
    [ISOFile]::Create($Target.FullName,$Result.ImageStream,$Result.BlockSize,$Result.TotalBlocks) 
    Write-Verbose -Message "Target image ($($Target.FullName)) has been created"
    $Target
  } 
}  