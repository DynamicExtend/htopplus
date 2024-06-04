New-Alias HtopPlus .\htopplus.ps1

[bool]$Running = 1

clear #start
function Write-ColorOutput($ForegroundColor)
{
    # save the current color
    $fc = $host.UI.RawUI.ForegroundColor

    # set the new color
    $host.UI.RawUI.ForegroundColor = $ForegroundColor

    # output
    if ($args) {
        Write-Output $args
    }
    else {
        $input | Write-Output
    }

    # restore the original color
    $host.UI.RawUI.ForegroundColor = $fc
}
function global:Get-Values{
    $global:os = (Get-WmiObject Win32_OperatingSystem).caption
    $global:computerName = $env:COMPUTERNAME
    $global:cpuLoad = (Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
    $global:cpu = Get-WmiObject -Class Win32_Processor -ComputerName. | Select-Object -Property [a-z]*
    $function:prompt = "$ "
}
function Render-CPU{
    if ($cpuLoad -lt 70) {
        $host.privatedata.ProgressBackgroundColor = "Black"
        $host.privatedata.ProgressBackgroundColor = "Green";
        Write-Progress -PercentComplete ($cpuLoad/100*100) -Status "$($cpu.Name): " -Activity "$cpuLoad of 100%"
    }else {
        $host.privatedata.ProgressBackgroundColor = "Black"
        $host.privatedata.ProgressBackgroundColor = "Red";
        Write-Progress -PercentComplete ($cpuLoad/100*100) -Status "$($cpu.Name): " -Activity "$cpuLoad of 100%"
    }
}
function Render-Values{
    clear
    Get-Values
    Write-ColorOutput Blue ("Computer Name: $computerName")
    Write-ColorOutput Blue ("Operating System: $os")
    Render-CPU
    Sleep 3
}



while ($Running) {
    Get-Values
    Render-Values
}

