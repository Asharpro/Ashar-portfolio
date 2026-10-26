Add-Type -AssemblyName System.IO.Compression.FileSystem
$docxPath = 'C:\Users\user\.gemini\antigravity\brain\b6166098-132f-4a64-83a1-849505400a80\.user_uploaded\media_1792982249607_ab9f336e.docx'
$zip = [System.IO.Compression.ZipFile]::OpenRead($docxPath)
$entry = $zip.GetEntry('word/document.xml')
$stream = $entry.Open()
$reader = New-Object System.IO.StreamReader($stream)
$xml = $reader.ReadToEnd()
$reader.Close()
$stream.Close()
$zip.Dispose()

[xml]$doc = $xml
$ns = New-Object System.Xml.XmlNamespaceManager($doc.NameTable)
$ns.AddNamespace('w', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main')
$paras = $doc.SelectNodes('//w:p', $ns)

$lines = [System.Collections.Generic.List[string]]::new()
foreach ($p in $paras) {
    $texts = $p.SelectNodes('.//w:t', $ns) | ForEach-Object { $_.InnerText }
    $line = -join $texts
    if ($line.Trim().Length -gt 0) {
        $lines.Add($line.Trim())
    }
}

$outPath = 'C:\Users\user\.gemini\antigravity\scratch\docx_text.txt'
[System.IO.File]::WriteAllLines($outPath, $lines, [System.Text.Encoding]::UTF8)
Write-Host "Extracted $($lines.Count) lines to $outPath"
