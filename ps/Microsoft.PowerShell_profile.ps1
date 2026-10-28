# --- PSReadLine & Vi Mode ---
# Force load to ensure we have the latest features
Import-Module PSReadLine -Force

Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Cursor
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None

# --- Key Bindings ---
# Tab completion
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# History search (matches typed prefix)
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# fzf integration
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    Set-PSReadLineKeyHandler -Chord 'Ctrl+t' -ScriptBlock {
        $file = fzf
        if ($file) { [Microsoft.PowerShell.PSConsoleReadLine]::Insert($file) }
    }
}

# --- Common Functions & Aliases ---
function c { code @args }
function n { notepad++ @args }
function profile { code $PROFILE }
function touch { New-Item -ItemType File -Name $args }
function which { Get-Command $args | Select-Object -ExpandProperty Definition }
function gcam { git add .; git commit -m "$args" }
function dls { docker ps --format "table {{.Names}}\t{{.Status}}\t{{.State}}" }
function .. { cd .. }
function ... { cd ../.. }
function w { . $PROFILE; Write-Host "Profile reloaded!" -ForegroundColor Cyan }
Set-Alias -Name reload -Value w
function q { exit }

# --- External Tools ---
# Zoxide (Smart cd)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# Starship (Prompt)
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# --- Startup Message ---
Write-Host "PowerShell 7 Ready! Vi mode enabled (Esc: Normal, i: Insert)" -ForegroundColor Green