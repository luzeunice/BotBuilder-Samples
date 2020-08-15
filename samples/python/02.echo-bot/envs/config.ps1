$nombre_ambiente = "chat_bot_02"

function Crear_Ambiente {
    write-host "`n##########    Creando el ambiente    ##########`n"
    # Crear
    python -m venv $Env_Path       

    write-host "`n##########    Activando el ambiente    ##########`n"
    # Activando
    & "$Env_Path\Scripts\Activate.ps1"

    
    # Instalar requerimientos
    $req_path = "$PSScriptRoot\requirements.txt"
    $Existe_req = [System.IO.File]::Exists($req_path)
    if ($Existe_req){
        write-host "`n##########    Instalando las librerias    ##########`n"
        pip install -r $req_path
    }
    
}

function Crear_Settings_JSON {
    
    $Settings_Path = (Get-Item $PSScriptRoot).parent.FullName + "\.vscode"
    
    # Verificando la carpeta
    if (-Not (Test-Path ($Settings_Path) -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $Settings_Path
    }
    # Creando el archivo
    $obj = [pscustomobject]@{
        "python.pythonPath" = ".\envs\$nombre_ambiente\Scripts\python"
        }
    
    $PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
    $obj | ConvertTo-Json | Out-File "$Settings_Path\settings.json"
    
    # $properties = @{
    #     "python.pythonPath" = ".\envs\$nombre_ambiente\Scripts\python"
    #     }
    # $obj = New-Object psobject -Property $properties;
    # $obj | ConvertTo-Json -Depth 50 | % { [System.Text.RegularExpressions.Regex]::Unescape($_) } | Out-File "$Settings_Path\settings.json"
    # Moviendo el archivo
    # Move-Item -Path "$PSScriptRoot\settings.json" -Destination "$Settings_Path\settings.json" -Force
}

function Activar_Ambiente {
    # Activando
    write-host "`n##########    Activando el ambiente    ##########`n"
    & "$Env_Path\Scripts\activate.ps1"
}


# Comprobando si existe el ambiente
$Env_Path = "$PSScriptRoot\$nombre_ambiente"
write-host $Env_Path
if (-Not (Test-Path ($Env_Path) -PathType Container)) {
    Crear_Ambiente
    Crear_Settings_JSON    
}
else{
    Activar_Ambiente
}

