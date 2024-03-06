function WriteLog {
    param(
        [string]$Path = "./log.txt",
        [string]$Message 
    )

    $date = Get-Date
    Write-Output "$date - $message" >> $Path 
}
