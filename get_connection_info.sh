#!/bin/bash

# Script para mostrar información de conexión VNC

echo "🔗 INFORMACIÓN DE CONEXIÓN VNC"
echo "================================"
echo

# Obtener IP del Codespace
IP=$(hostname -I | awk '{print $1}')
echo "📱 Para conectar desde tu celular:"
echo "   IP: $IP"
echo "   Puerto: 5900"
echo "   Dirección completa: $IP:5900"
echo

# Verificar si los servicios están corriendo
echo "🔧 Estado de servicios:"
if pgrep -f "Xvfb :1" > /dev/null; then
    echo "   ✅ Servidor X virtual (Xvfb) - CORRIENDO"
else
    echo "   ❌ Servidor X virtual (Xvfb) - NO CORRIENDO"
fi

if pgrep -f "x11vnc" > /dev/null; then
    echo "   ✅ Servidor VNC - CORRIENDO"
else
    echo "   ❌ Servidor VNC - NO CORRIENDO"
fi

echo
echo "📲 App recomendada: VNC Viewer (RealVNC)"
echo "🎮 Para ejecutar juego: ./run_game.sh"
echo "================================"
