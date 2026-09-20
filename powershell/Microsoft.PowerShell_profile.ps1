$esc = [char]0x1b
$Laurel = [ordered]@{
    Reset          = "${esc}[0m"
    Bold           = "${esc}[1m"
    Dim            = "${esc}[2m"
    Italic         = "${esc}[3m"

    Accent         = "${esc}[38;2;210;123;155m" # #D27B9B
    AccentBright   = "${esc}[38;2;232;160;184m" # #E8A0B8
    AccentDim      = "${esc}[38;2;154;90;114m"  # #9A5A72
    AccentDeep     = "${esc}[38;2;122;69;88m"   # #7A4558
    Text           = "${esc}[38;2;231;231;231m" # #DDDDDD
    TextBright     = "${esc}[38;2;255;255;255m" # #FFFFFF
    Gray           = "${esc}[38;2;128;128;128m" # #808080
    DimGray        = "${esc}[38;2;98;98;98m"    # #626262
    DarkGray       = "${esc}[38;2;72;72;72m"    # #484848
    Rule           = "${esc}[38;2;58;58;58m"    # #3A3A3A
    Success        = "${esc}[38;2;157;191;138m" # #9DBF8A
    Error          = "${esc}[38;2;201;122;122m" # #C97A7A
    Warning        = "${esc}[38;2;217;178;124m" # #D9B27C
    Info           = "${esc}[38;2;143;169;196m" # #8FA9C4

    SyntaxComment  = "${esc}[38;2;106;106;106m" # #6A6A6A
    SyntaxFunction = "${esc}[38;2;201;160;180m" # #C9A0B4
    SyntaxVariable = "${esc}[38;2;200;200;200m" # #C8C8C8
    SyntaxString   = "${esc}[38;2;191;163;126m" # #BFA37E
    SyntaxOperator = "${esc}[38;2;168;168;168m" # #A8A8A8

    BgSelected     = "${esc}[48;2;60;48;53m"    # #3C3035
    BgAccentDeep   = "${esc}[48;2;122;69;88m"   # #7A4558
}

$LaurelReadLineColors = @{
    Default                = $Laurel.Text
    Comment                = "$($Laurel.SyntaxComment)$($Laurel.Dim)"
    Keyword                = $Laurel.Accent
    String                 = $Laurel.SyntaxString
    Operator               = $Laurel.SyntaxOperator
    Variable               = $Laurel.SyntaxVariable
    Command                = $Laurel.SyntaxFunction
    Parameter              = $Laurel.Info
    Type                   = $Laurel.Info
    Number                 = $Laurel.Success
    Member                 = $Laurel.SyntaxFunction
    Emphasis               = "$($Laurel.AccentBright)$($Laurel.Bold)"
    Error                  = "$($Laurel.Error)$($Laurel.Bold)"
    Selection              = "$($Laurel.TextBright)$($Laurel.BgSelected)"
    InlinePrediction       = "$($Laurel.DimGray)$($Laurel.Dim)$($Laurel.Italic)"
    ListPrediction         = $Laurel.Gray
    ListPredictionSelected = "$($Laurel.TextBright)$($Laurel.BgAccentDeep)"
    ListPredictionTooltip  = "$($Laurel.DimGray)$($Laurel.Dim)$($Laurel.Italic)"
    ContinuationPrompt     = $Laurel.DimGray
}

