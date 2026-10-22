# Live merchant catalog generator for Minecraft 1.20.1.
# The v0.7.91 whole-shelf generator is saved under backup/shop-v0.7.91-20261015.
& node (Join-Path $PSScriptRoot 'gen-shop-runtime.js')
exit $LASTEXITCODE