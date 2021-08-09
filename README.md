### Language Server
LSP support for Objeck will be incorporated into [v6.0](https://github.com/objeck/objeck-lang/tree/profiling-tools). Diagnostic functionality (i.e. compiling code, finding symbols, etc.) will be built a libraries that ship with the tool chain. The LSP backend is standalone and written in Objeck. The backend handles client requests, formats responses and maintains the state of the in-memory document.

There is lot of work ahead but progress is study.

##### Functional
1. Platform support
    1. Windows (AMD64 and IA32)
    2. Linux (AMD64, IA32 and ARMv7)
    3. macOS (AMD64)
3. Multi-document support
4. Code symbols
5. Finding variable references
6. Finding variable declarations
7. Find source method/function declarations
8. Keyword completion

##### Outstanding
1. Platform support
    1. macOS (ARM64)
2. Return JSON error codes if unable to parse source
3. Bundle documentation
4. Testing

##### Future
1. Hover inline documentation support
2. Method/function completion
3. Find library method/function declarations