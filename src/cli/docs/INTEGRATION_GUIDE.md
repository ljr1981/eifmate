# Integration Guide: Enhanced Error Messages

## Overview

This guide shows you exactly how to integrate the enhanced error message system into your existing EifMate installation.

---

## Prerequisites

- Working EifMate installation
- EiffelStudio 25.02 or later
- Basic familiarity with ECF files

---

## Step-by-Step Integration

### Step 1: Backup Current Files

Before making changes, backup your current error parser:

```bash
cd eifmate/src/cli/core
cp em_error_parser.e em_error_parser.e.backup
```

### Step 2: Copy New Files

Copy all `.e` files from this package to `src/cli/core/`:

```bash
# From the extracted package directory
cp em_error.e /path/to/eifmate/src/cli/core/
cp em_error_location.e /path/to/eifmate/src/cli/core/
cp em_validity_catalog.e /path/to/eifmate/src/cli/core/
cp em_validity_category.e /path/to/eifmate/src/cli/core/
cp em_validity_code.e /path/to/eifmate/src/cli/core/
cp em_error_parser.e /path/to/eifmate/src/cli/core/  # This replaces existing
cp validity_codes.json /path/to/eifmate/src/cli/core/
```

### Step 3: Verify File Structure

Your `src/cli/core/` directory should now contain:

```
src/cli/core/
  ├── em_compiler.e                (existing)
  ├── em_error.e                   (NEW)
  ├── em_error_location.e          (NEW)
  ├── em_error_parser.e            (REPLACED)
  ├── em_validity_catalog.e        (NEW)
  ├── em_validity_category.e       (NEW)
  ├── em_validity_code.e           (NEW)
  └── validity_codes.json          (NEW)
```

### Step 4: Update ECF Configuration

Edit `eifmate.ecf` to include the new classes.

**Find the core cluster section:**

```xml
<cluster name="core" location=".\src\cli\core\" recursive="false">
```

**Ensure these classes are listed:**

```xml
<cluster name="core" location=".\src\cli\core\" recursive="false">
  <file_rule>
    <exclude>/CVS$</exclude>
    <exclude>/EIFGENs$</exclude>
    <exclude>/\.svn$</exclude>
  </file_rule>
  
  <!-- Existing classes -->
  <class name="EM_COMPILER"/>
  
  <!-- Enhanced error classes -->
  <class name="EM_ERROR"/>
  <class name="EM_ERROR_LOCATION"/>
  <class name="EM_ERROR_PARSER"/>
  <class name="EM_VALIDITY_CATALOG"/>
  <class name="EM_VALIDITY_CATEGORY"/>
  <class name="EM_VALIDITY_CODE"/>
</cluster>
```

**Note:** The exact structure depends on how your ECF is organized. The key is ensuring all 6 new classes are included.

### Step 5: Compile EifMate

```bash
cd eifmate
ec -config eifmate.ecf -freeze
```

**Watch for:**
- Successful compilation (no errors)
- All classes compiled
- No missing dependencies

### Step 6: Test Integration

Create a simple test file with a known error:

```eiffel
class TEST_VUTA
create
  make
feature
  make
    local
      l_str: detachable STRING
    do
      print (l_str.count)  -- This will cause VUTA error
    end
end
```

Compile this with EifMate and verify you see enhanced error message.

---

## Troubleshooting

### Problem: Compilation Errors After Integration

**Symptom:** EifMate fails to compile after adding new files

**Solution:**
1. Check all 6 `.e` files are in `src/cli/core/`
2. Verify ECF includes all new classes
3. Check for typos in class names
4. Ensure no file name conflicts

### Problem: Enhanced Messages Not Appearing

**Symptom:** Compilation works but errors look the same

**Solution:**
1. Verify `em_error_parser.e` was replaced (not copied alongside old one)
2. Check `EM_ERROR_PARSER` inherits `EM_VALIDITY_CATALOG`
3. Verify `make` calls `make_catalog`
4. Check catalog initialization in `make_catalog`

### Problem: Only Some Codes Enhanced

**Symptom:** Some errors have help text, others don't

**Solution:**
This is expected - only 8 codes are manually loaded in `load_common_codes`.

To add more codes:
1. Edit `em_validity_catalog.e`
2. Add more `add_code` calls in `load_common_codes`
3. Recompile

### Problem: Missing HASH_TABLE Error

**Symptom:** Compilation error about HASH_TABLE

**Solution:**
Ensure your ECF includes the base library:

```xml
<library name="base" location="$ISE_LIBRARY\library\base\base.ecf"/>
```

---

## Verification Checklist

After integration, verify:

- [ ] All 6 new `.e` files in `src/cli/core/`
- [ ] `validity_codes.json` in `src/cli/core/`
- [ ] ECF updated with all new classes
- [ ] EifMate compiles without errors
- [ ] Test file shows enhanced error messages
- [ ] VUTA errors show help text
- [ ] VEEN errors show help text
- [ ] Other common errors enhanced

---

## Rollback Procedure

If you need to revert:

```bash
cd eifmate/src/cli/core

# Restore original parser
cp em_error_parser.e.backup em_error_parser.e

# Remove new files
rm em_error.e
rm em_error_location.e
rm em_validity_catalog.e
rm em_validity_category.e
rm em_validity_code.e
rm validity_codes.json

# Remove from ECF (manually)
# Recompile
```

---

## Next Steps

After successful integration:

1. **Test with Real Projects**
   - Compile existing Eiffel projects
   - Verify error messages are helpful
   - Report any issues

2. **Customize**
   - Add more error codes to catalog
   - Adjust help text as needed
   - Create custom categories

3. **Extend**
   - Implement JSON catalog loading
   - Add location parsing
   - Build suggestion engine

---

## Support

If you encounter issues:

1. Check this guide's troubleshooting section
2. Verify all files are in correct locations
3. Review ECF configuration
4. Check EiffelStudio version compatibility

---

**Integration should take 5-10 minutes for a working EifMate installation.**

Good luck! 🚀
