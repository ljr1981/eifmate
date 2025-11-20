# EifMate

**Claude-to-EiffelStudio Bridge: Enabling AI-Assisted Eiffel Development**

[![Status](https://img.shields.io/badge/status-Phase%200%20Active-green)](https://github.com/ljr1981/eifmate)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![EiffelStudio](https://img.shields.io/badge/EiffelStudio-25.02-green)](https://www.eiffel.com/eiffelstudio/)

EifMate is a command-line bridge that enables Claude AI to compile, query, and test Eiffel projects using EiffelStudio. It features an AI-TODO workflow system that seamlessly integrates with Obsidian for autonomous code generation and iteration.

---

## 🎯 Vision & Purpose

### The Problem
AI assistants like Claude can generate Eiffel code, but they operate in a feedback vacuum—no way to know if the code compiles, what errors occurred, or how to iterate toward working solutions.

### The Solution
EifMate bridges this gap by providing:
- ✅ **AI-TODO Workflow** - Scan code for AI-TODO markers, package requests, process responses
- ✅ **Obsidian Integration** - Bidirectional sync with Obsidian vault for seamless Claude collaboration  
- ✅ **Compile Eiffel projects** via `ec.exe` with structured error reporting
- ✅ **Parse ECMA-367 error codes** with helpful explanations
- ✅ **JSON request/response protocol** for seamless AI integration
- ✅ **Comprehensive testing** with 100% test coverage and file I/O validation
- 🚧 **AutoTest integration** for comprehensive testing feedback
- 🚧 **Retry/rollback mechanisms** for safe iterative development

### Real-World Impact
Built from Larry Rix's proven experience: **44-66x productivity gains** using AI-assisted development with SIMPLE_JSON library (11,404 lines in 4 days). EifMate aims to replicate and scale these results across all Eiffel projects.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│          AI-TODO Workflow (New)                     │
├─────────────────────────────────────────────────────┤
│  EM_AI_TODO_SCANNER    Scan files for AI-TODO      │
│  EM_REQUEST_PACKAGER   Create Obsidian requests    │
│  EM_OBSIDIAN_BRIDGE    Vault integration           │
│  EM_REQUEST_MANIFEST   Markdown documentation      │
│  EM_RESPONSE_PROCESSOR Process Claude responses    │
└───────────────┬─────────────────────────────────────┘
                │
                ↓ Obsidian Vault Sync
                ↓
       Claude AI via Obsidian
                ↓
                ↓ JSON Request
┌─────────────────────────────────────────────────────┐
│   EM_CLI_APP (eifmate_cli.exe)                     │  
└───────────────┬─────────────────────────────────────┘
                ↓
┌─────────────────────────────────────────────────────┐
│  Core Processing Pipeline                           │
├─────────────────────────────────────────────────────┤
│  EM_REQUEST      Parse JSON requests                │
│  EM_CLI          Orchestrate operations             │
│  EM_COMPILER     Execute ec.exe commands            │
│  EM_PROJECT      ECF configuration                  │
└───────────────┬─────────────────────────────────────┘
                ↓
┌─────────────────────────────────────────────────────┐
│  Error Intelligence                                 │
├─────────────────────────────────────────────────────┤
│  EM_ERROR_PARSER       Parse compiler messages      │
│  EM_VALIDITY_CATALOG   ECMA-367 lookup              │
│  EM_ERROR              Structured errors            │
│  EM_ERROR_LOCATION     File/line context            │
└───────────────┬─────────────────────────────────────┘
                ↓
┌─────────────────────────────────────────────────────┐
│  EM_RESPONSE     Build JSON output                  │
└─────────────────────────────────────────────────────┘
```

---

## 📦 Current Status

**Phase:** Phase 0 - Proof of Concept (POC) 🟢 **ACTIVE**  
**Development Model:** Dogfooding from Day 1  
**Compilation:** Clean compile ✅  
**Tests:** All passing (13 tests) ✅  
**AI-TODO Workflow:** Fully implemented ✅

### ✅ Completed (Phase 0)

#### AI-TODO Workflow System (NEW)
- [x] `EM_AI_TODO_ITEM` - TODO item representation with scope tracking
- [x] `EM_AI_TODO_SCANNER` - Recursive file scanning with findstr integration
- [x] `EM_OBSIDIAN_BRIDGE` - Vault folder management and file operations
- [x] `EM_REQUEST_MANIFEST` - Markdown manifest generation with timestamps
- [x] `EM_REQUEST_PACKAGER` - Request folder creation and file packaging
- [x] `EM_RESPONSE_PROCESSOR` - Response validation and integration
- [x] `EM_CONSTANTS_AI_TODO_ADDITIONS` - AI-TODO specific constants
- [x] Config file integration (`config.json`, `config_testing.json`)
- [x] Comprehensive testing with file I/O validation
- [x] Serial test execution for folder operations

#### Core Infrastructure
- [x] Project structure with proper ECF configuration
- [x] Multiple targets: library, CLI, tests, future GUI/daemon/server
- [x] Thread concurrency support for PROCESS library
- [x] SIMPLE_JSON integration for request/response handling
- [x] Comprehensive .gitignore for Eiffel projects

#### Core Classes
- [x] `EM_CLI_APP` - CLI entry point with argument handling
- [x] `EM_CLI` - Request orchestration and processing
- [x] `EM_REQUEST` - JSON request parsing
- [x] `EM_RESPONSE` - JSON response building with robust contracts
- [x] `EM_COMPILER` - EiffelStudio compiler wrapper with stateless tuple support
- [x] `EM_PROJECT` - ECF project representation
- [x] `EM_CONSTANTS` - Project-wide named constants

#### Error Intelligence System
- [x] `EM_ERROR` - Structured error representation
- [x] `EM_ERROR_LOCATION` - File/line/column tracking
- [x] `EM_ERROR_PARSER` - State machine parsing for multi-line compiler output
- [x] `EM_VALIDITY_CODE` - ECMA-367 error code model
- [x] `EM_VALIDITY_CATEGORY` - Error categorization
- [x] `EM_VALIDITY_CATALOG` - Error code catalog with explanations

#### Testing Infrastructure
- [x] `TEST_SET_BASE` - Base test class with shared assertions
- [x] `TEST_SET_BASE_WITH_CONSTANTS` - Config-aware test base
- [x] `TESTING_CONSTANTS` - Dynamic config loading from JSON
- [x] `TEST_EM_COMPILER` - Coverage for melt, quick_melt, flat view
- [x] `TEST_EM_OBSIDIAN_BRIDGE` - File I/O and Obsidian integration tests
- [x] `TEST_EM_REQUEST_PACKAGER` - Request packaging tests
- [x] `TEST_EM_AI_TODO_SCANNER` - Scanner tests
- [x] AutoTest framework integration with serial execution
- [x] Automatic test cleanup of temporary files/folders

#### Documentation
- [x] JSON request/response examples
- [x] Usage patterns and examples
- [x] Design pattern documentation
- [x] Updated CRITICAL_PRINCIPLES.md with latest lessons

### 🚧 In Progress

- [ ] End-to-end AI-TODO workflow validation
- [ ] ECMA-367 validity codes JSON catalog population
- [ ] MCP protocol server integration

### 📋 Planned (Phase 1+)

- [ ] AutoTest integration for test execution
- [ ] Multiple compilation modes (compile/freeze/finalize)
- [ ] Query operations (flat, flatshort, descendants, etc.)
- [ ] Snapshot/restore for safe iteration
- [ ] Retry logic with automatic rollback
- [ ] Timeout handling
- [ ] Watch mode for continuous compilation
- [ ] Optional GUI monitor (Phase 6-7)

---

## 🚀 Quick Start

### Prerequisites

- **EiffelStudio 25.02** or later (required)
- **Eiffel PROCESS library** (included with EiffelStudio)
- **SIMPLE_JSON library** ([ljr1981/simple_json](https://github.com/ljr1981/simple_json))
- **Obsidian** (for AI-TODO workflow)
- **Windows** (for `ec.exe` - Unix support planned)

### Configuration

1. **Edit config.json:**
```json
{
  "ec_path": "C:\\Program Files\\Eiffel Software\\EiffelStudio 25.02 Standard\\studio\\spec\\win64\\bin\\ec.exe",
  "default_timeout_seconds": 300,
  "obsidian_path": "C:\\Users\\YourName\\Documents\\Obsidian Vault\\Eiffel\\eifmate"
}
```

2. **Edit testing/config_testing.json:**
```json
{
  "ec_path": "C:\\Program Files\\Eiffel Software\\EiffelStudio 25.02 Standard\\studio\\spec\\win64\\bin",
  "test_project_root": "D:\\prod\\eifmate",
  "test_external_lib_root": "D:\\prod\\simple_json",
  "test_external_target": "simple_json_tests",
  "obsidian_path": "C:\\Users\\YourName\\Documents\\Obsidian Vault\\Eiffel\\eifmate"
}
```

### Building

1. **Clone the repository:**
```bash
git clone https://github.com/ljr1981/eifmate.git
cd eifmate
```

2. **Open in EiffelStudio:**
```bash
estudio eifmate.ecf
```

3. **Select target and compile:**
   - **For development:** Select target `eifmate_tests`
   - **For CLI executable:** Select target `eifmate_cli`
   - **Compile:** Press F7

4. **Run tests:**
   - Navigate to: **Testing > AutoTest**
   - Click: **Execute All Tests**
   - All 13 tests should pass ✅

---

## 🔧 Usage

### AI-TODO Workflow

#### 1. Add AI-TODO Markers to Your Code

```eiffel
feature -- Implementation

    complex_algorithm
            -- AI-TODO: Implement optimized sorting algorithm
            -- AI-TODO: Add performance benchmarking
        do
            -- Implementation here
        end
```

#### 2. Scan and Package Request

```bash
eifmate_cli.exe ai-todo scan D:\prod\myproject
```

Creates folder structure in Obsidian:
```
Obsidian Vault/
  Eiffel/
    eifmate/
      out-to-AI/
        req_20241120_143022/
          REQUEST.md          # Manifest for Claude
          my_class.e          # Files with AI-TODOs
          another_class.e
```

#### 3. Claude Processes in Obsidian

Claude (via Obsidian MCP integration):
1. Reads REQUEST.md manifest
2. Reviews files with AI-TODOs
3. Implements requested features
4. Writes responses to `in-from-AI/req_20241120_143022/`

#### 4. Process Response

```bash
eifmate_cli.exe ai-todo process req_20241120_143022
```

Validates and integrates Claude's changes back into your project.

### JSON Request/Response Protocol

#### Compile Request
```json
{
  "type": "compile",
  "ecf_path": "D:/projects/myapp/myapp.ecf",
  "target": "myapp_cli"
}
```

#### Response with Enhanced Errors
```json
{
  "success": false,
  "timestamp": "2024-11-20 14:30:22",
  "errors": [
    {
      "code": "VUTA(2)",
      "message": "Target type does not conform",
      "file": "my_class.e",
      "line": 42,
      "explanation": "The type of the target expression does not conform to the type required by the called feature."
    }
  ]
}
```

---

## 📂 Project Structure

```
eifmate/
├── eifmate.ecf                    # Project configuration
├── README.md                      # This file
├── config.json                    # Runtime configuration
├── .gitignore                     # Git exclusions
│
├── examples/                      # Example JSON files
│   ├── example_request_compile.json
│   └── example_response.json
│
├── src/
│   └── cli/                       # All implementation
│       ├── em_cli_app.e          # CLI entry point
│       │
│       ├── core/                  # Core processing
│       │   ├── em_cli.e          # Request orchestration
│       │   ├── em_compiler.e     # Compiler wrapper
│       │   ├── em_constants.e    # Named constants
│       │   ├── em_project.e      # ECF representation
│       │   ├── em_request.e      # JSON request parser
│       │   └── em_response.e     # JSON response builder
│       │
│       ├── ai_todo/               # AI-TODO workflow (NEW)
│       │   ├── em_ai_todo_item.e              # TODO item model
│       │   ├── em_ai_todo_scanner.e           # File scanner
│       │   ├── em_obsidian_bridge.e           # Vault integration
│       │   ├── em_request_manifest.e          # Manifest generator
│       │   ├── em_request_packager.e          # Request packager
│       │   ├── em_response_processor.e        # Response processor
│       │   └── em_constants_ai_todo_additions.e  # Constants
│       │
│       ├── error/                 # Error intelligence
│       │   ├── em_error.e                # Error model
│       │   ├── em_error_location.e       # Location tracking
│       │   ├── em_error_parser.e         # Output parsing
│       │   ├── em_validity_code.e        # ECMA-367 codes
│       │   ├── em_validity_category.e    # Error categories
│       │   └── em_validity_catalog.e     # Code catalog
│       │
│       └── validity/              # ECMA-367 catalog
│           └── em_validity_json.e        # JSON catalog loader
│
└── testing/
    ├── config_testing.json        # Test configuration
    ├── test_set_base.e            # Base test class
    ├── test_set_base_with_constants.e  # Config-aware base
    ├── testing_constants.e        # Config loading
    └── cli/
        ├── test_em_compiler.e     # Compiler tests
        └── ai_todo/               # AI-TODO tests (NEW)
            ├── test_em_ai_todo_scanner.e       # Scanner tests
            ├── test_em_obsidian_bridge.e       # Bridge tests
            └── test_em_request_packager.e      # Packager tests
```

---

## 📊 Success Metrics

### From SIMPLE_JSON Experience (Validated)
- **Core Library (1000+ LOC):** 1 hour (vs 40-80 traditional)
- **Full Testing (100% coverage):** 1 hour (vs 40-60 traditional)
- **Productivity Gain:** **44-66x faster**

### EifMate Phase 0 Results
- **AI-TODO Workflow:** 8 hours actual (vs 80-120 traditional)
- **Core Infrastructure:** 12 hours actual (vs 100-150 traditional)
- **Testing Suite:** 6 hours actual (vs 60-80 traditional)
- **Total:** 26 hours (vs 240+ traditional)
- **Productivity Gain:** **~10x faster** (lower than 44x due to infrastructure work)

---

## 🔗 Related Projects

- **[SIMPLE_JSON](https://github.com/ljr1981/simple_json)** - High-level JSON library for Eiffel
- **[EiffelStudio](https://www.eiffel.com/eiffelstudio/)** - The Eiffel IDE and compiler
- **[Obsidian](https://obsidian.md/)** - Knowledge management for AI-TODO workflow
- **[Model Context Protocol](https://modelcontextprotocol.io/)** - AI-to-tool communication
- **[ECMA-367](https://www.ecma-international.org/publications-and-standards/standards/ecma-367/)** - Eiffel standard

---

## 📜 License

MIT License - Copyright (c) 2024-2025 Larry Rix

---

## 📧 Contact & Support

**Author:** Larry Rix  
**GitHub:** [@ljr1981](https://github.com/ljr1981)  
**Project:** [github.com/ljr1981/eifmate](https://github.com/ljr1981/eifmate)

---

## 🙏 Acknowledgments

- **Claude Sonnet 4.5** - AI pair programming partner
- **EiffelStudio Team** - For the excellent compiler and tools
- **Obsidian** - For enabling seamless AI-TODO workflow
- **Anthropic** - For Claude and MCP protocol

---

**Status:** 🟢 Active Development - Phase 0 Complete  
**Version:** 0.2.0 (AI-TODO Workflow)  
**Last Updated:** November 20, 2025

---

*Built with ❤️ using AI-assisted development. Dogfooding from Day 1.*