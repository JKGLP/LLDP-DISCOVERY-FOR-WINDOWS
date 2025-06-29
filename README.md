📡 Detector de Dispositivos LLDP para Infraestructuras de Red
Descripción

Este script de PowerShell fue creado a partir de una necesidad práctica como técnico informático: la de identificar de manera eficiente a qué switches y puertos están conectadas las rosetas de pared en edificios grandes, donde el rastreo manual de cables en el armario de comunicaciones resulta tedioso y consume mucho tiempo.

Su propósito principal es automatizar el descubrimiento de dispositivos de red vecinos que utilizan el protocolo LLDP (Link Layer Discovery Protocol), proporcionando información crucial como la dirección MAC del chasis, el puerto de conexión, el nombre del switch, su descripción, la IP de gestión y la VLAN asignada.
Características

    Verificación automática de TShark: Detecta si TShark (parte de Wireshark) está instalado y es accesible en el sistema. 🔎

    Instalación automática (intento): Si TShark no se encuentra, el script intenta descargar y ejecutar el instalador de Wireshark de forma silenciosa. ⬇️

    Añadir a PATH: Tras una instalación exitosa, el script intenta añadir automáticamente la ruta de TShark al PATH del sistema y de la sesión actual de PowerShell para facilitar su uso futuro. 🛣️

    Detección de privilegios de administrador: Asegura que el script se ejecute con los permisos necesarios, advirtiendo al usuario si no es así y solicitando que lo ejecute como administrador. 🔑

    Captura y análisis de tráfico LLDP: Utiliza TShark para capturar tráfico LLDP en una interfaz seleccionada durante 30 segundos. ⏱️

    Salida estructurada: Presenta la información de los dispositivos LLDP descubiertos de forma clara y legible en la consola. 📊

Requisitos

    Sistema Operativo Windows. 🖥️

    PowerShell (versión 5.1 o superior recomendada). 🚀

    Privilegios de administrador para la instalación de TShark y la modificación del PATH. 🛡️

Instalación y Uso

    Descargar el script: Clona este repositorio o descarga el archivo .ps1 directamente. 📥

    Ejecutar como administrador: Abre una consola de PowerShell como administrador. Puedes hacerlo buscando "PowerShell" en el menú Inicio, haciendo clic derecho y seleccionando "Ejecutar como administrador". 🖱️

    Navegar a la ruta del script: En la consola de PowerShell, usa el comando cd para ir a la carpeta donde guardaste el script. 📁

    cd C:\Ruta\Donde\Guardaste\ElScript

    Ejecutar el script: ▶️

    .\LLDP_DISCOVER_By_JKG.ps1

Comportamiento del script al inicio:

    Verificación de administrador: El script verificará si se ejecuta como administrador. Si no es así, te pedirá que lo hagas y se cerrará la sesión actual no elevada. ❌

    Verificación de TShark:

        Si TShark ya está instalado y accesible, el script continuará con la detección de interfaces. ✅

        Si TShark no está instalado, el script intentará descargarlo e instalarlo de forma silenciosa. Esto puede requerir aceptar un aviso de Control de Cuentas de Usuario (UAC). ⚠️

        IMPORTANTE: Si TShark se instala, es muy probable que necesites reiniciar tu consola de PowerShell (o incluso tu equipo) para que TShark esté disponible en el PATH y el script pueda usarlo en futuras sesiones. El script te lo indicará con un mensaje. 🔄

Después de la inicialización:

El script mostrará una lista de interfaces de red disponibles. Deberás introducir el número correspondiente a la interfaz ETHERNET por la que deseas capturar el tráfico LLDP. 📝

Luego, el script capturará el tráfico durante 30 segundos y mostrará la información de cualquier dispositivo LLDP detectado, como se describe en la sección de "Descripción". ✨
Créditos

Este script fue creado por Javier López (JKG). 👨‍💻
