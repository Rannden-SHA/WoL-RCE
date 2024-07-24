# Función para mostrar texto en color
function Write-Color {
    param (
        [string]$Text,
        [string]$Color = "White"
    )
    $Host.UI.RawUI.ForegroundColor = $Color
    Write-Host $Text
    $Host.UI.RawUI.ForegroundColor = "White"
}

# Función para enviar el paquete mágico
function Send-MagicPacket {
    param (
        [string[]]$macAddresses,
        [string]$broadcastAddress
    )

    foreach ($macAddress in $macAddresses) {
        # Convertir la direccion MAC en bytes
        $macBytes = [byte[]]($macAddress -split '-').ForEach({ [convert]::ToByte($_, 16) })

        # Crear el paquete magico
        $magicPacket = @([byte[]]@(255, 255, 255, 255, 255, 255) + ($macBytes * 16))

        # Definir el puerto
        $port = 9 # Puerto usado comúnmente para Wake-on-LAN

        # Crear un cliente UDP y enviar el paquete mágico
        try {
            $udpClient = New-Object System.Net.Sockets.UdpClient
            $udpClient.Connect($broadcastAddress, $port)
            [void]$udpClient.Send($magicPacket, $magicPacket.Length)
            $udpClient.Close()
            Write-Color "Paquete magico enviado a $macAddress a traves de $broadcastAddress" "Green"
        } catch {
            Write-Color "Error al enviar el paquete magico a $macAddress. Verifica las direcciones e intenta nuevamente." "Red"
        }
    }
}

# Función para ejecutar un comando remoto
function Execute-RemoteCommand {
    param (
        [string]$remoteComputer,
        [string]$command
    )
    Write-Color "" "White"
    Write-Color "Recuerda poner la red del equipo remoto en >>Private<<" "Blue"
    Write-Color "Puedes usar el siguiente comando en el equipo remoto para activarlo: Set-NetConnectionProfile -Name ""NetworkName"" -NetworkCategory Private" "Blue"
    Write-Color "" "White"
    Write-Color "Luego tienes que habilitar la ejecucion remota de comandos (RCE) a traves de Powershell en el equipo remoto con el siguiente comando: Enable-PSRemoting -Force" "Blue"
    Write-Color "" "White"
    
    # Agregar el equipo remoto a los hosts de confianza
    Set-Item wsman:\localhost\Client\TrustedHosts -Value $remoteComputer -Force

    # Solicitar las credenciales del usuario
    Write-Color "Por favor, introduce las credenciales para el equipo remoto:" "Yellow"
    $credential = Get-Credential

    # Enviar el comando al equipo remoto
    try {
        Write-Color "Ejecutando comando en el equipo remoto..." "Cyan"
        Invoke-Command -ComputerName $remoteComputer -Credential $credential -ScriptBlock {
            param ($cmd)
            Invoke-Expression $cmd
        } -ArgumentList $command
        Write-Color "El comando se ejecuto correctamente en el equipo remoto." "Green"
    } catch {
        Write-Color "Error al ejecutar el comando en el equipo remoto. Verifica las direcciones e intenta nuevamente." "Red"
    }
}

# Función principal
function Main {
    do {
        # Limpia la terminal
        Clear-Host

        # Solicitar la opción al usuario
        Write-Color "Selecciona una opcion (escribe 'wol' para Wake-on-LAN o 'cmd' para ejecutar un comando remoto):" "Yellow"
        $option = Read-Host

        if ($option -eq 'wol') {
            # Solicitar la direccion de broadcast al usuario
            Write-Color "Por favor, introduce la direccion de broadcast (ejemplo: 192.168.211.255):" "Yellow"
            $broadcastAddress = Read-Host

            # Validar la direccion de broadcast
            if (-not $broadcastAddress -match "^(\d{1,3}\.){3}\d{1,3}$") {
                Write-Color "La direccion de broadcast no es valida. Por favor, introduce una direccion IP valida." "Red"
                continue
            }

            # Solicitar si se desea introducir una o varias direcciones MAC
            Write-Color "Quieres introducir una sola direccion MAC o varias? (escribe 'una' o 'varias'):" "Yellow"
            $macOption = Read-Host

            $macAddresses = @()

            if ($macOption -eq 'una') {
                # Solicitar la direccion MAC al usuario
                Write-Color "Por favor, introduce la direccion MAC del equipo que quieres encender (ejemplo: 1C-69-7A-AF-D3-61):" "Yellow"
                $macAddress = Read-Host

                # Validar la direccion MAC
                if ($macAddress -match "^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$") {
                    $macAddresses += $macAddress
                } else {
                    Write-Color "La direccion MAC no es valida. Por favor, introduce una direccion MAC en el formato XX-XX-XX-XX-XX-XX." "Red"
                    continue
                }
            } elseif ($macOption -eq 'varias') {
                Write-Color "Por favor, introduce las direcciones MAC, una por linea. Cuando termines, deja una linea en blanco y presiona Enter." "Yellow"
                do {
                    $macAddress = Read-Host
                    if ($macAddress -match "^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$") {
                        $macAddresses += $macAddress
                    } elseif ($macAddress -ne '') {
                        Write-Color "La direccion MAC $macAddress no es valida y se ignorara. Por favor, introduce una direccion MAC en el formato XX-XX-XX-XX-XX-XX." "Red"
                    }
                } while ($macAddress -ne '')
            } else {
                Write-Color "Opcion no valida. Por favor, introduce 'una' o 'varias'." "Red"
                continue
            }

            # Enviar los paquetes mágicos
            Send-MagicPacket -macAddresses $macAddresses -broadcastAddress $broadcastAddress

        } elseif ($option -eq 'cmd') {
            # Solicitar la direccion IP o el nombre del equipo remoto
            Write-Color "Por favor, introduce la direccion IP del equipo remoto:" "Yellow"
            $remoteComputer = Read-Host

            # Solicitar el comando a ejecutar
            Write-Color "Por favor, introduce el comando a ejecutar (ejemplo: shutdown /r /t 5):" "Yellow"
            $command = Read-Host

            # Ejecutar el comando remoto
            Execute-RemoteCommand -remoteComputer $remoteComputer -command $command

        } else {
            Write-Color "Opcion no valida. Por favor, selecciona 'wol' o 'cmd'." "Red"
        }

        # Preguntar si se desea realizar otra acción
        Write-Color "Quieres realizar otra accion? (s/n):" "Yellow"
        $response = Read-Host
    } while ($response -eq 's')

    Write-Color "Script finalizado. Presiona Enter para salir." "Blue"
    Read-Host

    Write-Color "BYE..." "Cyan"
}

# Ejecutar la función principal
Main
