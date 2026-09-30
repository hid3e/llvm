all: app app-opt.ll

app: app.c sim.c start.c
	clang $^ -lSDL2 -o $@ -Os

app-opt.ll: app.c
	clang -emit-llvm -S $^ -o $@ -Os

clean:
	rm -f app app-opt.ll

.PHONY: all clean
