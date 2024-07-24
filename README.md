# Wake-on-LAN y Comandos Remotos en PowerShell 🚀

¡Bienvenido al script de Wake-on-LAN y ejecución de comandos remotos en PowerShell! Este script te permite enviar paquetes mágicos para despertar equipos en tu red local y ejecutar comandos remotos de manera fácil y eficiente. 🔧

## Características ✨

- **Wake-on-LAN (WoL) a través de Ethernet** 🌐
- **Ejecución de comandos remotos** 💻
- **Interfaz interactiva y fácil de usar** 🖥️
- **Soporte para enviar paquetes WoL a múltiples direcciones MAC** 📡

## Requisitos 📋

- PowerShell 5.1 o superior 🛠️
- Permisos de administrador para ejecutar ciertos comandos 🔐
- Configuración adecuada de WoL en el hardware y la red 🔧

## Uso 🏃‍♂️

1. **Clona este repositorio**:
    ```sh
    git clone https://github.com/Rannden-SHA/WoL-RCE.git
    ```
2. **Navega al directorio del script**:
    ```sh
    cd WoL-RCE
    ```
3. **Ejecuta el script**:
    ```sh
    .\WoL-CMD_Tools.ps1
    ```
## Configuración de la Máquina Remota 🛠️

### Cambiar el Tipo de Red a Privada 🔒

#### A través de la Configuración de Windows:

1. **Abrir Configuración de Windows**: Presiona `Win + I`.
2. **Red e Internet**: Haz clic en "Red e Internet".
3. **Estado de la Red**: Selecciona "Propiedades de la conexión".
4. **Cambiar el Perfil de Red**: Cambia el perfil de red a "Privado".

#### A través de PowerShell:

```powershell
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
```

### Habilitar PowerShell Remoting 💻

Abrir PowerShell como Administrador: Haz clic derecho en el icono de PowerShell y selecciona "Ejecutar como administrador".
Ejecutar el Comando para Habilitar Remoting:

```powershell
Enable-PSRemoting -Force
```

### Configurar la Política de Ejecución (si es necesario):

```powershell
Set-ExecutionPolicy RemoteSigned -Force
```

### Comprobación de la Configuración ✔️

Para asegurarte de que todo está configurado correctamente, ejecuta:

```powershell
Test-WsMan
```

Si todo está configurado correctamente, deberías ver un mensaje indicando que WinRM está funcionando.

## Funciones Principales 🛠️

### Wake-on-LAN (WoL) 🌐

Envia un paquete mágico para despertar equipos en la red local.

### Ejecución de Comandos Remotos 🖥️

Permite ejecutar comandos en equipos remotos usando PowerShell Remoting.

### Menú Interactivo 📋

Proporciona un menú interactivo para seleccionar las opciones de WoL o ejecución de comandos.

## Cómo Funciona 📘

### Opciones del Menú

1. **Wake-on-LAN (WoL)**:
    - Introduce la dirección de broadcast (ejemplo: `192.168.1.255`).
    - Introduce una o varias direcciones MAC de los equipos que quieres despertar (ejemplo: `A1:B2:C3:D4:E5`).

2. **Ejecutar Comando Remoto**:
    - Introduce la dirección IP del equipo remoto.
    - Introduce el comando que deseas ejecutar (ejemplo: `shutdown /r /t 5`).



## Contribuir 🤝

¡Las contribuciones son bienvenidas! Si tienes mejoras o correcciones, por favor, abre un pull request o crea un issue para discutir los cambios propuestos.

## Licencia 📄

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo LICENSE para más detalles.

## Agradecimientos 🎉

Gracias por usar este script y contribuir a su desarrollo. ¡Esperamos que te sea de utilidad!
