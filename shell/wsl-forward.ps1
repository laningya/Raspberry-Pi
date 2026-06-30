param (
    [Parameter(Mandatory=$false)]
    [string]$Distro,

    [Parameter(Mandatory=$false)]
    [int]$WslPort,

    [Parameter(Mandatory=$true)]
    [int]$WinPort,

    [Parameter(Mandatory=$false)]
    [switch]$Clear
)

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Error: Must run as Administrator!"
    Exit
}

$firewallRuleName = "WSL_Forward_$WinPort"

if ($Clear) {
    Write-Host "Clearing mapping for port: Windows:$WinPort ..." -ForegroundColor Yellow
    netsh interface portproxy delete v4tov4 listenport=$WinPort listenaddress=0.0.0.0 *>$null
    
    $checkFirewall = Get-NetFirewallRule -Name $firewallRuleName -ErrorAction SilentlyContinue
    if ($checkFirewall) {
        Remove-NetFirewallRule -Name $firewallRuleName *>$null
    }
    Write-Host "Success: Port $WinPort cleared!" -ForegroundColor Green
    Exit
}

if (-not $Distro -or -not $WslPort) {
    Write-Error "Error: Missing -Distro or -WslPort parameters!"
    Exit
}

$checkDistro = (wsl -l -q) -contains $Distro
if (-not $checkDistro) {
    Write-Error "Error: Cannot find distro '$Distro'."
    Exit
}

Write-Host "Getting IP for [$Distro] ..." -ForegroundColor Cyan
$wsl_ip = (wsl -d $Distro ip a s eth0 | Select-String -Pattern "inet\s(.*)\/").Matches.Groups[1].Value

if (-not $wsl_ip) {
    Write-Error "Error: Failed to get WSL IP. Ensure it is running."
    Exit
}

Write-Host "Found IP: $wsl_ip" -ForegroundColor Green
Write-Host "Mapping: Windows:${WinPort} -> ${Distro}:${WslPort} ..." -ForegroundColor Yellow

netsh interface portproxy delete v4tov4 listenport=$WinPort listenaddress=0.0.0.0 *>$null
netsh interface portproxy add v4tov4 listenport=$WinPort listenaddress=0.0.0.0 connectport=$WslPort connectaddress=$wsl_ip

$checkFirewall = Get-NetFirewallRule -Name $firewallRuleName -ErrorAction SilentlyContinue
if ($checkFirewall) {
    Remove-NetFirewallRule -Name $firewallRuleName *>$null
}

New-NetFirewallRule -Name $firewallRuleName `
                    -DisplayName "WSL Forward Port $WinPort" `
                    -Direction Inbound `
                    -Action Allow `
                    -Protocol TCP `
                    -LocalPort $WinPort *>$null

Write-Host "Success! Firewall opened and port mapped." -ForegroundColor Green
