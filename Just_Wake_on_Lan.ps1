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
        # Convertir la dirección MAC en bytes
        $macBytes = [byte[]]($macAddress -split '-').ForEach({ [convert]::ToByte($_, 16) })

        # Crear el paquete mágico
        $magicPacket = @([byte[]]@(255, 255, 255, 255, 255, 255) + ($macBytes * 16))

        # Definir el puerto
        $port = 9 # Puerto usado comúnmente para Wake-on-LAN

        # Crear un cliente UDP y enviar el paquete mágico
        try {
            $udpClient = New-Object System.Net.Sockets.UdpClient
            $udpClient.Connect($broadcastAddress, $port)
            [void]$udpClient.Send($magicPacket, $magicPacket.Length)
            $udpClient.Close()
            Write-Color "Paquete mágico enviado a $macAddress a través de $broadcastAddress" "Green"
        } catch {
            Write-Color "Error al enviar el paquete mágico a $macAddress. Verifica las direcciones e intenta nuevamente." "Red"
        }
    }
}

# Función principal
function Main {
    do {
        # Solicitar la dirección de broadcast al usuario
        Write-Color "Por favor, introduce la dirección de broadcast (ejemplo: 192.168.211.255):" "Yellow"
        $broadcastAddress = Read-Host

        # Validar la dirección de broadcast
        if (-not $broadcastAddress -match "^(\d{1,3}\.){3}\d{1,3}$") {
            Write-Color "La dirección de broadcast no es válida. Por favor, introduce una dirección IP válida." "Red"
            continue
        }

        # Solicitar si se desea introducir una o varias direcciones MAC
        Write-Color "¿Quieres introducir una sola dirección MAC o varias? (escribe 'una' o 'varias'):" "Yellow"
        $option = Read-Host

        $macAddresses = @()

        if ($option -eq 'una') {
            # Solicitar la dirección MAC al usuario
            Write-Color "Por favor, introduce la dirección MAC del equipo que quieres encender (ejemplo: 1C-69-7A-AF-D3-61):" "Yellow"
            $macAddress = Read-Host

            # Validar la dirección MAC
            if ($macAddress -match "^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$") {
                $macAddresses += $macAddress
            } else {
                Write-Color "La dirección MAC no es válida. Por favor, introduce una dirección MAC en el formato XX-XX-XX-XX-XX-XX." "Red"
                continue
            }
        } elseif ($option -eq 'varias') {
            Write-Color "Por favor, introduce las direcciones MAC, una por línea. Cuando termines, deja una línea en blanco y presiona Enter." "Yellow"
            do {
                $macAddress = Read-Host
                if ($macAddress -match "^([0-9A-Fa-f]{2}-){5}[0-9A-Fa-f]{2}$") {
                    $macAddresses += $macAddress
                } elseif ($macAddress -ne '') {
                    Write-Color "La dirección MAC $macAddress no es válida y se ignorará. Por favor, introduce una dirección MAC en el formato XX-XX-XX-XX-XX-XX." "Red"
                }
            } while ($macAddress -ne '')
        } else {
            Write-Color "Opción no válida. Por favor, introduce 'una' o 'varias'." "Red"
            continue
        }

        # Enviar los paquetes mágicos
        Send-MagicPacket -macAddresses $macAddresses -broadcastAddress $broadcastAddress

        # Preguntar si se desea enviar otro paquete Wake-on-LAN
        Write-Color "¿Quieres enviar otro paquete Wake-on-LAN? (sí/no):" "Yellow"
        $response = Read-Host
    } while ($response -eq 'sí')

    Write-Color "¡Adiós!" "Cyan"
}

# Ejecutar la función principal
Main
