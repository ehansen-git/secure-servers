Write-Host "This script is used to make your server PCI 4.0 compliant. 
It will disable TLS 1.0 and 1.1 which may break client connections to your website. 
SMB will also be locked down to verison 3.1.1 which may not work on systems older than Server 2016.

Continue?.....
"
Pause

# Disable Multi-Protocol Unified Hello (MPUH)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\Multi-Protocol Unified Hello" -Name "Enabled" -Value 0 -Force

# Disable PCT 1.0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\PCT 1.0" -Name "Enabled" -Value 0 -Force

# Disable SSL 2.0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0" -Name "Enabled" -Value 0 -Force

# Disable SSL 3.0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0" -Name "Enabled" -Value 0 -Force

# Disable TLS 1.0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0" -Name "Enabled" -Value 0 -Force

# Disable TLS 1.1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1" -Name "Enabled" -Value 0 -Force

# Enable TLS 1.2 and TLS 1.3
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2" -Name "Enabled" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3" -Name "Enabled" -Value 1 -Force

Write-Host "Server protocols have been configured successfully."

# Disable Multi-Protocol Unified Hello (MPUH)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\Multi-Protocol Unified Hello\Client" -Name "Enabled" -Value 0 -Force

# Disable PCT 1.0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\PCT 1.0\Client" -Name "Enabled" -Value 0 -Force

# Disable SSL 2.0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client" -Name "Enabled" -Value 0 -Force

# Disable SSL 3.0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client" -Name "Enabled" -Value 0 -Force

# Disable TLS 1.0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client" -Name "Enabled" -Value 0 -Force

# Disable TLS 1.1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client" -Name "Enabled" -Value 0 -Force

# Enable TLS 1.2 and TLS 1.3
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" -Name "Enabled" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" -Name "Enabled" -Value 1 -Force

Write-Host "Client protocols have been configured successfully."

# Disable specific ciphers
$disabledCiphers = @(
    'NULL',
    'DES 56/56',
    'RC2 40/128',
    'RC2 56/128',
    'RC2 128/128',
    'RC4 40/128',
    'RC4 56/128',
    'RC4 64/128',
    'RC4 128/128'
)

foreach ($cipher in $disabledCiphers) {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\$cipher" -Name "Enabled" -Value 0 -Force
}

# Enable desired ciphers
$enabledCiphers = @(
    'Triple DES 168',
    'AES 128/128',
    'AES 256/256'
)

foreach ($cipher in $enabledCiphers) {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\$cipher" -Name "Enabled" -Value 1 -Force
}

Write-Host "Ciphers have been configured successfully."

# Disable SMBv1
Set-SmbServerConfiguration -EnableSMB1Protocol $false

# Disable SMBv2
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB2" -Value 0 -Type DWord

# Disable SMBv3
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB3" -Value 0 -Type DWord

# Enable SMBv3.1.1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB3.1.1" -Value 1 -Type DWord

Write-Host "Older versions of SMB protcol have been disabled and SMBv3.1.1 has been enabled successfully."
Write-Host "All tasks complete. Please reboot."
