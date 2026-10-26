$files = @('index.html', 'about.html', 'services.html', 'projects.html', 'contact.html')
foreach ($f in $files) {
    $p = "C:\Users\user\.gemini\antigravity\scratch\ashar-portfolio\$f"
    $c = [System.IO.File]::ReadAllText($p, [System.Text.Encoding]::UTF8)
    $newC = [regex]::Replace($c, '(?<=<title>)(.*?)(?=</title>)', { param($m) $m.Value -replace '&amp;', '&' })
    [System.IO.File]::WriteAllText($p, $newC, [System.Text.Encoding]::UTF8)
}
Write-Host "Updated title tags."
