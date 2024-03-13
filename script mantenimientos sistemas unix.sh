#!/bin/bash

# Función para imprimir el menú principal
function print_menu {
  echo "1. Verificar el estado del sistema"
  echo "2. Verificar errores en los logs del sistema"
  echo "3. Verificar drivers instalados"
  echo "4. Realizar mantenimiento del sistema"
  echo "5. Salir"
}

# Función para verificar el estado del sistema
function check_system_status {
  echo "Información del sistema:"
  echo "======================="
  echo "Hostname: $(hostname)"
  echo "Sistema operativo: $(uname -a)"
  echo "Uptime: $(uptime)"
  echo "Procesos en ejecución: $(ps -aux | wc -l)"
  echo "Memoria libre: $(free -h | grep Mem | awk '{print $4}')"
  echo "Espacio libre en disco: $(df -h / | awk '{print $4}' | sed -n 2p)"
}

# Función para verificar errores en los logs del sistema
function check_system_logs {
  echo "Últimos 10 errores registrados en los logs del sistema:"
  echo "======================================================"
  tail /var/log/syslog | grep -i error | head -n 10
}

# Función para verificar los drivers instalados
function check_installed_drivers {
  echo "Drivers instalados:"
  echo "==================="
  dpkg -l | grep linux-image | awk '{print $2}'
}

# Función para realizar mantenimiento del sistema
function perform_system_maintenance {
  echo "Realizando mantenimiento del sistema..."
  echo "======================================"
  # Actualizar repositorios
  sudo apt-get update
  # Actualizar paquetes del sistema
  sudo apt-get upgrade -y
  # Limpiar caché de paquetes
  sudo apt-get autoclean -y
  # Eliminar paquetes no necesarios
  sudo apt-get autoremove -y
  echo "Mantenimiento del sistema completado."
}

# Ciclo para mantener el menú principal disponible hasta que el usuario decida salir
while true; do
  echo ""
  print_menu
  echo ""
  read -p "Seleccione una opción [1-5]: " option
  case $option in
    1)
      check_system_status
      ;;
    2)
      check_system_logs
      ;;
    3)
      check_installed_drivers
      ;;
    4)
      perform_system_maintenance
      ;;
    5)
      echo "Saliendo del programa..."
      break
      ;;
    *)
      echo "Opción inválida. Por favor seleccione una opción válida."
      ;;
  esac
done