function Install-NetExtender{
    msiexec /q /i \\path\to\install\file\NetExtender-10.2.0.300.MSI.msi ALLUSERS=2 /norestart /L C:\NE.txt
    Start-Sleep -Seconds 15
    reg import \\path\to\install\file\netextender.reg
}

# Check if OS is 64 Bit
$64arch = $env:PROCESSOR_ARCHITECTURE


If ($64arch -eq "AMD64") {

    # Check if Sonicwall Netextender is installed
    $Path = "C:\Program Files (x86)\SonicWall\SSL-VPN\NetExtender"
    If(Test-Path $Path){

        # Check software version 
        $SWVersion = New-Object -TypeName System.Version -ArgumentList "10.2.300.1"
        $CheckSWVersion = (get-item "C:\Program Files (x86)\SonicWall\SSL-VPN\NetExtender\NEGUI.exe").versionInfo | select-object -Property FileVersionRaw -ExpandProperty FileVersionRaw

        If([System.Version]$CheckSWVersion -ge [System.Version]$SWVersion) {
            exit
        }

        elseif ([System.Version]$CheckSWVersion -eq [System.Version]$SWVersion) {
            exit
        }

        Else { 
            # uninstall old version of sonicwall and install latest version 
            $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
            $app = Get-ChildItem -Path $RegPath | Get-ItemProperty | Where-Object {$_.DisplayName -match "Sonicwall Netextender" } | Select-Object -Property DisplayName, Uninstallstring
            $uninst = $app.UninstallString
            cmd /c $uninst  /quiet /norestart
            Install-NetExtender
        }

    } 

    Else {
        # If Sonicwall isn't installed, install it
        Install-NetExtender
    }
}

# If OS is 32 bit run through same checks as above
Else {
    $SWPath = "C:\program files\Sonicwall\SSL-VPN\Netextender"
    If (Test-Path $SWPath){
        $SWVersion = New-Object -TypeName System.Version -ArgumentList "10.2.300.1"
        $CheckSWVersion = (get-item "C:\Program Files\SonicWall\SSL-VPN\NetExtender\NEGUI.exe").versionInfo | select-object -Property FileVersionRaw -ExpandProperty FileVersionRaw
        If([System.Version]$CheckSWVersion -ge [System.Version]$SWVersion) {
            exit
        }

        elseIf([System.Version]$CheckSWVersion -eq [System.Version]$SWVersion) {
            exit
        }

        Else { 
            $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
            $app = Get-ChildItem -Path $RegPath | Get-ItemProperty | Where-Object {$_.DisplayName -match "Sonicwall Netextender" } | Select-Object -Property DisplayName, Uninstallstring
            $uninst = $app.UninstallString
            cmd /c $uninst  /quiet /norestart
            Install-NetExtender
        }

    } 
}
