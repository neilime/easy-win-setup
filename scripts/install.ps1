# =====================================================================
# MIT License
# 
# Copyright (c) 2019 ESCEMI
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# =====================================================================

#specifically use the API to get the latest version (below)
$url = 'https://github.com/neilime/easy-win-setup/releases/latest/download/EasyWinSetup.exe'

$easyWinSetupVersion = $env:easyWinSetupVersion
if (![string]::IsNullOrEmpty($easyWinSetupVersion)){
  Write-Output "Downloading specific version of easyWinSetup: $easyWinSetupVersion"
  $url = "https://github.com/neilime/easy-win-setup/releases/download/$easyWinSetupVersion/EasyWinSetup.exe"
}

$tempDir = Join-Path $env:TEMP "easyWinSetup"
if (![System.IO.Directory]::Exists($tempDir)) {[void][System.IO.Directory]::CreateDirectory($tempDir)}
$file = Join-Path $tempDir "EasyWinSetup.exe"

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $file)
Start-Process -Filepath "$file"
