cd $HOME\Downloads
Invoke-WebRequest 'https://downloads.apache.org/logging/log4j/2.17.1/apache-log4j-2.17.1-bin.zip' -OutFile apache-log4j-2.17.1-bin.zip

$hash = Get-FileHash .\apache-log4j-2.17.1-bin.zip -Algorithm SHA512

