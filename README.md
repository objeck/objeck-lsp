# Objeck LSP
LSP support for [Objeck](https://github.com/objeck/objeck-lang) will be incorporated into v6.0. Diagnostic functionality (i.e. compiling code, finding symbols, code completion, etc.) will be built in libraries that ship with the tool chain. The [LSP](https://microsoft.github.io/language-server-protocol/specification) sever is standalone, written in Objeck and exposes a TCP socket interface. The backend handles client requests, formats responses and maintains the state of the in-memory document.

![alt text](images/design.svg "Objeck LSP")

## Message Support

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
* Code Completion `textDocument/completion`
* Code Resolution `completionItem/resolve`
* Code Symbol `textDocument/documentSymbol`
* Method/Function Signature Help `textDocument/signatureHelp`
* Goto Code References `textDocument/references`
* Goto Code Definitions `textDocument/definition`
* Goto Code Declaration `textDocument/declaration`
* Variable rename `textDocument/rename`
* Editor Shutdown `shutdown`

<p>
![alt text](images/checking.png "Error checking")
*Error checking*</p>

![alt text](images/completion.png "Code completion")
*Code completion*

![alt text](images/rename.png "Variable/method renaming")
*Variable/method renaming*

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
