function Test-GitInstalled {
    $gitPath = Get-Command git -ErrorAction SilentlyContinue
    return $gitPath -ne $null
}

function Install-Git {
    # Check if Git is installed on Windows by looking for an environment variable
    if (![System.Environment]::GetEnvironmentVariable("GIT_HOME", "User") -and ![System.Environment]::GetEnvironmentVariable("GIT_HOME", "Machine")) {
        # Download the official Git for Windows installer
        $url = "https://github.com/git-for-windows/git/releases/download/v2.33.1.windows.1/Git-2.33.1-64-bit.exe"
        $installerPath = "$env:TEMP\GitInstaller.exe"
        Invoke-WebRequest -Uri $url -OutFile $installerPath

        # Install Git using the downloaded installer
        $silentArgs = '/SILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,assoc,ext\reg\shellhere,assoc_sh'
        Start-Process -FilePath $installerPath -ArgumentList $silentArgs -Wait

        # Remove the installer after installation
        Remove-Item $installerPath -Force
    }
}

# Check if Git is installed
if (!(Test-GitInstalled)) {
    Write-Host "Git is not installed. Installing Git..."
    Install-Git
    Write-Host "Git has been installed successfully."
} else {
    Write-Host "Git is already installed."
}
