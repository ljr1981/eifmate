# EifMate Enhanced Error Messages

## 📦 Package Contents

This package adds **enhanced error message support** to EifMate, providing helpful explanations for ECMA-367 validity error codes.

### What's Included

**Core Implementation (6 files):**
- `em_validity_category.e` - Error category enumeration
- `em_validity_code.e` - Individual error code representation
- `em_validity_catalog.e` - Catalog of ECMA-367 error codes
- `em_error.e` - Enhanced error representation
- `em_error_location.e` - Error location information
- `em_error_parser.e` - Enhanced parser with catalog integration

**Data:**
- `validity_codes.json` - JSON catalog with 10+ common error codes

**Documentation:**
- This README
- Integration guide (see below)

---

## 🎯 What This Does

### Before Enhancement
```
Error code: VUTA(2)
Line 45: Call on void target
```

### After Enhancement
```
Error: VUTA
Category: Usage
Message: Call on void target at line 45

Help:
Target must be attached (not void). Use 'if attached' pattern or ensure initialization.

Common causes:
- Calling feature on potentially void reference
- Missing initialization
- Incorrect use of detachable types
```

---

## 📥 Installation

### Step 1: Extract Files

Extract this package to your EifMate project:
```
eifmate/
  src/
    cli/
      core/
        em_compiler.e              (existing)
        em_error_parser.e          (REPLACE with enhanced version)
        em_error.e                 (ADD)
        em_error_location.e        (ADD)
        em_validity_catalog.e      (ADD)
        em_validity_category.e     (ADD)
        em_validity_code.e         (ADD)
        validity_codes.json        (ADD)
```

### Step 2: Update Your ECF

Add the new classes to your `eifmate.ecf`:

```xml
<cluster name="core" location=".\src\cli\core\" recursive="false">
  <file_rule>
    <exclude>/CVS$</exclude>
    <exclude>/EIFGENs$</exclude>
    <exclude>/\.svn$</exclude>
  </file_rule>
  
  <!-- Existing files -->
  <class name="EM_COMPILER"/>
  <class name="EM_ERROR_PARSER"/>  <!-- This gets enhanced -->
  
  <!-- New files to add -->
  <class name="EM_ERROR"/>
  <class name="EM_ERROR_LOCATION"/>
  <class name="EM_VALIDITY_CATALOG"/>
  <class name="EM_VALIDITY_CATEGORY"/>
  <class name="EM_VALIDITY_CODE"/>
</cluster>
```

### Step 3: Compile

```bash
cd eifmate
ec -config eifmate.ecf -freeze
```

That's it! Your EifMate now provides enhanced error messages.

---

## 🔧 How It Works

### Architecture

```
┌─────────────────────────┐
│   EM_ERROR_PARSER       │
│  (Enhanced Version)     │
└───────────┬─────────────┘
            │ inherits
            ▼
┌─────────────────────────┐
│  EM_VALIDITY_CATALOG    │
│  - loads common codes   │
│  - provides lookup      │
└───────────┬─────────────┘
            │ uses
            ▼
┌─────────────────────────┐
│  EM_VALIDITY_CODE       │
│  - code + description   │
│  - category             │
│  - help text            │
└─────────────────────────┘
```

### Usage Example

```eiffel
local
  l_parser: EM_ERROR_PARSER
  l_errors: ARRAYED_LIST [EM_ERROR]
  l_compiler_output: STRING
do
  create l_parser.make
  
  -- Parse compiler output
  l_errors := l_parser.parse_errors (l_compiler_output)
  
  -- Print enhanced errors
  across l_errors as ic loop
    print (ic.item.formatted_output)
  end
end
```

---

## 📚 Error Codes Included

### Currently Loaded (8 codes)

| Code | Category | Description |
|------|----------|-------------|
| VEEN | Entities | Entity name must be properly declared |
| VUTA | Usage | Target must be attached (not void) |
| VTCT | Types | Type must be a valid class name |
| VMFN | Members | Feature name must be unique |
| VJAR | Types | Type must conform to expected type |
| VHPR | Contracts | Precondition must be equal or weaker |
| VAPE | Contracts | Precondition violation |
| VPIR | Redefinition | Feature redefinition signature compatibility |

### JSON Catalog (10+ codes)

The `validity_codes.json` file contains additional codes that can be loaded dynamically in the future.

---

## 🚀 Future Enhancements

### Phase 1 (Current)
- ✅ Basic catalog with 8 common codes
- ✅ Manual code loading
- ✅ Help text generation

### Phase 2 (Planned)
- ⬜ Load full JSON catalog (88+ codes)
- ⬜ Location parsing (class, feature, line)
- ⬜ Suggestion engine

### Phase 3 (Future)
- ⬜ Context-aware suggestions
- ⬜ Fix recommendations
- ⬜ Interactive help mode

---

## 🛠️ Customization

### Adding More Error Codes

Edit `em_validity_catalog.e` and add to `load_common_codes`:

```eiffel
add_code ("VXXX",
    "Description of what this error means",
    l_category.appropriate_category)
```

### Creating New Categories

Edit `em_validity_category.e` and add:

```eiffel
my_category: EM_VALIDITY_CATEGORY
    once
        create Result.make ("My Category")
    ensure
        result_attached: Result /= Void
    end
```

---

## 📖 API Reference

### EM_VALIDITY_CATALOG

```eiffel
make
  -- Initialize catalog with common codes

has_code (a_code: STRING): BOOLEAN
  -- Does catalog contain this code?

code_info (a_code: STRING): detachable EM_VALIDITY_CODE
  -- Get information for code

add_code (a_code, a_description: STRING; a_category: EM_VALIDITY_CATEGORY)
  -- Add new code to catalog
```

### EM_ERROR

```eiffel
make (a_code, a_message: STRING)
  -- Create error with code and message

set_help_text (a_text: STRING)
  -- Add catalog help text

set_category (a_category: STRING)
  -- Set error category

set_location (a_location: EM_ERROR_LOCATION)
  -- Set location information

formatted_output: STRING
  -- Get complete formatted error message
```

---

## ✅ Testing

### Manual Testing

1. Create a class with a known error (e.g., VUTA):
```eiffel
class TEST_ERROR
feature
  test
    local
      l_obj: detachable STRING
    do
      print (l_obj.count)  -- VUTA error
    end
end
```

2. Compile with EifMate
3. Verify enhanced error message appears

### Automated Testing

Add tests to verify:
- Catalog loading
- Code lookup
- Help text generation
- Error enhancement

---

## 🤝 Contributing

To add more error codes:

1. Research the ECMA-367 specification
2. Add code to `validity_codes.json`
3. Or add directly to `em_validity_catalog.e`
4. Test with real compilation errors
5. Submit enhancement

---

## 📄 License

MIT License - See project LICENSE file

---

## 🙏 Credits

**Created by:** Larry Rix with Claude Sonnet 4.5  
**Project:** EifMate - Claude-to-EiffelStudio Bridge  
**Date:** November 2024

---

## 📞 Support

For issues or questions:
1. Check the Integration Guide
2. Review the API Reference
3. Examine example errors in documentation
4. Open an issue on the project repository

---

**Happy Eiffel coding with enhanced error messages!** 🎉
