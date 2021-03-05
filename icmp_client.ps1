$myip = "10.10.10.1"
$ip = New-Object System.Net.IPEndPoint([ipaddress]::Parse($myip),0)

$serv = New-Object System.Net.Sockets.Socket(
    [System.Net.Sockets.AddressFamily]::InterNetwork, 
    [System.Net.Sockets.SocketType]::Raw, 
    [System.Net.Sockets.ProtocolType]::Icmp)
$serv.Bind($ip)
$serv.IOControl(
    [System.Net.Sockets.IOControlCode]::ReceiveAll, 
    [System.BitConverter]::GetBytes(1), 
    $null)

$writer = [System.IO.File]::OpenWrite("cat_received.jpg")

while ($true){
    $buffer = New-Object byte[] $serv.ReceiveBufferSize
    $size = $serv.ReceiveFrom($buffer, [ref] $ip)
    $txt = [text.encoding]::Default.GetString($buffer[28..$size])
    if ($txt -eq "`n"){
        break
    }
    $writer.Write($buffer[28..$size], 0, ($size-28))
}
$writer.Dispose()
