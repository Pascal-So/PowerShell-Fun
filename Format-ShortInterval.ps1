Function Format-ShortInterval([Parameter(Mandatory)] [TimeSpan] $Interval) {
    <#
    .SYNOPSIS
        Pretty print short time spans

    .EXAMPLE
        Format-ShortInterval("00:03:42")
        1m 42s
    #>

    if ($Interval.TotalMinutes -lt 1.0) {
        return "{0:f1}s" -f $Interval.TotalSeconds
    }

    if ($Interval.TotalHours -lt 1.0) {
        return "{0}m {1:d2}s" -f $Interval.Minutes, $Interval.Seconds
    }

    return "{0}h {1:d2}m {2:d2}s" -f [math]::floor($Interval.TotalHours), $Interval.Minutes, $Interval.Seconds
}
