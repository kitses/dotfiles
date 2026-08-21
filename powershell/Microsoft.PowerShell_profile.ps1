function prompt {
  $esc = [char]0x1b
  $colorError = "$esc[38;2;237;31;103m"
  $colorNormal = "$esc[38;2;114;222;194m"
  $colorBold = "$esc[1m"
  $colorReset = "$esc[0m"

  if (-not $? -or $LASTEXITCODE -eq 1 -or $LASTEXITCODE -eq 130) {
    $currentColor = $colorError
  } else {
    $currentColor = $colorNormal
  }

  $dirName = Split-Path -Path $PWD -Leaf

  return "$currentColor$dirName$colorReset$colorBold λ $colorReset"
}

function clear {
  Write-Host -NoNewline "$([char]0x1b)[2J$([char]0x1b)[3J$([char]0x1b)[H"
}
