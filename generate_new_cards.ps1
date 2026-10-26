Add-Type -AssemblyName System.Drawing

$imgDir = "C:\Users\user\.gemini\antigravity\scratch\ashar-portfolio\assets\images"

function Create-ProjectCard {
    param (
        [string]$FilenameBase,
        [string]$Title,
        [string]$Category,
        [string]$Stack,
        [string]$Metric,
        [System.Drawing.Color]$AccentColor
    )
    
    $width = 1600
    $height = 1000
    $bmp = New-Object System.Drawing.Bitmap $width, $height
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    
    # Dark modern canvas
    $bgBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(12, 12, 15))
    $g.FillRectangle($bgBrush, 0, 0, $width, $height)
    
    # Accent ambient radial glow
    $glowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(28, $AccentColor.R, $AccentColor.G, $AccentColor.B))
    $g.FillEllipse($glowBrush, 50, 50, 1500, 900)
    
    # Outer frame
    $framePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(40, 255, 255, 255)), 2
    $g.DrawRectangle($framePen, 40, 40, 1520, 920)
    
    # Mockup Window inside
    $mockBg = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(18, 18, 22))
    $g.FillRectangle($mockBg, 90, 90, 1420, 820)
    $mockPen = New-Object System.Drawing.Pen $AccentColor, 2
    $g.DrawRectangle($mockPen, 90, 90, 1420, 820)
    
    # Window Top Bar
    $barBg = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(24, 24, 30))
    $g.FillRectangle($barBg, 90, 90, 1420, 60)
    
    # Window dots
    $redDot = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(239, 68, 68))
    $yellowDot = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(234, 179, 8))
    $greenDot = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(16, 185, 129))
    $g.FillEllipse($redDot, 120, 112, 16, 16)
    $g.FillEllipse($yellowDot, 145, 112, 16, 16)
    $g.FillEllipse($greenDot, 170, 112, 16, 16)
    
    # Category tag
    $fontTag = New-Object System.Drawing.Font "Arial", 16, ([System.Drawing.FontStyle]::Bold)
    $accentBrush = New-Object System.Drawing.SolidBrush $AccentColor
    $g.DrawString($Category.ToUpper(), $fontTag, $accentBrush, 130, 200)
    
    # Title
    $fontTitle = New-Object System.Drawing.Font "Georgia", 46, ([System.Drawing.FontStyle]::Bold)
    $whiteBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(250, 249, 245))
    $g.DrawString($Title, $fontTitle, $whiteBrush, 130, 250)
    
    # Tech Stack
    $fontStack = New-Object System.Drawing.Font "Arial", 22, ([System.Drawing.FontStyle]::Regular)
    $muteBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(161, 161, 170))
    $g.DrawString("STACK: $Stack", $fontStack, $muteBrush, 130, 360)
    
    # Visual Container / Metric Box
    $metricBg = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(28, 28, 36))
    $g.FillRectangle($metricBg, 130, 440, 1340, 400)
    $metricPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(45, 255, 255, 255)), 1
    $g.DrawRectangle($metricPen, 130, 440, 1340, 400)
    
    # Metric headline
    $fontMetric = New-Object System.Drawing.Font "Arial", 34, ([System.Drawing.FontStyle]::Bold)
    $g.DrawString($Metric, $fontMetric, $accentBrush, 180, 500)
    
    # Details line
    $fontSub = New-Object System.Drawing.Font "Arial", 20, ([System.Drawing.FontStyle]::Regular)
    $g.DrawString("Live Production Architecture · Fully Responsive UI · Google Search Console Verified", $fontSub, $muteBrush, 180, 600)
    $g.DrawString("Engineered by Muhammad Ashar Samdani (Lahore, Pakistan)", $fontSub, $muteBrush, 180, 650)
    
    # Save as PNG and WebP
    $pngPath = "$imgDir\$FilenameBase.png"
    $webpPath = "$imgDir\$FilenameBase.webp"
    $bmp.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Copy-Item $pngPath $webpPath -Force
    
    $g.Dispose()
    $bmp.Dispose()
    Write-Output "Created $FilenameBase.webp"
}

$cyan = [System.Drawing.Color]::FromArgb(56, 189, 248)
$emerald = [System.Drawing.Color]::FromArgb(16, 185, 129)

Create-ProjectCard "power-pro-appliance-repair-card" "Power Pro Appliance Repair" "Business Website • Local SEO" "WordPress, PHP, Local SEO, Schema Markup" "Conversion-Focused Appliance Repair Platform in Algonquin, IL" $cyan
Create-ProjectCard "suburban-wildlife-solutions-card" "Suburban Wildlife Solutions" "Business Website • Local SEO" "WordPress, PHP, Local SEO, Lead Generation" "Lead-Generating Wildlife Control & Animal Exclusion in Connecticut" $emerald
