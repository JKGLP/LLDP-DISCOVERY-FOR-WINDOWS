📡 Detector de Dispositivos LLDP para Infraestructuras de Red
Introducción

Este script de PowerShell, LLDP_DISCOVER_By_JKG.ps1, nace de la necesidad práctica de un técnico informático. Su objetivo es simplificar la tediosa tarea de identificar a qué switches y puertos están conectadas las rosetas de pared en edificios grandes, evitando el rastreo manual de cables.

Automatiza el descubrimiento de dispositivos de red vecinos que utilizan el protocolo LLDP (Link Layer Discovery Protocol), proporcionando información vital de manera rápida y eficiente.
🌟 Características Principales

    Verificación y Autoinstalación de TShark: Detecta si TShark (esencial para el análisis de red) está instalado. Si no, intenta descargarlo e instalarlo silenciosamente (requiere permisos de administrador). 🔎⬇️

    Gestión del PATH: Después de una instalación exitosa, el script intenta añadir automáticamente la ruta de TShark al PATH del sistema para su uso futuro. 🛣️

    Validación de Administrador: Asegura que el script se ejecute con los permisos elevados necesarios, indicando al usuario cómo proceder si no es así. 🔑

    Análisis LLDP Automático: Captura y analiza el tráfico LLDP en una interfaz seleccionada durante 30 segundos, extrayendo datos clave. ⏱️

    Resultados Claros: Muestra la información de los dispositivos descubiertos de forma estructurada y legible en la consola. 📊

⚙️ Requisitos

    Sistema Operativo Windows. 🖥️

    PowerShell (versión 5.1 o superior recomendada). 🚀

    Privilegios de Administrador: Imprescindibles para la instalación de TShark y las modificaciones del PATH. 🛡️

🚀 Instalación y Uso

    Descargar: Obtén el script LLDP_DISCOVER_By_JKG.ps1 clonando este repositorio o descargando el archivo directamente. 📥

    Ejecutar como Administrador:

        Abre una consola de PowerShell con privilegios de administrador. (Busca "PowerShell" en el menú Inicio, clic derecho > "Ejecutar como administrador"). 🖱️

        Importante: Si no lo ejecutas como administrador inicialmente, el script te lo indicará y se cerrará la sesión actual no elevada, esperando que lo reinicies correctamente. ❌

    Navegar a la Ruta del Script:

        En la consola de PowerShell abierta como administrador, ve a la carpeta donde guardaste el script:

        cd C:\Ruta\Donde\Guardaste\ElScript

    Iniciar el Script:

        Ejecuta el script con el siguiente comando:

        .\LLDP_DISCOVER_By_JKG.ps1

Comportamiento al Inicio:

    Primer Lanzamiento / TShark no Encontrado: El script intentará la instalación de TShark y te pedirá confirmación de UAC si es necesario.

    Post-Instalación: Si TShark se instala, es muy probable que necesites reiniciar tu consola de PowerShell (o incluso tu equipo). Esto asegura que TShark esté permanentemente disponible en el PATH y el script funcione en futuras sesiones. El script te lo recordará. 🔄

Uso Tras la Inicialización:

    El script listará las interfaces de red disponibles.

    Deberás introducir el número de la interfaz ETHERNET para iniciar la captura de tráfico LLDP. 📝

    Después de 30 segundos, verás los detalles de los dispositivos LLDP detectados. ✨

👨‍💻 Créditos

Script creado por Javier López (JKG).
