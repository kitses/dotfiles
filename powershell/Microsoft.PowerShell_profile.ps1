function prompt {
  $lastStatus = $LASTEXITCODE
  $esc = [char]0x1b

  # ed1f67
  $colorError = "$esc[38;2;237;31;103m"
  # 72dec2
  $colorNormal = "$esc[38;2;114;222;194m"
  $colorReset = "$esc[0m"

  if ($lastStatus -eq 1 -or $lastStatus -eq 130) {
    $currentColor = $colorError
  } else {
    $currentColor = $colorNormal
  }

  $dirName = Split-Path -Path $PWD -Leaf

  return "$currentColor$dirName$colorReset ❄ "
}
