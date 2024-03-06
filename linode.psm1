# Paramètres de l'API Linode
$ApiKey = [System.Environment]::GetEnvironmentVariable("LTOKEN", "User")

# URL de l'API Linode
$LinodeAPI = "https://api.linode.com/v4"

# Création d'un serveur Linode
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

        Write-Host ($Body | ConvertTo-Json)
        # Tentative d'appel à l'API Linode
        $Server = Invoke-WebRequest -Uri "$LinodeAPI/linode/instances" -Method Post -Headers @{Authorization = "Bearer $ApiKey"} -Body ($Body | ConvertTo-Json) -ContentType "application/json" -ErrorAction Stop | ConvertFrom-Json
        Write-Host $Server.Content
        return $Server
    }
    catch {
        Write-Host "Une erreur s'est produite lors de l'appel a l'API Linode : $_"
    }
}

function GetLinodeStatus {
    param(
        [string]$Name
    )
    # Tentative d'appel à l'API Linode
    $Server = Invoke-WebRequest -Uri "$LinodeAPI/linode/instances" -Method Get -Headers @{Authorization = "Bearer $ApiKey"} -Body ($Body | ConvertTo-Json) -ContentType "application/json" -ErrorAction Stop | ConvertFrom-Json
    Write-Host $Server.Content
    return $Server

}

