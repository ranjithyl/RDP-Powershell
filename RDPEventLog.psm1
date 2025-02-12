function Get-RDPEventLog {
    param (
        [string]$ServerList = "servers.txt"
    )

    $servers = Get-Content $ServerList
    $rdpEvents = @()

    foreach ($server in $servers) {
        $events = Get-WinEvent -ComputerName $server -LogName Security -FilterXPath "*[System[EventID=4624]]" -MaxEvents 5

        foreach ($event in $events) {
            $rdpEvents += [PSCustomObject]@{
                Server   = $server
                Time     = $event.TimeCreated
                User     = $event.Properties[5].Value
                LogonType = $event.Properties[8].Value
            }
        }
    }

    $rdpEvents | Export-Csv -Path "RDPEventLog.csv" -NoTypeInformation
}
