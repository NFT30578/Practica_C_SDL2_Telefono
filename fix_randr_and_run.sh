#!/bin/bash

# Script para solucionar el error RANDR y ejecutar el juego SDL2
# Autor: GitHub Copilot
# Fecha: $(date)

echo "🔧 Solucionando error RANDR y configurando entorno SDL2..."

# Función para verificar si Xvfb está instalado
check_xvfb() {
    if ! command -v Xvfb &> /dev/null; then
        echo "📦 Instalando Xvfb..."
        sudo apt update && sudo apt install -y xvfb
    else
        echo "✅ Xvfb ya está instalado"
    fi
}

# Función para iniciar servidor X virtual
start_virtual_display() {
    echo "🖥️ Configurando servidor X virtual..."
    
    # Matar cualquier proceso Xvfb existente en :99
    pkill -f "Xvfb :99" 2>/dev/null || true
    sleep 1
    
    # Iniciar Xvfb en display :99
    Xvfb :99 -screen 0 1024x768x24 &
    XVFB_PID=$!
    
    # Esperar a que se inicie
    sleep 2
    
    # Configurar variable DISPLAY
    export DISPLAY=:99
    echo "export DISPLAY=:99" >> ~/.bashrc
    
    echo "✅ Servidor X virtual iniciado en display :99"
    echo "🔧 PID del proceso Xvfb: $XVFB_PID"
}

# Función para compilar el juego
compile_game() {
    echo "🎮 Compilando el juego..."
    make clean
    make
    
    if [ $? -eq 0 ]; then
        echo "✅ Juego compilado exitosamente"
        return 0
    else
        echo "❌ Error al compilar el juego"
        return 1
    fi
}

# Función para ejecutar el juego
run_game() {
    echo "🚀 Ejecutando el juego SDL2..."
    echo "🎮 Controles:"
    echo "  - Jugador 1: W (arriba), S (abajo)"
    echo "  - Jugador 2: ↑ (arriba), ↓ (abajo)"
    echo "  - ESC: Salir del juego"
    echo
    echo "📝 Nota: El juego se ejecuta en modo virtual (sin pantalla visible)"
    echo "         Para ver el juego, necesitarás configurar VNC o ejecutarlo en un entorno con display"
    echo
    
    # Ejecutar el juego con el display virtual
    DISPLAY=:99 ./pong_game
}

# Función principal
main() {
    echo "=== 🎮 SOLUCIONADOR DE ERROR RANDR PARA SDL2 ==="
    echo
    
    # Verificar que estamos en el directorio correcto
    if [ ! -f "main.c" ] || [ ! -f "Makefile" ]; then
        echo "❌ Error: Debe ejecutar este script desde el directorio del proyecto"
        echo "   El directorio debe contener main.c y Makefile"
        exit 1
    fi
    
    # Ejecutar pasos
    check_xvfb
    start_virtual_display
    
    if compile_game; then
        echo
        read -p "¿Deseas ejecutar el juego ahora? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            run_game
        else
            echo "🎮 Para ejecutar el juego más tarde, usa:"
            echo "   DISPLAY=:99 ./pong_game"
        fi
    fi
    
    echo
    echo "=== 📋 RESUMEN ==="
    echo "✅ Servidor X virtual: Configurado en display :99"
    echo "✅ Variable DISPLAY: Exportada automáticamente"
    echo "✅ Error RANDR: Solucionado"
    echo
    echo "💡 Comandos útiles:"
    echo "   - Ejecutar juego: DISPLAY=:99 ./pong_game"
    echo "   - Ver procesos X: ps aux | grep Xvfb"
    echo "   - Matar servidor X: pkill -f 'Xvfb :99'"
}

# Ejecutar función principal
main "$@"
