Import-Module -Name ./linode.psm1
Import-Module -Name ./telegram.psm1
Import-Module -Name ./logging.psm1
Import-Module -Name powershell-yaml

# Importation des parametres du script
try {
    $Settings = Get-Content -Path "./settings.yml" | ConvertFrom-Yaml 
    $DefaultPass = $Settings.default_password
    $DefaultServerName = $Settings.default_server_name
    WriteLog -Message "Importation  du fichier de configuration effectue avec succes"
    
}
catch {
    WriteLog -Message "Erreur lors de l'importation du fichier de configuration : $($_.Exception.Message)"
}


Add-Type -AssemblyName System.Windows.Forms

# Création d'un objet Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Instant cloud provisionning"
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = "CenterScreen"

# Création d'une liste déroulante pour le choix de l'OS
$comboBox1 = New-Object System.Windows.Forms.ComboBox
$comboBox1.Location = New-Object System.Drawing.Point(50, 20)
$comboBox1.Size = New-Object System.Drawing.Size(200, 20)
$comboBox1.Text = "Choix de l'OS :"
$comboBox1.Items.AddRange($Settings.os)
$form.Controls.Add($comboBox1)

# Création d'une liste déroulante pour les specifications
$comboBox2 = New-Object System.Windows.Forms.ComboBox
$comboBox2.Location = New-Object System.Drawing.Point(50, 50)
$comboBox2.Size = New-Object System.Drawing.Size(200, 20)
$comboBox2.Text = "Type de serveur"
$comboBox2.Items.AddRange($Settings.plan)
$form.Controls.Add($comboBox2)

# Création d'un champ de texte pour recuperer le nom de la VM cloud
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(50,80)
$textBox.Size = New-Object System.Drawing.Size(200,20)
$textBox.Text = "$DefaultServerName"
$form.Controls.Add($textBox)

$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(50,110)
$textBox2.Size = New-Object System.Drawing.Size(200,20)
$textBox2.Text = "$DefaultPass"
$form.Controls.Add($textBox2)


# Création d'un bouton Envoyer
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(100,130)
$button.Size = New-Object System.Drawing.Size(100,30)
$button.Text = "Deployer"
$form.Controls.Add($button)

# Fonction pour gérer l'événement de clic sur le bouton Envoyer
$button.Add_Click({

    $Image = $($comboBox1.SelectedItem)
    $Plan = $($comboBox2.SelectedItem)
    $Name = $($textBox.Text)
    $RootPassword = $($textBox2.Text)

    
    try {

        # Envoi de la requête a l'API de Linode pour déployer un serveur
        $Server = CreateLinodeServer -Region "fr-par" -Plan $Plan -Image $Image -Name $Name -RootPassword $RootPassword
        $ServerIp = $Server.ipv4
        $ServerStatus = $Server.status 

        Send-TelegramMessage -Message "Deploiement du serveur [$Name] en cours `n IP : $ServerIp `n Status: $ServerStatus"
        WriteLog -Message "Deploiement du serveur [$Name] en cours ($Server)"
        $message = "Le serveur est en cours de deploiement, le suivi est envoye sur Telegram`r`n"
        [System.Windows.Forms.MessageBox]::Show($message, "Message")

        while (($Server.status -eq "provisioning") -or ($Server.status -eq "booting")) {

            $Server = GetLinodeStatus -Id $Server.id
            if ($Server.status -eq "running") {
                Send-TelegramMessage -Message "Le serveur [$Name] est deploye. Vous pouvez desormais vous y connecter." 
                Write-Log -Message "Le serveur [$Name] est déployé"  
            }
            Start-Sleep -Seconds 9
        }
        
    } catch {

        $message = "Une erreur a eu lieu lors du deploiement du serveur : $($_.Exception.Message)`r`n"
        [System.Windows.Forms.MessageBox]::Show($message, "Message")
        WriteLog -Message "Une erreur a eu lieu lors du déploiement du serveur ($($_.Exception.Message))"
    }

})

# Affichage du formulaire
$form.ShowDialog() | Out-Null
