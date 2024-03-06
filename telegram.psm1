$botToken = [System.Environment]::GetEnvironmentVariable("TTOKEN", "User")

function Send-TelegramMessage {
    param(
        [string]$BotToken = [System.Environment]::GetEnvironmentVariable("TTOKEN", "User"),
        [string]$ChatID = "-4166933112",
        [string]$Message
    )

    # URL de l'API Telegram
    $TelegramAPI = "https://api.telegram.org/bot$BotToken/sendMessage"

    # Paramètres de la requête
    $Params = @{
        chat_id = $ChatID
        text = $Message
    }

    # Envoi de la requête
    try {
        Invoke-RestMethod -Uri $TelegramAPI -Method Post -Body $Params
        Write-Host "Notification envoyee avec succes."
    } catch {
        Write-Host "Erreur lors de l'envoi de la notification : $($_.Exception.Message)"
    }
}
