#!/bin/bash

# Script para ejecutar el juego Pong con display configurado

echo "🎮 Iniciando Pong Game..."
echo "📱 Asegúrate de estar conectado por VNC a: 10.0.0.206:5900"
echo

# Configurar display
export DISPLAY=:1

# Verificar que el servidor X esté corriendo
if ! xdpyinfo -display :1 >/dev/null 2>&1; then
    echo "❌ Error: Servidor X no está corriendo en :1"
    echo "🔧 Ejecutando configurador automático..."
    ./setup_mobile_dev.sh
    exit 1
fi

echo "🎮 Controles del juego:"
echo "  - Jugador 1 (izquierda): W (arriba), S (abajo)"
echo "  - Jugador 2 (derecha): ↑ (arriba), ↓ (abajo)"
echo "  - ESC: Salir del juego"
echo
echo "🚀 ¡Iniciando juego!"
echo

# Ejecutar el juego
./pong_game
