param (
    [Parameter(Mandatory=$true)]
    [string]$SearchStr
)

$OutputFile = "found_files.txt"

$results = Get-ChildItem -Recurse -Filter "*.txt" | 
           Select-String -Pattern $SearchStr | 
           Select-Object -Unique Path

if ($results) {
    $results.Path | Out-File -FilePath $OutputFile -Encoding utf8
    Write-Host "Done. Check $OutputFile"
} else {
    Write-Host "No matches found."
}