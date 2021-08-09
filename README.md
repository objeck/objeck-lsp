### Language Server
LSP support for Objeck will be incorporated into [v6.0](https://github.com/objeck/objeck-lang/tree/profiling-tools). Diagnostic functionality (i.e. compiling code, finding symbols, etc.) will be built a libraries that ship with the tool chain. The LSP backend is standalone and written in Objeck. The backend handles client requests, formats responses and maintains the state of the in-memory document.

There is lot of work ahead but progress is study.

##### Functional
1. Platform support
    1. Windows (AMD64 and IA32)
    2. Linux (AMD64, IA32 and ARMv7)
    3. macOS (AMD64)
2. Multi-document support
3. Code symbols
    1. Classes
    2. Enums
    3. Methods    
4. Finding references
    1. Variables
5. Finding declarations
    1. Variables
    1. Methods and functions
6. Keyword completion

##### Outstanding
1. Platform support
    1. macOS (ARM64)
2. Finding declarations
    1. Classes and Enums
3. Error handling
    1. Unable to parse code
4. Linting (without DFA)
    1. Unused variables
    2. Dead code
4. Bundle documentation
5. More efficient symbol structure
5. Testing

##### Future
1. Hover documentation support
2. Method/function completion
3. Find library method/function declarations