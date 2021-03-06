# Objeck LSP
LSP support for [Objeck](https://github.com/objeck/objeck-lang) will be incorporated into v6.0. Diagnostic functionality (i.e. compiling code, finding symbols, code completion, etc.) will be built in libraries that ship with the tool chain. The [LSP](https://microsoft.github.io/language-server-protocol/specification) server is standalone, written in Objeck and exposes a TCP socket interface. The backend handles client requests, formats responses and maintains the state of in-memory documents.

![alt text](images/design.svg "Objeck LSP")

#### Notifications
* Initialized `initialized`
* Cancel Request `$/cancelRequest`
* File Open `textDocument/didOpen`
* File Changed `textDocument/didChange`
* File Save `textDocument/didSave`
* File Close `textDocument/didClose`
* Workspaces
  * JSON configured workspaces to support multi-file projects
  * Watched File Changed `workspace/didChangeWatchedFiles`
  * Workspace Changed `workspace/didChangeWorkspaceFolders`

#### Callbacks
* Initialize `initialize`
* Code completion `textDocument/completion`
* Code resolution `completionItem/resolve`
* Code symbol `textDocument/documentSymbol`
* Method/Function signature help `textDocument/signatureHelp`
* Goto code references `textDocument/references`
* Goto code definitions `textDocument/definition`
* Goto code declaration `textDocument/declaration`
* Variable rename `textDocument/rename`
* Format document `textDocument/formatting`
* Format selection `textDocument/rangeFormatting`
* Editor shutdown `shutdown`

<figure>
<figcaption>Fig.1 - Error checking</figcaption>
<img src="images/checking.png" alt="Error checking" style="width:60%"/>
</figure>

<figure>
<figcaption>Fig.2 - Code completion</figcaption>
<img src="images/completion.png" alt="Code completion" style="width:60%"/>
</figure>

<figure>
<figcaption>Fig.3 - Variable and method renaming</figcaption>
<img src="images/rename.png" alt="Variable and method renaming" style="width:60%"/>
</figure>

## Project Status
The server is functional but there is still work to do.

### Functional
1. Tested editors
    1. Visual Studio Code
    2. Sublime
1. Platform support
    1. Windows (AMD64 and IA32)
    2. Linux (AMD64, IA32 and ARMv7)
    3. macOS (AMD64 and ARM64)
2. Multi-document support
    1. Project workspaces
4. Code symbols
    1. Classes
    2. Enums
    3. Methods    
5. Finding references
    1. Variables
6. Finding declarations
    1. Variables
    2. Methods and functions
7. Finding definitions
    1. Variables (done)
    2. Classes and method (done)
8. Keyword completion
    1. Variables
    2. Methods and functions
9. Bundle documentation

### Outstanding
1. Auto include libraries based upon 'use' statements
2. Finding definitions
    1. Enums
3. Linting
    1. Unused variables
    2. Dead code
4. Testing with Emacs

### Future
1. Code formatting 
2. Document hover support
