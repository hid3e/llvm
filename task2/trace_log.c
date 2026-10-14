#include <stdio.h>
#include <stdlib.h>

#define MAX_RECORDS 40000000

static long Count = 0;

void traceLogger(char *user, char *operand) {
  printf("%s <- %s\n", user, operand);
  if (++Count >= MAX_RECORDS) {
    fflush(stdout);
    exit(0);
  }
}
