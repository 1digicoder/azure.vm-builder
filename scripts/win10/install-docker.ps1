# Set Execution Policy
Set-ExecutionPolicy Bypass -scope Process

# Create Docker install folder
New-Item -Type Directory -Path "$($env:ProgramFiles)\docker"

# Download and Install Docker
Write-Host "Downloading docker ..."
wget -outfile $env:TEMP\docker.zip "https://download.docker.com/win/static/edge/x86_64/docker-17.07.0-ce.zip"
Expand-Archive -Path $env:TEMP\docker.zip -DestinationPath $env:TEMP -Force
copy $env:TEMP\docker\*.exe $env:ProgramFiles\docker
Remove-Item $env:TEMP\docker.zip

# TODO: Set data drive for Containers to go to D drive

# Register and Start Service
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$($env:ProgramFiles)\docker", [EnvironmentVariableTarget]::Machine)
$env:Path = $env:Path + ";$($env:ProgramFiles)\docker"
Write-Host "Registering docker service ..."
. dockerd --register-service -H npipe:// -H 0.0.0.0:2375 -G docker

Start-Service Docker
