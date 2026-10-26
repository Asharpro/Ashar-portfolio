$projectDir = "C:\Users\user\.gemini\antigravity\scratch\ashar-portfolio"
$htmlFiles = @("index.html", "about.html", "services.html", "projects.html", "contact.html")

Write-Host "=========================================="
Write-Host "   FULL PORTFOLIO VALIDATION SUITE        "
Write-Host "=========================================="

$overallSuccess = $true

foreach ($file in $htmlFiles) {
    $filePath = Join-Path $projectDir $file
    Write-Host "`nTesting $file..." -ForegroundColor Cyan
    
    if (-not (Test-Path $filePath)) {
        Write-Host "  FAIL: File not found: $filePath" -ForegroundColor Red
        $overallSuccess = $false
        continue
    }

    $content = Get-Content -Path $filePath -Raw -Encoding utf8

    # 1. Check title tag
    if ($content -match '<title>(.*?)</title>') {
        $title = $matches[1]
        Write-Host "  [OK] Title ($($title.Length) chars): $title" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing title tag" -ForegroundColor Red
        $overallSuccess = $false
    }

    # 2. Check meta description
    if ($content -match '<meta\s+name=["'']description["'']\s+content=["''](.*?)["'']') {
        $metaDesc = $matches[1]
        Write-Host "  [OK] Meta Description ($($metaDesc.Length) chars)" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing meta description" -ForegroundColor Red
        $overallSuccess = $false
    }

    # 3. Check Canonical Tag
    if ($content -match '<link\s+rel=["'']canonical["'']\s+href=["''](.*?)["'']') {
        $canonical = $matches[1]
        Write-Host "  [OK] Canonical: $canonical" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing canonical tag" -ForegroundColor Red
        $overallSuccess = $false
    }

    # 4. Check Open Graph & Twitter Cards
    $hasOgTitle = $content -match 'property=["'']og:title["'']'
    $hasOgImage = $content -match 'property=["'']og:image["'']'
    $hasTwitter = $content -match 'name=["'']twitter:card["'']'
    if ($hasOgTitle -and $hasOgImage -and $hasTwitter) {
        Write-Host "  [OK] Open Graph & Twitter Metadata" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing OG/Twitter metadata (Title: $hasOgTitle, Image: $hasOgImage, Twitter: $hasTwitter)" -ForegroundColor Red
        $overallSuccess = $false
    }

    # 5. Check JSON-LD
    $jsonMatches = [regex]::Matches($content, '<script\s+type=["'']application/ld\+json["'']>(.*?)</script>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if ($jsonMatches.Count -gt 0) {
        foreach ($jm in $jsonMatches) {
            $rawJson = $jm.Groups[1].Value.Trim()
            try {
                $parsed = ConvertFrom-Json $rawJson
                Write-Host "  [OK] JSON-LD Schema is valid JSON" -ForegroundColor Green
            } catch {
                Write-Host "  [FAIL] Invalid JSON-LD Schema: $_" -ForegroundColor Red
                $overallSuccess = $false
            }
        }
    } else {
        Write-Host "  [WARN] No JSON-LD schema found" -ForegroundColor Yellow
    }

    # 6. Check Local Image References
    $imgMatches = [regex]::Matches($content, '<img\s+[^>]*src=["''](assets/images/[^"'']+)["'']', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $missingImages = @()
    foreach ($im in $imgMatches) {
        $imgRel = $im.Groups[1].Value
        $imgAbs = Join-Path $projectDir ($imgRel -replace '/', '\')
        if (-not (Test-Path $imgAbs)) {
            $missingImages += $imgRel
        }
    }
    if ($missingImages.Count -eq 0) {
        Write-Host "  [OK] All $($imgMatches.Count) local images exist on disk" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing images: $($missingImages -join ', ')" -ForegroundColor Red
        $overallSuccess = $false
    }

    # 7. Check for removed placeholder words (Lumina Store+, Mindz360 Hub, Apex Freight, Halcyon Store Rebuild)
    $placeholders = @("Lumina Store+", "Mindz360 Hub®", "Apex Freight+", "Halcyon Store Rebuild", "10,480 Pages Indexed", "4.9/5 across")
    $foundPlaceholders = @()
    foreach ($p in $placeholders) {
        if ($content -match [regex]::Escape($p)) {
            $foundPlaceholders += $p
        }
    }
    if ($foundPlaceholders.Count -eq 0) {
        Write-Host "  [OK] Zero placeholder projects or fake metrics found" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Found lingering placeholder tokens: $($foundPlaceholders -join ', ')" -ForegroundColor Red
        $overallSuccess = $false
    }
}

Write-Host "`nTesting assets and scripts..." -ForegroundColor Cyan
$jsFile = Join-Path $projectDir "assets\js\main.js"
if (Test-Path $jsFile) {
    Write-Host "  [OK] main.js exists" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] main.js missing" -ForegroundColor Red
    $overallSuccess = $false
}

$cssFile = Join-Path $projectDir "assets\css\style.css"
if (Test-Path $cssFile) {
    Write-Host "  [OK] style.css exists" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] style.css missing" -ForegroundColor Red
    $overallSuccess = $false
}

$sitemap = Join-Path $projectDir "sitemap.xml"
if (Test-Path $sitemap) {
    try {
        [xml]$sitemapXml = Get-Content -Path $sitemap -Raw -Encoding utf8
        Write-Host "  [OK] sitemap.xml is valid XML ($($sitemapXml.urlset.url.Count) URLs)" -ForegroundColor Green
    } catch {
        Write-Host "  [FAIL] sitemap.xml is invalid XML: $_" -ForegroundColor Red
        $overallSuccess = $false
    }
}

$robots = Join-Path $projectDir "robots.txt"
if (Test-Path $robots) {
    Write-Host "  [OK] robots.txt exists" -ForegroundColor Green
}

Write-Host "`n=========================================="
if ($overallSuccess) {
    Write-Host "   ALL TESTS PASSED SUCCESSFULLY!         " -ForegroundColor Green
} else {
    Write-Host "   SOME TESTS FAILED - REVIEW ABOVE!      " -ForegroundColor Red
}
Write-Host "=========================================="
