\# EifMate



\*\*Claude-to-EiffelStudio Bridge: MCP Server for Eiffel Compilation\*\*



EifMate is a command-line bridge that enables Claude (via MCP - Model Context Protocol) to compile Eiffel projects using EiffelStudio. It provides a structured JSON API for compilation requests and responses, making it possible for AI assistants to work seamlessly with Eiffel codebases.



---



\## 🎯 Purpose



Enable Claude to:

\- ✅ Compile Eiffel projects via `ec.exe`

\- ✅ Capture and parse compiler output

\- ✅ Return structured error/warning information with file locations

\- ✅ Support multiple compilation modes (compile, freeze, finalize)

\- ✅ Validate ECF project structures



\## 🏗️ Architecture



```

Claude (MCP Client)

&nbsp;     ↓ JSON Request

┌─────────────────────┐

│   EM\_CLI\_APP        │  ← CLI Entry Point

│   (eifmate\_cli)     │

└──────────┬──────────┘

&nbsp;          ↓

┌──────────────────────────────────────┐

│  Core Components                     │

├──────────────────────────────────────┤

│  EM\_REQUEST      Parse JSON input    │

│  EM\_COMPILER     Interface to ec.exe │

│  EM\_PROJECT      ECF representation  │

│  EM\_ERROR        Error with location │

│  EM\_RESPONSE     Build JSON output   │

│  EM\_CONSTANTS    Project constants   │

└──────────────────────────────────────┘

&nbsp;          ↓

&nbsp;     EiffelStudio

&nbsp;      (ec.exe)

```



\## 📦 Current Status



\*\*Phase:\*\* Initial Structure ✅  

\*\*Compilation:\*\* Clean compile ✅  

\*\*Tests:\*\* Basic test infrastructure ✅



\### Completed

\- \[x] Project structure and ECF configuration

\- \[x] Core class skeletons (EM\_REQUEST, EM\_RESPONSE, EM\_COMPILER, etc.)

\- \[x] Thread concurrency support for PROCESS library

\- \[x] Test infrastructure (TEST\_SET\_BASE, TEST\_EM\_IN\_SYSTEM)

\- \[x] Comprehensive .gitignore for Eiffel projects



\### In Progress

\- \[ ] JSON request parsing (SIMPLE\_JSON integration)

\- \[ ] Compiler interface via PROCESS library

\- \[ ] Output parsing and error extraction

\- \[ ] Response JSON generation



\### Planned

\- \[ ] ECF file parsing and validation

\- \[ ] Multiple compilation modes (compile/freeze/finalize)

\- \[ ] Timeout handling

\- \[ ] Comprehensive test coverage

\- \[ ] MCP protocol integration

\- \[ ] Error location mapping



\## 🚀 Quick Start



\### Prerequisites



\- \*\*EiffelStudio 25.02\*\* or later

\- \*\*Eiffel PROCESS library\*\* (included with EiffelStudio)

\- \*\*SIMPLE\_JSON library\*\* (for JSON parsing)



\### Building



1\. \*\*Clone the repository:\*\*

```bash

git clone https://github.com/ljr1981/eifmate.git

cd eifmate

```



2\. \*\*Open in EiffelStudio:\*\*

```bash

\# Open eifmate.ecf

estudio eifmate.ecf

```



3\. \*\*Select target and compile:\*\*

\- Target: `eifmate\_cli`

\- Compile: Press F7 or click Compile



4\. \*\*Run tests:\*\*

\- Target: `eifmate\_tests`

\- Run AutoTest: Testing > Execute All Tests



\## 📂 Project Structure



```

eifmate/

├── eifmate.ecf              # Project configuration

├── src/

│   ├── cli/

│   │   └── em\_cli\_app.e     # CLI executable entry point

│   └── core/

│       ├── em\_request.e     # Parse JSON compilation requests

│       ├── em\_response.e    # Build JSON responses

│       ├── em\_compiler.e    # Interface to ec.exe compiler

│       ├── em\_project.e     # ECF project representation

│       ├── em\_error.e       # Compilation error with location

│       └── em\_constants.e   # Project-wide constants

└── testing/

&nbsp;   ├── application.e         # Test application root

&nbsp;   ├── test\_set\_base.e       # Base test class with assertions

&nbsp;   ├── test\_em\_in\_system.e   # Brings all EM\_\* classes into system

&nbsp;   └── test\_test\_set.e       # Example test

```



\## 🔧 Usage (Planned)



```bash

\# Compile a project

eifmate\_cli.exe --request '{

&nbsp; "project\_path": "C:/dev/myproject/myproject.ecf",

&nbsp; "target": "myproject",

&nbsp; "action": "compile"

}'



\# Response

{

&nbsp; "success": true,

&nbsp; "output": "Degree 6: ...",

&nbsp; "errors": \[],

&nbsp; "warnings": \[]

}

```



\## 🧪 Testing



The project uses EiffelStudio's AutoTest framework:



