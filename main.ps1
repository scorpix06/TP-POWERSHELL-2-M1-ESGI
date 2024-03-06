Import-Module -Name ./linode.psm1
Import-Module -Name ./telegram.psm1

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
$comboBox1.Items.AddRange(@("linode/debian12", "linode/alpine3.19", "linode/ubuntu22.04"))
$form.Controls.Add($comboBox1)

# Création d'une liste déroulante pour les specifications
$comboBox2 = New-Object System.Windows.Forms.ComboBox
$comboBox2.Location = New-Object System.Drawing.Point(50, 50)
$comboBox2.Size = New-Object System.Drawing.Size(200, 20)
$comboBox2.Text = "Type de serveur"
$comboBox2.Items.AddRange(@("g6-nanode-1", "g6-standard-1"))
$form.Controls.Add($comboBox2)

# Création d'un champ de texte pour recuperer le nom de la VM cloud
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(50,80)
$textBox.Size = New-Object System.Drawing.Size(200,20)
$textBox.Text = "Serveur-Name"
$form.Controls.Add($textBox)

$textBox2 = New-Object System.Windows.Forms.TextBox
$textBox2.Location = New-Object System.Drawing.Point(50,110)
$textBox2.Size = New-Object System.Drawing.Size(200,20)
$textBox2.Text = "Root-Password@"
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

    # Envoi de la requête
    try {
        CreateLinodeServer -Region "fr-par" -Plan $Plan -Image $Image -Name $Name -RootPassword $RootPassword
        Send-TelegramMessage -Message "Deploiement du serveur [$Name] en cours"
    } catch {
        Write-Host "Erreur lors du deploiement du serveur : $($_.Exception.Message)"
    }
    #
    

    $message = "Le serveur est en cours de deploiement, la fenetre va se fermer. Les informations sont envoyes sur telegram`r`n"
    [System.Windows.Forms.MessageBox]::Show($message, "Message")
})

# Affichage du formulaire
$form.ShowDialog() | Out-Null
