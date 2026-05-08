
$logFileName = "Log_PaddingFormatNum_" + $(Get-Date -Format "yyyyMMddHHmmss") + ".txt"
$logFile = $PSScriptRoot + "\" + $logFileName

function main {

    if ((Test-Path $logFile) -eq $false) {
        New-Item -Path ($logFile) | Out-Null
    }
    else {
        Write-Warning "ログファイルが存在しています。処理を中断します。"
        exit
    }
    
    OutputLog "ExecStart: $((Get-Date -Format "yyyy/MM/dd HH:mm:ss").ToString())"

    $files = Get-ChildItem -File -Path $PSScriptRoot | Where-Object { $_.BaseName -match '^\d+$' }

    $digits = ($files | Sort-Object { $_.BaseName.Length } -Descending | Select-Object -First 1).BaseName.Length
    
    ForEach ($f in $files) {
        $oldName = $f.Name
        $newName = ("{0:D$($digits)}" -f [int]$f.BaseName) + $f.Extension
        Rename-Item -Path $f -NewName $newName
        OutputLog " Success:: $($oldName) -> $($newName)" 
    }

    OutputLog "ExecEnd: $((Get-Date -Format "yyyy/MM/dd HH:mm:ss").ToString())"
}

function OutputLog {
    param([Parameter(ValueFromPipeline = $true)] [string]$InputText)
    begin {
        $outTxt = ""
    }
    process {
        $outTxt += $InputText
    }
    end {
        Write-Output $outTxt | Tee-Object -FilePath $logFile -Append
    }
}

main