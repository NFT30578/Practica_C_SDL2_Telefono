# 🎮 Proyecto SDL2 para Desarrollo en Celular

Este proyecto te permite desarrollar juegos en C con SDL2 y ejecutarlos desde tu celular usando VNC o X11 forwarding.

## 🚀 Inicio Rápido

### 📱 **Para usar desde celular con GitHub Codespace:**

1. **Inicia tu Codespace desde el celular:**
   - Abre GitHub en tu navegador móvil
   - Ve a tu repositorio y inicia Codespace

2. **Configura el entorno gráfico:**
   ```bash
   # Configuración automática completa
   ./setup_mobile_dev.sh
   ```

3. **Descarga VNC Viewer en tu celular:**
   - App: **VNC Viewer** (RealVNC) - gratuita

4. **Conecta por VNC:**
   - Obtén la IP: `hostname -I`
   - Conecta a: `IP_DEL_CODESPACE:5900`

5. **Ejecuta el juego:**
   ```bash
   ./run_game.sh
   ```

### 🖥️ **Configuración manual (alternativa):**

```bash
# 1. Instalar dependencias
make install-deps

# 2. Configurar servidor X virtual + VNC
Xvfb :1 -screen 0 1024x768x24 &
x11vnc -display :1 -bg -nopw -listen 0.0.0.0 -xkb -many -shared -forever

# 3. Compilar el juego
make

# 4. Ejecutar el juego
export DISPLAY=:1 && ./pong_game
```

## 🛠️ Opciones de Configuración

### Opción 1: VNC Server (Recomendado)

**Ventajas:**
- Interfaz gráfica completa
- Fácil de configurar
- Compatible con la mayoría de apps móviles

**Configuración:**
```bash
# Instalar TightVNC
sudo apt install tightvncserver xfce4

# Iniciar servidor
vncserver :1 -geometry 1024x768

# Configurar display
export DISPLAY=:1
```

**Conexión desde celular:**
- App: VNC Viewer (RealVNC)
- Dirección: `IP_DEL_CODESPACE:5900`
- Ejemplo: `10.0.0.206:5900`

> **💡 Tip para Codespace:** La IP cambia cada vez que reinicias el Codespace. Usa `hostname -I` para obtener la IP actual.

### Opción 2: X11 Forwarding

**Ventajas:**
- Menor consumo de recursos
- Conexión directa SSH

**Configuración:**
```bash
# Conectar por SSH con X11
ssh -X usuario@servidor

# O para mayor compatibilidad
ssh -Y usuario@servidor
```

### Opción 3: Xvfb + VNC

**Ventajas:**
- No necesita entorno gráfico en el servidor
- Ideal para servidores sin GUI

**Configuración:**
```bash
# Iniciar servidor X virtual
Xvfb :1 -screen 0 1024x768x24 &

# Iniciar VNC
x11vnc -display :1 -bg -nopw
```

## 🎮 El Juego Incluido

El proyecto incluye un juego de **Pong** completo con:
- Física de pelota realista
- Controles responsivos
- Gráficos simples pero efectivos

**Controles:**
- Jugador 1: `W` (arriba), `S` (abajo)
- Jugador 2: `↑` (arriba), `↓` (abajo)
- `ESC`: Salir del juego

## 📱 Apps Recomendadas para Celular

### Android:
- **VNC Viewer** (RealVNC) - Gratis, muy estable
- **RVNC** - Buena para conexiones lentas
- **MultiVNC** - Muchas opciones de configuración

### iOS:
- **VNC Viewer** (RealVNC) - Versión iOS
- **Screens** - Interface más pulida (de pago)

## 🔧 Estructura del Proyecto

```
Practica_C_SDL2_Telefono/
├── main.c                 # Código principal del juego
├── Makefile              # Compilación y tareas
├── setup_mobile_dev.sh   # Script de configuración automática
├── run_game.sh           # Script para ejecutar el juego fácilmente
└── README.md             # Este archivo
```

## 📋 Comandos del Makefile

```bash
make                    # Compilar el juego
make run               # Ejecutar el juego
make install-deps      # Instalar dependencias SDL2
make setup-vnc         # Configurar servidor VNC
make setup-x11         # Configurar X11 forwarding
make setup-xvfb        # Configurar Xvfb + VNC
make test-sdl          # Probar instalación de SDL2
make clean             # Limpiar archivos compilados
make info              # Mostrar información del sistema
```

## 🌐 Configuración de Red

### 📱 **Para GitHub Codespace:**
```bash
# Obtener IP actual del Codespace
hostname -I

# La IP cambia cada reinicio, siempre verifica con este comando
```

### Para conexión local (WiFi):
```bash
# Encontrar tu IP
ip addr show

# O usar hostname
hostname -I
```

### Para conexión remota (Internet):
1. Configura port forwarding en tu router
2. Usa un servicio como ngrok para túneles
3. Configura VPN para acceso seguro

## 🚨 Solución de Problemas

### 📱 **Problemas específicos de Codespace:**

**No puedo conectar por VNC:**
```bash
# Verificar que los procesos estén corriendo
ps aux | grep Xvfb
ps aux | grep x11vnc

# Reiniciar si es necesario
./setup_mobile_dev.sh
```

**La IP cambió:**
```bash
# Siempre verificar la IP actual
hostname -I
```

**El juego no se ve:**
```bash
# Verificar display
echo $DISPLAY
export DISPLAY=:1
```

### 🖥️ **Problemas generales:**

### Error: "cannot connect to X server"
```bash
export DISPLAY=:1
# O el display que corresponda
```

### Error: "SDL could not initialize"
```bash
# Verificar que SDL2 esté instalado
make test-sdl

# Reinstalar si es necesario
make install-deps
```

### VNC no se conecta
```bash
# Verificar que el servidor esté corriendo
ps aux | grep vnc

# Reiniciar servidor VNC
vncserver -kill :1
vncserver :1 -geometry 1024x768
```

### Rendimiento lento
- Reducir resolución: `-geometry 800x600`
- Cambiar profundidad de color: `-depth 16`
- Usar compresión en el cliente VNC

## 🎯 Próximos Pasos

1. **Ampliar el juego:**
   - Añadir puntuación
   - Efectos de sonido
   - Menús
   - IA para jugador individual

2. **Optimizar entorno:**
   - Scripts de backup automático
   - Sincronización con Git
   - Entorno de desarrollo más completo

3. **Proyectos adicionales:**
   - Juego de plataformas
   - Puzzle game
   - Arcade shooter

## 📚 Recursos Adicionales

- [SDL2 Documentation](https://wiki.libsdl.org/SDL2/FrontPage)
- [SDL2 Tutorials](https://lazyfoo.net/tutorials/SDL/)
- [C Programming Guide](https://www.learn-c.org/)

## 🤝 Contribuciones

Si tienes ideas para mejorar este setup o encontraste algún bug, ¡no dudes en contribuir!

---

¡Disfruta desarrollando juegos desde tu celular! 🎮📱
