[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Test-Administrator {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Este script requiere privilegios de administrador para ejecutarse correctamente." -ForegroundColor Red
        Write-Host "Por favor, ejecuta PowerShell como administrador y navega a la ruta de este script para ejecutarlo." -ForegroundColor Yellow
        Write-Host "`nPulsa Enter para salir." -ForegroundColor DarkYellow
        $null = Read-Host
        exit
    }
    Write-Host "Ejecutando con privilegios de administrador." -ForegroundColor Green
    Write-Host "(Confirmado: Esta consola tiene permisos de administrador.)" -ForegroundColor DarkGray
}

Test-Administrator

function Install-TShark {
    Write-Host "Verificando la instalacion de TShark..." -ForegroundColor Yellow
    
    $tsharkFound = $false
    if (Get-Command tshark.exe -ErrorAction SilentlyContinue) {
        Write-Host "TShark.exe encontrado en el PATH del sistema. Verificando funcionalidad..." -ForegroundColor Green
        try {
            $null = & tshark -D -ErrorAction Stop
            Write-Host "TShark esta instalado y funciona correctamente. Continuando..." -ForegroundColor Green
            $tsharkFound = $true
        } catch {
            Write-Warning "TShark.exe se encontro, pero la ejecucion de 'tshark -D' fallo. Esto podria indicar un problema con la instalacion de Wireshark o que el PATH no esta completamente actualizado."
            Write-Warning "Detalles del error: $($_.Exception.Message)"
        }
    } 

    if (-not $tsharkFound) {
        Write-Host "TShark no se encontro o no es completamente funcional en tu sistema." -ForegroundColor Red
        Write-Host "Este script requiere TShark (parte de Wireshark) para funcionar." -ForegroundColor Red
        Write-Host "Intentando descargar e instalar Wireshark (que incluye TShark) automaticamente." -ForegroundColor Cyan
        Write-Host "Esto puede requerir privilegios de administrador y tomar unos minutos." -ForegroundColor Cyan

        $downloadUrl = "https://www.wireshark.org/download/win64/all-versions/Wireshark-4.4.7-x64.exe"
        $installerPath = Join-Path $env:TEMP "Wireshark-Installer.exe"

        Write-Host "Descargando instalador de Wireshark desde: $downloadUrl" -ForegroundColor Green
        try {
            Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing
            Write-Host "Descarga completa. Ejecutando instalador silenciosamente..." -ForegroundColor Green

            $process = Start-Process -FilePath $installerPath -ArgumentList "/S" -Verb RunAs -Wait -PassThru

            if ($process.ExitCode -eq 0) {
                Write-Host "Wireshark/TShark se ha intentado instalar con exito." -ForegroundColor Green
                
                $wiresharkInstallPath = ""
                if (Test-Path "${env:ProgramFiles}\Wireshark") {
                    $wiresharkInstallPath = "${env:ProgramFiles}\Wireshark"
                } elseif (Test-Path "${env:ProgramFiles(x86)}\Wireshark") {
                    $wiresharkInstallPath = "${env:ProgramFiles(x86)}\Wireshark"
                }

                if ($wiresharkInstallPath) {
                    Write-Host "Intentando añadir '$wiresharkInstallPath' al PATH del sistema..." -ForegroundColor Cyan
                    try {
                        $currentSystemPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
                        if ($currentSystemPath -notlike "*$wiresharkInstallPath**") {
                            [Environment]::SetEnvironmentVariable("Path", "$currentSystemPath;$wiresharkInstallPath", "Machine")
                            Write-Host "Ruta añadida al PATH del sistema." -ForegroundColor Green
                        } else {
                            Write-Host "La ruta ya existe en el PATH del sistema." -ForegroundColor Yellow
                        }

                        if ($env:Path -notlike "*$wiresharkInstallPath*") {
                            $env:Path += ";$wiresharkInstallPath"
                            Write-Host "Ruta añadida al PATH de la sesion actual." -ForegroundColor Green
                        }
                    } catch {
                        Write-Warning "No se pudo añadir la ruta al PATH del sistema. Asegurate de ejecutar PowerShell como administrador. Error: $($_.Exception.Message)"
                        if ($env:Path -notlike "*$wiresharkInstallPath*") {
                            $env:Path += ";$wiresharkInstallPath"
                            Write-Host "Ruta añadida al PATH de la sesion actual (no persistente)." -ForegroundColor Yellow
                        }
                    }
                } else {
                    Write-Warning "No se pudo determinar la ruta de instalacion de Wireshark. Es posible que TShark no se detecte automaticamente."
                }

                Write-Host "************************************************************************" -ForegroundColor Yellow
                Write-Host "  IMPORTANTE: Por favor, REINICIA tu consola de PowerShell (o tu PC)  " -ForegroundColor Yellow
                Write-Host "  para que TShark este disponible permanentemente en el PATH y el script " -ForegroundColor Yellow
                Write-Host "  funcione correctamente en futuras sesiones.                          " -ForegroundColor Yellow
                Write-Host "************************************************************************" -ForegroundColor Yellow
                Read-Host "Pulsa Enter para salir y reiniciar la consola."
                exit
            } else {
                Write-Error "La instalacion silenciosa de Wireshark/TShark fallo. Codigo de salida: $($process.ExitCode)"
                Write-Host "A veces, Npcap (requerido por Wireshark) puede necesitar interaccion manual o fallar en la instalacion silenciosa." -ForegroundColor Red
                Write-Host "Por favor, instala Wireshark manualmente desde: https://www.wireshark.org/download.html" -ForegroundColor Red
                Write-Host "Asegurate de que TShark se añade a tu PATH durante la instalacion." -ForegroundColor Red
                Read-Host "Pulsa Enter para salir."
                exit
            }
        } catch {
            Write-Error "Error al intentar descargar o instalar Wireshark: $($_.Exception.Message)"
            Write-Host "Por favor, descarga e instala Wireshark (que incluye TShark) manualmente." -ForegroundColor Red
            Write-Host "Descarga desde: https://www.wireshark.org/download.html" -ForegroundColor Red
            Write-Host "Asegurate de que TShark se añade a tu PATH durante la instalacion." -ForegroundColor Red
            Read-Host "Pulsa Enter para salir."
            exit
        } finally {
            if (Test-Path $installerPath) {
                Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

Install-TShark

Clear-Host

Write-Host "========================================" -ForegroundColor Blue
Write-Host "     Detector de Dispositivos LLDP      " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Este script utiliza TShark para capturar" -ForegroundColor White
Write-Host "y analizar el trafico LLDP, permitiendote" -ForegroundColor White
Write-Host "descubrir dispositivos de red conectados." -ForegroundColor White
Write-Host "Creador: Javier Lopez (JKG)             " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Blue
Write-Host "`n"

$tsharkInterfaces = tshark -D

Write-Host "Interfaces disponibles:`n"
$tsharkInterfaces | ForEach-Object { Write-Host $_ }

$interfazId = Read-Host "Introduce el numero de la interfaz ETHERNET (solo el numero)"

if (-not $interfazId -or $interfazId -notmatch '^\d+$') {
    Write-Error "Entrada invalida. Debe ser un numero de interfaz."
    Write-Host "Pulsa cualquier tecla para salir..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

Clear-Host
Write-Host "Capturando trafico LLDP en la interfaz $interfazId durante 30 segundos..." -ForegroundColor Yellow

$tsharkOutput = & tshark -i $interfazId `
    -a "duration:30" `
    -f "ether proto 0x88cc" `
    -T fields `
    -e lldp.chassis.id.mac `
    -e lldp.port.id `
    -e lldp.tlv.system.name `
    -e lldp.tlv.system.desc `
    -e lldp.mgn.addr.ip4 `
    -e lldp.ieee.802_1.port_vlan.id

$tsharkOutput -split "`n" | ForEach-Object {
    if ($_ -ne "") {
        $f = $_ -split "`t"
        
        Write-Host "`n====== Dispositivo LLDP ======" -ForegroundColor Green
        Write-Host "MAC:             $($f[0])" -ForegroundColor White
        Write-Host "Puerto:          $($f[1])" -ForegroundColor White
        Write-Host "Nombre del switch: $($f[2])" -ForegroundColor White
        Write-Host "Descripcion:     $($f[3])" -ForegroundColor White
        Write-Host "IP de gestion:   $($f[4])" -ForegroundColor White
        Write-Host "VLAN:            $($f[5])" -ForegroundColor White
    }
}

Write-Host "`nPulsa cualquier tecla para salir..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
