function Check-RDPStatus {
    param (
        [string]$ServerList = "servers.txt"
    )

    $servers = Get-Content $ServerList
    $rdpResults = @()

    foreach ($server in $servers) {
        $serviceStatus = (Get-Service -Name TermService -ComputerName $server).Status
        $portStatus = Test-NetConnection -ComputerName $server -Port 3389 -InformationLevel Detailed

        $rdpResults += [PSCustomObject]@{
            Server        = $server
            ServiceStatus = $serviceStatus
            PortStatus    = if ($portStatus.TcpTestSucceeded) { "Open" } else { "Closed" }
        }
    }

    $rdpResults | Export-Csv -Path "RDPStatus.csv" -NoTypeInformation
}
