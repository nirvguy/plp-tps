GHC=ghc
GCC=gcc

SOURCE=Tp.hs run.hs
TESTS_SOURCE=Tests-alu.hs Tp.hs

all: run tests check-tests

tests: $(TESTS_SOURCE)
	$(GHC) -O1 --make $(TESTS_SOURCE) -o $@

run: $(SOURCE)
	$(GHC) -O1 --make $(SOURCE) -o $@

run-tp: run
	./run

check-tests: tests
	./tests

clean:
	rm -rf *.o *.hi run tests

.PHONY: clean
