Import-Module PoshGram

# Bot Info
$chat_ID = ""
$token = ""

# AP Info
$accessPoints = @("10.10.1.5", "10.10.1.4", "10.10.1.3","10.10.1.1", "google.com")
$accessPointNames = @("Upstairs AP", "Summer House AP", "Living Room AP", "pfSense", "google.com")

function getRouterStatus(){
  # Local var for exiting loop
  $endProgram = $null

  # For printing AP names
  $countNames = 0

  while($null -eq $endProgram){
    foreach($accessPoint in $accessPoints){
      $connectionStatus = Test-Connection -TargetName $accessPoint -Count 1 -ErrorAction SilentlyContinue
      if($connectionStatus.Status -ne "Success"){
        # Fancy Output?
        $output = "Connection Status: " + $connectionStatus.Status +
        "`nIP address: " + $accessPoint +
        "`nAccess Point Name: " + $accessPointNames[$countNames]
        Send-TelegramTextMessage -BotToken $token -ChatID $chat_ID -Message $output
      }
      $countNames += 1
      if($countNames -ge $accessPointNames.Length){
        $countNames = 0
      }
    }
    Start-Sleep -s 60
  }
}

getRouterStatus