# pwsh 7.x output, prompt, and file listings share the same theme
if ($null -ne $PSStyle)
{
    $PSStyle.Formatting.FormatAccent = $Laurel.Accent
    $PSStyle.Formatting.TableHeader = "$($Laurel.AccentBright)$($Laurel.Bold)"
    $PSStyle.Formatting.CustomTableHeaderLabel = $Laurel.Accent
    $PSStyle.Formatting.ErrorAccent = $Laurel.Error
    $PSStyle.Formatting.Error = "$($Laurel.Error)$($Laurel.Bold)"
    $PSStyle.Formatting.Warning = $Laurel.Warning
    $PSStyle.Formatting.Verbose = $Laurel.Gray
    $PSStyle.Formatting.Debug = $Laurel.Info
    $PSStyle.Formatting.FeedbackName = $Laurel.Accent
    $PSStyle.Formatting.FeedbackText = $Laurel.Text
    $PSStyle.Formatting.FeedbackAction = $Laurel.Success

    $PSStyle.Progress.Style = "$($Laurel.Warning)$($Laurel.Bold)"
    $PSStyle.Progress.View = 'Minimal'

    $PSStyle.FileInfo.Directory = "$($Laurel.Info)$($Laurel.Bold)"
    $PSStyle.FileInfo.SymbolicLink = $Laurel.Accent
    $PSStyle.FileInfo.Executable = $Laurel.Success

    $LaurelFileExtensions = @{
        '.ps1'   = $Laurel.Accent
        '.psm1'  = $Laurel.Accent
        '.psd1'  = $Laurel.Accent
        '.json'  = $Laurel.Info
        '.jsonc' = $Laurel.Info
        '.yaml'  = $Laurel.Info
        '.yml'   = $Laurel.Info
        '.toml'  = $Laurel.Info
        '.md'    = $Laurel.Text
        '.txt'   = $Laurel.Gray
        '.log'   = $Laurel.Gray
        '.exe'   = $Laurel.Success
        '.com'   = $Laurel.Success
        '.bat'   = $Laurel.Success
        '.cmd'   = $Laurel.Success
        '.zip'   = $Laurel.Warning
        '.7z'    = $Laurel.Warning
        '.tar'   = $Laurel.Warning
        '.gz'    = $Laurel.Warning
    }
    foreach ($extension in $LaurelFileExtensions.Keys)
    {
        $PSStyle.FileInfo.Extension[$extension] = $LaurelFileExtensions[$extension]
    }
}

# provide a sensible fallback for output that does not use $PSStyle
if ($null -ne $Host.PrivateData)
{
    try
    {
        $legacyLaurelColors = @{
            FormatAccentColor       = [ConsoleColor]::DarkMagenta
            ErrorAccentColor        = [ConsoleColor]::DarkRed
            ErrorForegroundColor    = [ConsoleColor]::DarkRed
            ErrorBackgroundColor    = [ConsoleColor]::Black
            WarningForegroundColor  = [ConsoleColor]::DarkYellow
            WarningBackgroundColor  = [ConsoleColor]::Black
            DebugForegroundColor    = [ConsoleColor]::DarkCyan
            DebugBackgroundColor    = [ConsoleColor]::Black
            VerboseForegroundColor  = [ConsoleColor]::DarkGray
            VerboseBackgroundColor  = [ConsoleColor]::Black
            ProgressForegroundColor = [ConsoleColor]::DarkGreen
            ProgressBackgroundColor = [ConsoleColor]::Black
        }
        foreach ($entry in $legacyLaurelColors.GetEnumerator())
        {
            if ($null -ne $Host.PrivateData.PSObject.Properties[$entry.Key])
            {
                $Host.PrivateData.($entry.Key) = $entry.Value
            }
        }
    }
    catch
    {
        # some hosts expose read-only PrivateData so $PSStyle above is sufficient
    }
}

function prompt
{
    # capture the previous command state before Get-Location changes $?.
    $lastCommandSucceeded = $?
    $location = Get-Location
    $dirName = Split-Path -Path $location.Path -Leaf
    if ([string]::IsNullOrEmpty($dirName))
    {
        $dirName = $location.Path
    }

    $stateColor = if ($lastCommandSucceeded) { $Laurel.Accent } else { $Laurel.Error }
    return "$stateColor$dirName$($Laurel.Reset)$($Laurel.Bold)$($Laurel.TextBright) λ $($Laurel.Reset)"
}

if (Get-Module -ListAvailable -Name PSReadLine)
{
    Import-Module PSReadLine -ErrorAction SilentlyContinue
    if (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue)
    {
        try
        {
            Set-PSReadLineOption -Colors $LaurelReadLineColors -ErrorAction Stop
            Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction Stop
            Set-PSReadLineOption -PredictionSource History -ErrorAction Stop
        }
        catch
        {
            # PSReadLine cannot change prediction settings in non-interactive hosts
        }
    }
}


# user functions
function clear
{
    $escape = [char]0x1b
    Write-Host -NoNewline "${escape}[2J${escape}[3J${escape}[H"
}

function laepiti
{
    java -jar (Join-Path $HOME 'Programs\laepiti.jar') @args
}