```eiffel

class TEST\_EM\_IN\_SYSTEM

&nbsp;   -- Brings all EM\_\* classes into compilation system

inherit

&nbsp;   TEST\_SET\_BASE



feature

&nbsp;   test\_classes\_in\_system

&nbsp;       do

&nbsp;           assert ("all\_em\_classes\_compile", True)

&nbsp;       end

end

```



\### Running Tests



1\. Open `eifmate.ecf` with target `eifmate\_tests`

2\. Navigate to: \*\*Testing > AutoTest\*\*

3\. Click: \*\*Execute All Tests\*\*



\## 🎯 Design Patterns



\### Design by Contract

All features use named preconditions and postconditions:



```eiffel

make\_from\_json (a\_json: STRING)

&nbsp;   require

&nbsp;       json\_attached: a\_json /= Void

&nbsp;       not\_empty: not a\_json.is\_empty

&nbsp;   do

&nbsp;       -- Parse JSON

&nbsp;   ensure

&nbsp;       valid\_if\_parsed: is\_valid implies (attached project\_path)

&nbsp;   end

```



\### Proper Feature Organization

Classes follow standard Eiffel feature categories:

\- `{NONE} -- Initialization`

\- `Access`

\- `Status report`

\- `Element change`

\- `Conversion`



\### Multiple Creation Procedures

Descriptive creation routines for clarity:



```eiffel

create

&nbsp;   make\_success,

&nbsp;   make\_failure

```



\## 🛠️ Dependencies



\### Required Libraries

\- \*\*base\*\* - Core Eiffel library (EiffelBase)

\- \*\*process\*\* - Subprocess execution (for ec.exe)

\- \*\*simple\_json\*\* - JSON parsing and generation



\### Optional Libraries (for future features)

\- \*\*store\*\* - Database operations

\- \*\*time\*\* - Timestamp operations  

\- \*\*zlib\*\* - Compression utilities



\## 📋 Targets



The ECF defines multiple targets:



| Target | Purpose | Status |

|--------|---------|--------|

| `eifmate` | Base library | ✅ Compiling |

| `eifmate\_tests` | Test suite | ✅ Compiling |

| `eifmate\_cli` | CLI executable | ✅ Compiling |

| `eifmate\_gui` | GUI monitor (planned) | 🚧 Future |

| `eifmate\_daemon` | Background service (planned) | 🚧 Future |

| `eifmate\_server` | HTTP server (planned) | 🚧 Future |



\## 🤝 Contributing



Contributions welcome! Please:



1\. Fork the repository

2\. Create a feature branch

3\. Follow Eiffel coding conventions (see below)

4\. Add tests for new functionality

5\. Submit a pull request



\### Eiffel Conventions



\- \*\*Feature naming:\*\* `l\_` prefix for locals, `al\_` for attached locals

\- \*\*Note clauses:\*\* Required at beginning and end of class

\- \*\*Contracts:\*\* All assertions must be named

\- \*\*Categories:\*\* Use standard feature organization

\- \*\*Tests:\*\* Inherit from `TEST\_SET\_BASE`



\## 📝 To-Do List



\### High Priority

\- \[ ] Implement EM\_REQUEST JSON parsing

\- \[ ] Implement EM\_COMPILER.compile using PROCESS library

\- \[ ] Parse compiler output for errors/warnings

\- \[ ] Implement EM\_RESPONSE.to\_json



\### Medium Priority

\- \[ ] Implement EM\_PROJECT ECF parsing

\- \[ ] Add individual TEST\_EM\_\* test classes

\- \[ ] Handle compilation timeouts

\- \[ ] Support freeze and finalize modes



\### Low Priority

\- \[ ] Add progress reporting

\- \[ ] Implement caching for project metadata

\- \[ ] Add configuration file support

\- \[ ] GUI monitoring application



\## 📄 License



MIT License



Copyright (c) 2024 Larry Rix



Permission is hereby granted, free of charge, to any person obtaining a copy

of this software and associated documentation files (the "Software"), to deal

in the Software without restriction, including without limitation the rights

to use, copy, modify, merge, publish, distribute, sublicense, and/or sell

copies of the Software, and to permit persons to whom the Software is

furnished to do so, subject to the following conditions:



The above copyright notice and this permission notice shall be included in all

copies or substantial portions of the Software.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR

IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,

FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE

AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER

LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,

OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

SOFTWARE.



\## 🔗 Related Projects



\- \[SIMPLE\_JSON](https://github.com/ljr1981/simple\_json) - High-level JSON library for Eiffel

\- \[EiffelStudio](https://www.eiffel.com/eiffelstudio/) - The Eiffel IDE and compiler

\- \[Model Context Protocol](https://modelcontextprotocol.io/) - Protocol for AI-to-tool communication



\## 📧 Contact



Larry Rix - \[@ljr1981](https://github.com/ljr1981)



Project Link: \[https://github.com/ljr1981/eifmate](https://github.com/ljr1981/eifmate)



---



\*\*Status:\*\* 🚧 Active Development  

\*\*Version:\*\* 0.1.0 (Initial Structure)  

\*\*Last Updated:\*\* November 16, 2025

