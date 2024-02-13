CXX = g++
CC = gcc
CXXFLAGS = -ggdb -g -Wall -O2 
CFLAGS = -ggdb -Wall 
CXXSRCS = matmul-driver.cpp 
ASRCS1 = matmul.s intmul.s intadd.s 
MMOBJS = matmul-driver.o matmul.o intmul.o intadd.o 
ASRCS2 = matmul-mul.s
ASRCSC = matmul-mul.c
MMMULOBJS = matmul-driver.o matmul-mul.o
BIN1 = mm
BIN2 = mmmul
BIN3 = mmmul-c
BIN4 = mmmul-cO2

all: mm mmmul mmmul-c mmmul-cO2

mm: $(ASRCS1) $(CXXSRCS)
	$(CXX) $(CXXFLAGS) -c $(CXXSRCS)
	$(CC) $(CFLAGS) -c $(ASRCS1)
	$(CC) $(CFLAGS) -o $(BIN1) $(MMOBJS)

mmmul: $(CXXSRCS) $(ASRCS2)
	$(CXX) $(CXXFLAGS) -c $(CXXSRCS)
	$(CC) $(CFLAGS) -c $(ASRCS2)
	$(CC) $(CFLAGS) -o $(BIN2) $(MMMULOBJS)

mmmul-c: $(CXXSRCS) $(ASRCSC)
	$(CXX) $(CXXFLAGS) -c $(CXXSRCS)
	$(CC) $(CFLAGS) -c $(ASRCSC)
	$(CC) $(CFLAGS) -o $(BIN3) $(MMMULOBJS)

mmmul-cO2: $(CXXSRCS) $(ASRCSC)
	$(CXX) $(CXXFLAGS) -c $(CXXSRCS)
	$(CC) $(CFLAGS) -O2 -c $(ASRCSC)
	$(CC) $(CFLAGS) -o $(BIN4) $(MMMULOBJS)

clean:
	rm -f *.o $(BIN1) $(BIN2) $(BIN3) $(BIN4)
