# Sets the regional format to Turkish (Turkiye) with custom date/number/currency
# settings, so apps (e.g. Raycast) use TRY as the local currency.
# Applies to the current user only. Display language is not changed.
# Undo: Set-Culture en-GB

# 1. Base format: Turkish (Turkiye). This resets any previous customisations.
Set-Culture tr-TR
Write-Host "[Set] " -ForegroundColor Green -NoNewline
Write-Host "Regional format: Turkish (Turkiye)"

# 2. Custom settings (captured from Control Panel > Region > Additional settings).
#    Non-ASCII characters are built from char codes so the file's encoding doesn't matter.
$O = [string][char]0x00D6   # O with umlaut
$settings = [ordered]@{
    # Date & time
    sShortDate       = 'd.MM.yyyy'
    sLongDate        = 'd MMMM yyyy dddd'
    sShortTime       = 'HH:mm'
    sTimeFormat      = 'HH:mm:ss'
    sYearMonth       = 'MMMM yyyy'
    sDate            = '.'
    sTime            = ':'
    s1159            = "$O$O"     # AM symbol
    s2359            = "${O}S"    # PM symbol
    iFirstDayOfWeek  = '0'        # Monday
    iFirstWeekOfYear = '0'
    iCalendarType    = '1'
    iDate            = '1'
    iTime            = '1'
    iTimePrefix      = '0'
    iTLZero          = '1'

    # Numbers
    sDecimal         = '.'
    iDigits          = '2'
    sThousand        = ','
    sGrouping        = '3;0'
    sNegativeSign    = '-'
    sPositiveSign    = ''
    iNegNumber       = '1'
    iLZero           = '1'
    sList            = ','
    iMeasure         = '0'        # Metric
    sNativeDigits    = '0123456789'
    NumShape         = '1'        # Never use native digits
    iPaperSize       = '9'        # A4

    # Currency
    sCurrency        = [string][char]0x20BA   # Turkish lira sign
    iCurrDigits      = '2'
    iCurrency        = '0'
    iNegCurr         = '1'
    sMonDecimalSep   = ','
    sMonThousandSep  = '.'
    sMonGrouping     = '3;0'
}

$key = 'HKCU:\Control Panel\International'
foreach ($name in $settings.Keys) {
    Set-ItemProperty -Path $key -Name $name -Value $settings[$name] -Type String
}
Write-Host "[Set] " -ForegroundColor Green -NoNewline
Write-Host "Custom date, number and currency (TRY) formats"

# 3. Tell running apps that regional settings changed (WM_SETTINGCHANGE "intl").
if (-not ('Win32.IntlNotify' -as [type])) {
    Add-Type -Namespace Win32 -Name IntlNotify -MemberDefinition @'
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam,
    string lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
'@
}
$result = [UIntPtr]::Zero
[void][Win32.IntlNotify]::SendMessageTimeout([IntPtr]0xffff, 0x1A, [UIntPtr]::Zero, 'intl', 2, 5000, [ref]$result)
