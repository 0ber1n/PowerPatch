# This function automatically installs KB5044288 which is the patch taking care of CVE-2024-38029
function CVE-2024-38029 {
    
    # This checks to see if the patch is installed. If not installed, it returns a listing for the patch
    $patch_status = Get-WUList -ComputerName "$IP" | Where-Object { $_.KB -eq "KB5044288"}

    # If the pre-check returns a listing, it sets this to true and installs the patch
    Write-Host "`nChecking to see if the script is installed...`n"
    if ($patch_status) {
        Write-Host "KB5044288 is NOT installed on $IP"
        Write-Host "Beginning installation." -ForegroundColor Yellow
        #Install-WindowsUpdate -ComputerName "$IP" -KBArticleID "KB5044288" -AcceptAll -AutoReboot -verbose
        Write-Host "`n"
        } 
    # If the pre-check returns a blank, then the patch is already installed on the system or not applicable to this machine.
    else {
        Write-Host "The package for CVE-2024-38029 (KB5044288) is either already installed on $IP or not applicable" -ForegroundColor Green
        }
     
}

# This function allows the option to search and select all available patches. To be used if wanting to tackle anything other than CVE-2024-38029
function custom_KB {
    Write-Host "`nSearching for available patches"
    # Get-WUList compares available patches from Microsoft to whats installe and outputs those that havent been installed yet. Will take IP input in main script
    Get-WUList -ComputerName "$IP"

    $select_KB = Read-Host "`nEnter KB for desired patch application (ex. KB5048163)"
    $patch_status = Get-WUList -ComputerName "$IP" | Where-Object { $_.KB -eq "$KB"}

    if ($patch_status) {
        Write-Host "$select_KB is NOT installed"
        Write-Host "Beginning installation" -ForegroundColor Yellow
        Install-WindowsUpdate -ComputerName "$IP" -KBArticleID "$select_KB" -AcceptAll -AutoReboot -verbose
        } 
    else {
        Write-Host "$select_KB is already installed or not applicable" -ForegroundColor Green
        }
     
}

# PSWindowsUpdate is a requirement for this script to work. 
function Dependency_Modules{
    Write-Host "Installing Module..."
    Install-Module -Name PSWindowsUpdate -Force
    Write-Host "Importing Module into PowerShell"
    Import-Module PSWindowsUpdate
}

function Show-Menu {
    Write-Host "**********************************"
    Write-Host "* Welcome to our patch Installer *"
    Write-Host "**********************************"
    Write-Host "*Warning- Server will reboot after any installation selection*`n"
    Write-Host "1) Patch CVE-2024-38029"
    Write-Host "2) Custom Patching"
    Write-Host "3) Install PSWindowsUpdate Module (local install only)"
    Write-Host "4) Exit"
    Write-Host "`n"
}

# Created the menu and choice option as functions to keep the code cleaner when running a loop.
function Get-UserChoice {
    param ([string]$Prompt = "Enter your choice (1-4)")
    return Read-Host $Prompt
    }

##############################################
# This is the beginning of the main program  #
##############################################

Show-Menu

# Setting this condition to true which will allow things like exit to close out the script completely
$continueloop = $true
do {
    $options = Get-UserChoice
    
    # Adding input validation to eliminate white space which could break the script
    $options = $options.Trim()

    # Adding switch statements to make the choice from the menu cleaner than several if-else statements
    if ($options -in@("1", "2", "3", "4")){
        switch ($options){
            "1"{
                $IP = Read-Host "Enter the IP of machine to be patched or localhost for local patch"
                CVE-2024-38029
                pause
                $continueloop = $false
                }
            "2"{
                $IP = Read-Host "Enter the IP of machine to be patched or localhost for local patch"
                Write-Host "`nExecuting custom KB install...`n"
                custom_KB
                pause
                }
            "3"{
                Dependency_Modules
                Write-Host "PSWindowsUpdate installation is complete`n" -ForegroundColor Green
                }
            "4"{
                Write-Host "Thanks for stopping by, See you later!`n"
                $continueloop = $false
                }
            }
        }
    else {
        Write-Host "`nPlease enter a valid option`n" -ForegroundColor Red
        
        }
} while ($continueloop)
