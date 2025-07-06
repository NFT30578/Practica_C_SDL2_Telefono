# Makefile para el proyecto SDL2
CC = gcc
CFLAGS = -Wall -Wextra -std=c99
LDFLAGS = -lSDL2 -lm

# Nombres
TARGET = pong_game
SOURCE = main.c

# Detectar el sistema para configuración del display
UNAME := $(shell uname)

# Regla principal
all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) -o $(TARGET) $(SOURCE) $(LDFLAGS)

# Regla para ejecutar el juego
run: $(TARGET)
	@echo "Iniciando el juego..."
	@echo "Asegúrate de tener configurado el display correctamente"
	@if [ -z "$$DISPLAY" ]; then \
		echo "ADVERTENCIA: Variable DISPLAY no configurada"; \
		echo "Para usar con VNC, ejecuta: export DISPLAY=:1"; \
		echo "Para usar con X11 forwarding: export DISPLAY=:10.0"; \
	fi
	./$(TARGET)

# Instalar dependencias en sistemas basados en Debian/Ubuntu
install-deps:
	@echo "Instalando dependencias de SDL2..."
	sudo apt update
	sudo apt install -y libsdl2-dev build-essential

# Configurar servidor VNC (opción 1)
setup-vnc:
	@echo "Configurando servidor VNC..."
	sudo apt update
	sudo apt install -y tightvncserver xfce4 xfce4-goodies
	@echo "Para iniciar VNC:"
	@echo "1. Ejecuta: vncserver :1 -geometry 1024x768"
	@echo "2. Configura una contraseña cuando te la pida"
	@echo "3. En tu celular, conecta a IP_SERVIDOR:5901"
	@echo "4. Exporta el display: export DISPLAY=:1"

# Configurar X11 forwarding (opción 2)
setup-x11:
	@echo "Configurando X11 forwarding..."
	sudo apt update
	sudo apt install -y xauth xorg
	@echo "Para usar X11 forwarding:"
	@echo "1. Conecta por SSH con: ssh -X usuario@servidor"
	@echo "2. O usa: ssh -Y usuario@servidor (menos seguro pero más compatible)"
	@echo "3. Exporta el display si es necesario: export DISPLAY=localhost:10.0"

# Configurar servidor X virtual (opción 3)
setup-xvfb:
	@echo "Configurando servidor X virtual..."
	sudo apt update
	sudo apt install -y xvfb x11vnc
	@echo "Para usar Xvfb + VNC:"
	@echo "1. Inicia Xvfb: Xvfb :1 -screen 0 1024x768x24 &"
	@echo "2. Inicia VNC: x11vnc -display :1 -bg -nopw -listen localhost -xkb"
	@echo "3. Conecta por SSH tunnel: ssh -L 5900:localhost:5900 usuario@servidor"
	@echo "4. En tu celular, conecta a localhost:5900"

# Limpiar archivos compilados
clean:
	rm -f $(TARGET)

# Test básico para verificar SDL2
test-sdl:
	@echo "Probando instalación de SDL2..."
	@$(CC) -x c -o test_sdl - $(LDFLAGS) << 'EOF'
	#include <SDL2/SDL.h>
	#include <stdio.h>
	int main() {
		if (SDL_Init(SDL_INIT_VIDEO) < 0) {
			printf("Error: %s\n", SDL_GetError());
			return 1;
		}
		printf("SDL2 instalado correctamente!\n");
		SDL_Quit();
		return 0;
	}
	EOF
	@./test_sdl
	@rm -f test_sdl

# Mostrar información del sistema
info:
	@echo "=== Información del Sistema ==="
	@echo "OS: $(UNAME)"
	@echo "Display actual: $$DISPLAY"
	@echo "Usuario: $$USER"
	@echo "Directorio: $$(pwd)"
	@echo "================================"

.PHONY: all run install-deps setup-vnc setup-x11 setup-xvfb clean test-sdl info
