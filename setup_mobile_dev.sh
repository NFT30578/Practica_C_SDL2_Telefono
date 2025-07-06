#!/bin/bash

# Script para configurar y ejecutar el juego con VNC
# Este script automatiza el proceso de configuración

echo "=== Configurador de Entorno SDL2 para Celular ==="
echo

# Función para instalar dependencias
install_dependencies() {
    echo "📦 Instalando dependencias..."
    sudo apt update
    sudo apt install -y libsdl2-dev build-essential tightvncserver xfce4 xfce4-goodies
    echo "✅ Dependencias instaladas"
}

# Función para configurar VNC
setup_vnc_server() {
    echo "🖥️  Configurando servidor VNC..."
    
    # Matar cualquier servidor VNC existente
    vncserver -kill :1 2>/dev/null || true
    
    # Configurar archivo de startup de VNC
    mkdir -p ~/.vnc
    cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
    chmod +x ~/.vnc/xstartup
    
    echo "🔧 Iniciando servidor VNC en display :1..."
    vncserver :1 -geometry 1024x768 -depth 24
    
    if [ $? -eq 0 ]; then
        echo "✅ Servidor VNC iniciado exitosamente"
        echo "📱 Conecta desde tu celular a: $(hostname -I | awk '{print $1}'):5901"
        echo "🔧 Configurando variable DISPLAY..."
        export DISPLAY=:1
        echo "export DISPLAY=:1" >> ~/.bashrc
    else
        echo "❌ Error al iniciar servidor VNC"
        return 1
    fi
}

# Función para configurar Xvfb + VNC (alternativa)
setup_xvfb_vnc() {
    echo "🖥️  Configurando Xvfb + VNC..."
    sudo apt install -y xvfb x11vnc
    
    # Iniciar Xvfb
    echo "🔧 Iniciando servidor X virtual..."
    Xvfb :1 -screen 0 1024x768x24 &
    XVFB_PID=$!
    
    sleep 2
    
    # Iniciar VNC server conectado a Xvfb
    echo "🔧 Iniciando VNC server..."
    x11vnc -display :1 -bg -nopw -listen 0.0.0.0 -xkb -many -shared
    
    export DISPLAY=:1
    echo "export DISPLAY=:1" >> ~/.bashrc
    
    echo "✅ Xvfb + VNC configurado"
    echo "📱 Conecta desde tu celular a: $(hostname -I | awk '{print $1}'):5900"
}

# Función para compilar el juego
compile_game() {
    echo "🎮 Compilando el juego..."
    make clean
    make
    
    if [ $? -eq 0 ]; then
        echo "✅ Juego compilado exitosamente"
    else
        echo "❌ Error al compilar el juego"
        return 1
    fi
}

# Función para ejecutar el juego
run_game() {
    echo "🚀 Ejecutando el juego..."
    if [ -z "$DISPLAY" ]; then
        export DISPLAY=:1
    fi
    
    echo "🎮 Controles del juego:"
    echo "  - Jugador 1: W (arriba), S (abajo)"
    echo "  - Jugador 2: ↑ (arriba), ↓ (abajo)"
    echo "  - ESC: Salir"
    echo
    
    ./pong_game
}

# Función para mostrar información de conexión
show_connection_info() {
    echo
    echo "=== 📱 INFORMACIÓN DE CONEXIÓN ==="
    echo "IP del servidor: $(hostname -I | awk '{print $1}')"
    echo "Puerto VNC: 5901 (para TightVNC) o 5900 (para x11vnc)"
    echo
    echo "Apps recomendadas para Android:"
    echo "  - VNC Viewer (RealVNC)"
    echo "  - RVNC"
    echo "  - MultiVNC"
    echo
    echo "Apps recomendadas para iOS:"
    echo "  - VNC Viewer (RealVNC)"
    echo "  - Screens"
    echo "=================================="
}

# Menú principal
main_menu() {
    while true; do
        echo
        echo "=== 🎮 MENÚ PRINCIPAL ==="
        echo "1. 📦 Instalar dependencias"
        echo "2. 🖥️  Configurar VNC (TightVNC)"
        echo "3. 🖥️  Configurar Xvfb + VNC (alternativa)"
        echo "4. 🎮 Compilar juego"
        echo "5. 🚀 Ejecutar juego"
        echo "6. 📱 Mostrar info de conexión"
        echo "7. 🔄 Setup completo (1+2+4)"
        echo "8. ❌ Salir"
        echo
        read -p "Selecciona una opción [1-8]: " choice
        
        case $choice in
            1)
                install_dependencies
                ;;
            2)
                setup_vnc_server
                ;;
            3)
                setup_xvfb_vnc
                ;;
            4)
                compile_game
                ;;
            5)
                run_game
                ;;
            6)
                show_connection_info
                ;;
            7)
                install_dependencies && setup_vnc_server && compile_game
                ;;
            8)
                echo "👋 ¡Hasta luego!"
                break
                ;;
            *)
                echo "❌ Opción inválida"
                ;;
        esac
    done
}

# Ejecutar menú principal
main_menu
