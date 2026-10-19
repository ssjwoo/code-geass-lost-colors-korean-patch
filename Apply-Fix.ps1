[CmdletBinding()]
param([string]$SourcePath, [string]$OutputDirectory)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$taskTemp = $null
function Assert-File([string]$Path, $Expected, [string]$Label) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "$Label 파일이 없습니다: $Path" }
    if ((Get-Item -LiteralPath $Path).Length -ne [long]$Expected.bytes) { throw "$Label 파일 크기가 다릅니다. 지원하는 원본과 파일을 확인하세요." }
    $taskHasher = [System.Security.Cryptography.SHA256]::Create()
    $taskStream = [System.IO.File]::OpenRead($Path)
    try { $taskHash = [System.BitConverter]::ToString($taskHasher.ComputeHash($taskStream)).Replace('-', '').ToLowerInvariant() }
    finally { $taskStream.Dispose(); $taskHasher.Dispose() }
    if ($taskHash -ne $Expected.sha256) { throw "$Label SHA256이 다릅니다. 파일을 다시 확인하세요." }
}
try {
    $taskManifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    if ([string]::IsNullOrWhiteSpace($SourcePath)) {
        Add-Type -AssemblyName System.Windows.Forms
        $taskPicker = New-Object System.Windows.Forms.OpenFileDialog
        $taskPicker.Title = '일본판 1.01 원본 ISO를 선택하세요'
        $taskPicker.Filter = 'ISO files (*.iso)|*.iso|All files (*.*)|*.*'
        try {
            if ($taskPicker.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { throw '파일 선택을 취소했습니다.' }
            $SourcePath = $taskPicker.FileName
        } finally { $taskPicker.Dispose() }
    }
    $SourcePath = (Resolve-Path -LiteralPath $SourcePath).ProviderPath
    $taskPatch = Join-Path $PSScriptRoot $taskManifest.patch.name
    $taskDecoder = Join-Path $PSScriptRoot $taskManifest.decoder.name
    Write-Output '일본판 1.01 원본·패치·적용 도구를 확인합니다...'
    Assert-File $SourcePath $taskManifest.source '원본 ISO'
    Assert-File $taskPatch $taskManifest.patch 'xdelta 패치'
    Assert-File $taskDecoder $taskManifest.decoder '적용 도구'
    if ([string]::IsNullOrWhiteSpace($OutputDirectory)) { $OutputDirectory = Join-Path $PSScriptRoot 'output' }
    $OutputDirectory = [System.IO.Path]::GetFullPath($OutputDirectory)
    $taskTarget = Join-Path $OutputDirectory $taskManifest.target.name
    if (Test-Path -LiteralPath $taskTarget) {
        Assert-File $taskTarget $taskManifest.target '기존 결과 ISO'
        Write-Output "검증된 결과가 이미 있습니다: $taskTarget"
        exit 0
    }
    [System.IO.Directory]::CreateDirectory($OutputDirectory) | Out-Null
    $taskTemp = Join-Path $OutputDirectory ('FontFix2_' + [Guid]::NewGuid().ToString('N') + '.partial')
    Write-Output 'FontFix2 ISO를 새 파일로 생성합니다...'
    & $taskDecoder -a -d -s $SourcePath $taskPatch $taskTemp
    if ($LASTEXITCODE -ne 0) { throw "xdelta 적용 실패: 종료 코드 $LASTEXITCODE" }
    Assert-File $taskTemp $taskManifest.target '생성한 ISO'
    [System.IO.File]::Move($taskTemp, $taskTarget)
    $taskTemp = $null
    Write-Output "완료: $taskTarget"
    Write-Output 'SHA256 확인 완료. 결과 ISO를 PSP 메모리카드의 ISO 폴더로 복사하세요.'
    exit 0
} catch {
    Write-Host ('오류: ' + $_.Exception.Message) -ForegroundColor Red
    exit 1
} finally {
    if ($taskTemp -and (Test-Path -LiteralPath $taskTemp -PathType Leaf)) { Remove-Item -LiteralPath $taskTemp }
}
