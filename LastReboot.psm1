function Get-LastRebootTime {
    param (
        [string]$ServerList = "servers.txt"
    )

    $servers = Get-Content $ServerList
    $rebootResults = @()

    foreach ($server in $servers) {
        $lastBoot = Get-WmiObject Win32_OperatingSystem -ComputerName $server | Select-Object @{Name="LastBootTime";Expression={$_.LastBootUpTime}}

        $rebootResults += [PSCustomObject]@{
            Server      = $server
            LastReboot  = $lastBoot.LastBootTime
        }
    }

    $rebootResults | Export-Csv -Path "LastReboot.csv" -NoTypeInformation
}
