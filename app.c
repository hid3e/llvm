#include "sim.h"

// двумерная теплопроводность

#define CELL 4
#define X_SIZE (SIM_X_SIZE / CELL)
#define Y_SIZE (SIM_Y_SIZE / CELL)

#define N 3              // сколько нагревателей
#define R 3              // полразмера нагревателя
#define BRD (R + 1)      // чтоб не вылез за край
#define HOT (255 * 256)  // температура нагревателя
#define COOL 64          // за шаг теряем 1/64 тепла

void drawCell(int x, int y, int argb) {
  for (int dy = 0; dy < CELL; dy++)
    for (int dx = 0; dx < CELL; dx++)
      simPutPixel(x * CELL + dx, y * CELL + dy, argb);
}

// чёрный -> красный -> жёлтый -> белый
int getColor(int t) {
  t = t / 256;
  int r = t * 3;
  int g = (t - 85) * 3;
  int b = (t - 170) * 3;
  if (r > 255)
    r = 255;
  if (g < 0)
    g = 0;
  if (g > 255)
    g = 255;
  if (b < 0)
    b = 0;
  return 0xFF000000 + (r << 16) + (g << 8) + b;
}

void drawField(int *field) {
  for (int y = 0; y < Y_SIZE; y++)
    for (int x = 0; x < X_SIZE; x++)
      drawCell(x, y, getColor(field[X_SIZE * y + x]));
}

// мешаем клетку с четырьмя соседями
void calcField(int *prev, int *next) {
  for (int y = 1; y < Y_SIZE - 1; y++)
    for (int x = 1; x < X_SIZE - 1; x++) {
      int t = (prev[X_SIZE * y + x] * 4 + prev[X_SIZE * (y - 1) + x] +
               prev[X_SIZE * (y + 1) + x] + prev[X_SIZE * y + x - 1] +
               prev[X_SIZE * y + x + 1]) /
              8;
      next[X_SIZE * y + x] = t - t / COOL;
    }
}

void setHot(int *field, int x, int y) {
  for (int dy = -R; dy <= R; dy++)
    for (int dx = -R; dx <= R; dx++)
      field[X_SIZE * (y + dy) + (x + dx)] = HOT;
}

void initSrc(int *sx, int *sy, int *vx, int *vy) {
  for (int i = 0; i < N; i++) {
    sx[i] = BRD + simRand() % (X_SIZE - 2 * BRD);
    sy[i] = BRD + simRand() % (Y_SIZE - 2 * BRD);
    vx[i] = 1 + simRand() % 3;
    vy[i] = 1 + simRand() % 3;
    if (simRand() % 2)
      vx[i] = -vx[i];
    if (simRand() % 2)
      vy[i] = -vy[i];
  }
}

// двигаем и отражаем от стенок
void moveSrc(int *sx, int *sy, int *vx, int *vy) {
  for (int i = 0; i < N; i++) {
    sx[i] += vx[i];
    sy[i] += vy[i];
    if (sx[i] < BRD) {
      sx[i] = BRD;
      vx[i] = -vx[i];
    }
    if (sx[i] > X_SIZE - 1 - BRD) {
      sx[i] = X_SIZE - 1 - BRD;
      vx[i] = -vx[i];
    }
    if (sy[i] < BRD) {
      sy[i] = BRD;
      vy[i] = -vy[i];
    }
    if (sy[i] > Y_SIZE - 1 - BRD) {
      sy[i] = Y_SIZE - 1 - BRD;
      vy[i] = -vy[i];
    }
  }
}

void app(void) {
  int f1[Y_SIZE * X_SIZE] = {};
  int f2[Y_SIZE * X_SIZE] = {};
  int sx[N] = {};
  int sy[N] = {};
  int vx[N] = {};
  int vy[N] = {};
  int *prev = f1;
  int *next = f2;
  initSrc(sx, sy, vx, vy);
  while (1) {
    for (int i = 0; i < N; i++)
      setHot(prev, sx[i], sy[i]);
    drawField(prev);
    simFlush();
    calcField(prev, next);
    moveSrc(sx, sy, vx, vy);
    int *tmp = prev;
    prev = next;
    next = tmp;
  }
}
