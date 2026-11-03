# Builds main.js inside a Node 16 container, using the exact package versions
# in package-lock.json. Node 16 / npm 8 is the toolchain that produced the
# lock file; with it, building tag 3.0.1 reproduces the released main.js
# byte for byte.
#
# node_modules lives in the Docker volume "waypoint_node_modules", not in this
# folder. --ignore-scripts stops packages from running install scripts.
#
# Usage: .\build.ps1   (requires Docker Desktop)

$ErrorActionPreference = "Stop"

docker run --rm `
	-v "${PSScriptRoot}:/src" `
	-v waypoint_node_modules:/src/node_modules `
	-w /src `
	node:16-slim `
	sh -c 'npm ci --ignore-scripts && npm run build'

if ($LASTEXITCODE -ne 0) {
	exit $LASTEXITCODE
}

"main.js SHA256: " + (Get-FileHash (Join-Path $PSScriptRoot "main.js") -Algorithm SHA256).Hash
