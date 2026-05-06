CXX=g++
CXXFLAGS=-O2 -Wall -std=c++17

all: main_prog

main_prog: main.o factorial.o
	$(CXX) $(CXXFLAGS) -o main main.o factorial.o

main.o: main.cpp
	$(CXX) $(CXXFLAGS) -c main.cpp

factorial.o: factorial.cpp
	$(CXX) $(CXXFLAGS) -c factorial.cpp

clean:
	rm -f *.o main_prog