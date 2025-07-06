#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdbool.h>

// Constantes del juego
#define WINDOW_WIDTH 800
#define WINDOW_HEIGHT 600
#define BALL_SIZE 20
#define PADDLE_WIDTH 15
#define PADDLE_HEIGHT 100
#define BALL_SPEED 5

// Estructura para la pelota
typedef struct {
    float x, y;
    float vel_x, vel_y;
} Ball;

// Estructura para las paletas
typedef struct {
    float x, y;
} Paddle;

int main(int argc, char* argv[]) {
    // Inicializar SDL
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        printf("Error al inicializar SDL: %s\n", SDL_GetError());
        return 1;
    }

    // Crear ventana
    SDL_Window* window = SDL_CreateWindow(
        "Pong Game - SDL2",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        SDL_WINDOW_SHOWN
    );

    if (!window) {
        printf("Error al crear ventana: %s\n", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    // Crear renderer
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    if (!renderer) {
        printf("Error al crear renderer: %s\n", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    // Inicializar objetos del juego
    Ball ball = {WINDOW_WIDTH/2, WINDOW_HEIGHT/2, BALL_SPEED, BALL_SPEED};
    Paddle player1 = {50, WINDOW_HEIGHT/2 - PADDLE_HEIGHT/2};
    Paddle player2 = {WINDOW_WIDTH - 50 - PADDLE_WIDTH, WINDOW_HEIGHT/2 - PADDLE_HEIGHT/2};

    // Variables del juego
    bool running = true;
    SDL_Event event;
    const Uint8* keystate = SDL_GetKeyboardState(NULL);

    printf("¡Juego iniciado! Usa W/S para la paleta izquierda, UP/DOWN para la derecha\n");
    printf("Presiona ESC para salir\n");

    // Bucle principal del juego
    while (running) {
        // Manejar eventos
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) {
                running = false;
            }
            if (event.type == SDL_KEYDOWN) {
                if (event.key.keysym.sym == SDLK_ESCAPE) {
                    running = false;
                }
            }
        }

        // Controles de jugadores
        if (keystate[SDL_SCANCODE_W] && player1.y > 0) {
            player1.y -= 5;
        }
        if (keystate[SDL_SCANCODE_S] && player1.y < WINDOW_HEIGHT - PADDLE_HEIGHT) {
            player1.y += 5;
        }
        if (keystate[SDL_SCANCODE_UP] && player2.y > 0) {
            player2.y -= 5;
        }
        if (keystate[SDL_SCANCODE_DOWN] && player2.y < WINDOW_HEIGHT - PADDLE_HEIGHT) {
            player2.y += 5;
        }

        // Actualizar posición de la pelota
        ball.x += ball.vel_x;
        ball.y += ball.vel_y;

        // Colisiones con bordes superior e inferior
        if (ball.y <= 0 || ball.y >= WINDOW_HEIGHT - BALL_SIZE) {
            ball.vel_y = -ball.vel_y;
        }

        // Colisiones con paletas
        if (ball.x <= player1.x + PADDLE_WIDTH && 
            ball.y >= player1.y && 
            ball.y <= player1.y + PADDLE_HEIGHT) {
            ball.vel_x = -ball.vel_x;
            ball.x = player1.x + PADDLE_WIDTH;
        }

        if (ball.x + BALL_SIZE >= player2.x && 
            ball.y >= player2.y && 
            ball.y <= player2.y + PADDLE_HEIGHT) {
            ball.vel_x = -ball.vel_x;
            ball.x = player2.x - BALL_SIZE;
        }

        // Reiniciar pelota si sale de la pantalla
        if (ball.x < 0 || ball.x > WINDOW_WIDTH) {
            ball.x = WINDOW_WIDTH/2;
            ball.y = WINDOW_HEIGHT/2;
            ball.vel_x = (ball.x < WINDOW_WIDTH/2) ? BALL_SPEED : -BALL_SPEED;
        }

        // Renderizar
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255); // Fondo negro
        SDL_RenderClear(renderer);

        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255); // Blanco

        // Dibujar paletas
        SDL_Rect paddle1_rect = {player1.x, player1.y, PADDLE_WIDTH, PADDLE_HEIGHT};
        SDL_Rect paddle2_rect = {player2.x, player2.y, PADDLE_WIDTH, PADDLE_HEIGHT};
        SDL_RenderFillRect(renderer, &paddle1_rect);
        SDL_RenderFillRect(renderer, &paddle2_rect);

        // Dibujar pelota
        SDL_Rect ball_rect = {ball.x, ball.y, BALL_SIZE, BALL_SIZE};
        SDL_RenderFillRect(renderer, &ball_rect);

        // Dibujar línea central
        for (int i = 0; i < WINDOW_HEIGHT; i += 20) {
            SDL_Rect dash = {WINDOW_WIDTH/2 - 2, i, 4, 10};
            SDL_RenderFillRect(renderer, &dash);
        }

        SDL_RenderPresent(renderer);
        SDL_Delay(16); // ~60 FPS
    }

    // Limpiar recursos
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    printf("¡Gracias por jugar!\n");
    return 0;
}

