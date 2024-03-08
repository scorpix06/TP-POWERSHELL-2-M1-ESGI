# On recupere la clé API dans la variable d'environnement "LTOKEN" pour ne pas avoir d'informations sensible dans le code
$ApiKey = [System.Environment]::GetEnvironmentVariable("LTOKEN", "User")
# URL de l'API Linode
$LinodeAPI = "https://api.linode.com/v4"


# Fonction  qui utilise l'API de Linode pour créer une instance serveur
function CreateLinodeServer {
    param(
        [string]$Region,
        [string]$Plan,
        [string]$Image,
        [string]$Name,
        [string]$RootPassword
    )

    try {

        # Création du corps de la requête
        $Body = @{
            region = $Region
            type = $Plan
            image = $Image
            label = $Name
            root_pass = $RootPassword
        }

        # Tentative d'appel à l'API Linode
        $Server = Invoke-WebRequest -Uri "$LinodeAPI/linode/instances" -Method Post -Headers @{Authorization = "Bearer $ApiKey"} -Body ($Body | ConvertTo-Json) -ContentType "application/json" -ErrorAction Stop | ConvertFrom-Json
        return $Server
    }
    catch {
        Write-Host "Une erreur s'est produite lors de l'appel a l'API Linode : $_"
    }
}

# Fonction  qui utilise l'API de Linode pour récuperer l'état d'un serveur en temps reel
function GetLinodeStatus {
    param(
        [string]$Id
    )
    # Tentative d'appel à l'API Linode
    $Request = Invoke-WebRequest -Uri "$LinodeAPI/linode/instances/$Id" -Method Get -Headers @{Authorization = "Bearer $ApiKey"} -ContentType "application/json" -ErrorAction Stop | ConvertFrom-Json
    return $Request

}


