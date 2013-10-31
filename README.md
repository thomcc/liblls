# liblls

`liblls` is a collection of utilities extracted from llvm's codebase that meet the following requirements:

- Generally useful for high performance programs.
- Don't have similar/identical alternatives in popular libraries (e.g. the standard library or boost).

Currently this includes the following modules (where module means header file or header-implementation pair).

- `SmallVector<T, N>`, in `src/SmallVector.h` and `src/SmallVector.cpp`
- llvm's custom casting and RTTI implementation (`dyn_cast`, `isa`, etc.), in `src/Casting.h`

Each of these modules is totally standalone and has no dependancies outside of the standard library.


## Usage

The best way to use liblls is to pick which files you want from `src`, and drop them into your project. This is the intended way to use liblls, and is also the simplest.

You could also compile it as a static library and link with it, but even this is probably overdoing it, as the library would consist of a single object file containing a single function.

For documentation, consult llvm (the changes I've made were minimal), or read the comments in the code. Ambitious users could generate doxygen documentation from them, but it would be nearly identical to the existing llvm documentation.

### Caveats

Before you use `liblls`, there are a few things you should note.

- `liblls` does not provide any exception-safety guarantee. This is due to the fact that LLVM is compiled, by default, with exceptions turned off. This only makes a difference for `SmallVector.{h,cpp}`, so if you only want `Casting.h`

  While eventually I'd like to add a strong exception-safety guarantee to SmallVector, I have not done so yet. If this matters to you, use std::vector.

This is not an issue for the code in `Casting.h`.

### Requirements

LibLLS expects a minimally conformant C++11 compiler and standard library. Anything too advanced would rule out MSVC, which we want to support. API features that would require C++11 features are enabled by default, but may be turned off using a preprocessor flag. See the Customization section below for specifics.

Right now the only C++11-related thing we really need is an implementation of the `<type_traits>` header.

Supporting earlier versions of C++ is not a high priority, so if you want that I'll accept a pull request.

However, compatibility with up to date compilers who aren't totally C++11-conformant yet **is** a priority, and if you submit an issue relating to this I'll fix the problem (if I have access to that compiler).

### Customization

liblls is configurable through the following preprocessor definitions and flags. These are intended

- `LIBLLS_NO_NAMESPACE`: don't put the liblls code in a namespace.

- `LIBLLS_NAMESPACE`: The namespace to use for the code in liblls. This defaults to `lls` (we don't use `llvm` to avoid clashing). This is ignored if `LIBLLS_NO_NAMESPACE` is set.

- `LIBLLS_NO_CXX11`: don't use any advanced c++11 features (standard library still must be c++11). Undefined by default.

- `LIBLLS_NO_RVALUE_REFERENCES`: Don't compile any functions which use rvalue references. Only applys to `SmallVector.h`, and is redundant if `LIBLLS_NO_CXX11` is defined. Undefined by default.

- `LIBLLS_NO_VARIADIC_TEMPLATES`: Don't compile any functions which use variadic templates. Only applys to `SmallVector.h`, and is redundant if `LIBLLS_NO_CXX11` is defined. Undefined by default.

- `LIBLLS_NO_DELETED_FN`: Don't use deleted functions to indicate... deleting... the function. Just make it private and unimplemented. This only applys to `SmallVector.h` and is redundant if `LIBLLS_NO_CXX11` is defined. Undefined by default.

### Run the tests

`liblls` borrows (steals) the its test files from llvm, so it has a fairly complete set of test files. You can compile and these using `make run-tests`. Or, equivalently, `make test && ./build/test-runner`.

## Changes from LLVM

The code in `liblls` differs from the code in llvm in the following ways:

- in `SmallVector.h`:
    - added `SmallVectorBase<T>::emplace_back` function when compiling with `LIBLLS_RVALUE_REFERENCES` and `LIBLLS_VARIADIC_TEMPLATES`.


## Planned additions
Eventually I'll get around to adding the following modules from llvm to liblls. Don't hold your breath though.  Bug me if this matters to you or if theres something else I should add.

- `raw_ostream` and friends, definitely.
- `SmallSet<T,N>`, and `SmallPtrSet<T,N>`. maybe. These would depend on SmallVector
- `DenseMap<T>`, `DenseSet<T>`, maybe. These would probably get some API changes (with regard to DenseMapInfo).

## License

`liblls` is available under the same license as LLVM. This is included below for your viewing convenience.

To make it as convenient as possible to use `liblls`, and to facilitate, I claim no copyright over any code I've written or changes I've made as part of `liblls`.


    ==============================================================================
    LLVM Release License
    ==============================================================================
    University of Illinois/NCSA
    Open Source License

    Copyright (c) 2003-2013 University of Illinois at Urbana-Champaign.
    All rights reserved.

    Developed by:

        LLVM Team

        University of Illinois at Urbana-Champaign

        http://llvm.org

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal with
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
    of the Software, and to permit persons to whom the Software is furnished to do
    so, subject to the following conditions:

        * Redistributions of source code must retain the above copyright notice,
          this list of conditions and the following disclaimers.

        * Redistributions in binary form must reproduce the above copyright notice,
          this list of conditions and the following disclaimers in the
          documentation and/or other materials provided with the distribution.

        * Neither the names of the LLVM Team, University of Illinois at
          Urbana-Champaign, nor the names of its contributors may be used to
          endorse or promote products derived from this Software without specific
          prior written permission.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
    CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH THE
    SOFTWARE.



