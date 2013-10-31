

# language settings
CXXFLAGS += -std=c++11 -pedantic -fno-exceptions -fno-rtti -pedantic

ifeq (${shell uname}, Darwin)
	# OS X is weird
	CXX = clang++
	CXXFLAGS += -stdlib=libc++
endif

# warnings
CXXFLAGS += -Wall -Wextra -Weffc++
# disabled warnings (we could use attributes in the code to indicate these...)
CXXFLAGS += \
	-Wno-unused-function \
	-Wno-unused-parameter \
	-Wno-missing-field-initializers


# optimization
CXXFLAGS += -O3

# root directories
Src  := src
Test := test
Out  := build

# Object directories
Obj      := ${Out}/.obj
ObjSrc   := ${Obj}/src
ObjTest  := ${Obj}/test
ObjGTest := ${ObjTest}/gtest


# Source file locations
libSources := \
	${Src}/SmallVector.cpp

gtestSources := \
	${Test}/gtest/gtest-all.cpp \
	${Test}/gtest/gtest_main.cpp

testSources := \
	${Test}/SmallVector.cpp \
	${Test}/Casting.cpp

# Object file locations
gtestObjects  := ${gtestSources:%.cpp=${Obj}/%.o}
libObjects    := ${libSources:%.cpp=${Obj}/%.o}
testObjects   := ${testSources:%.cpp=${Obj}/%.o}


CXXFLAGS += -I${Src} -I${Test}

.PHONY: all
all: test

.PHONY: out
out:
	@mkdir -p ${ObjSrc}
	@mkdir -p ${ObjTest}
	@mkdir -p ${ObjGTest}

.PHONY: test
test: out ${Out}/test-runner

.PHONY: run-tests
run-tests: test
	./${Out}/test-runner

.PHONY: clean
clean:
	@rm -rf ${Out}

${Out}/test-runner: ${gtestObjects} ${libObjects} ${testObjects}
	@echo "Linking $@"
	@${CXX} ${CXXFLAGS} -o $@ $^

${Obj}/%.o: %.cpp
	@echo "Compiling $<"
	@${CXX} ${CXXFLAGS} -c -o $@ $<

