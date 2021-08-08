### Language Server
LSP support for Objeck will be incorporated into v6.0. Diagnostic functionality (i.e. compiling code, finding symbols, etc.) will be built a libraries that ship with the tool chain. The LSP backend is standalone and written in Objeck. The backend handles client requests, formats responses and maintains the state of the in-memory document.

There is lot of work ahead but progress is study.

##### Outstanding
1. Return error message if unable to parse code
2. Find method/function declarations

##### Functional
1. Code symbols
2. Find variable references
3. Find variable declarations
4. Keyword text completion