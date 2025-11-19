# ECMA-367 Error Codes Quick Reference

## Most Common Errors (Enhanced in EifMate)

### VEEN - Entity Name Error
**Category:** Entities  
**Meaning:** Entity (variable, feature, class) name not properly declared

**Common Causes:**
- Typo in feature or variable name
- Missing inheritance or import
- Incorrect scope or visibility
- Feature not exported

**Example:**
```eiffel
class MY_CLASS
feature
  test
    local
      l_count: INTEGER
    do
      print (l_cont)  -- VEEN: typo in variable name
    end
end
```

**Fix:**
- Check spelling carefully
- Verify inheritance if calling inherited feature
- Check export clauses for visibility
- Ensure feature is declared

---

### VUTA - Usage/Target Attached
**Category:** Usage  
**Meaning:** Calling feature on potentially void (detached) target

**Common Causes:**
- Calling feature on `detachable` reference
- Missing initialization
- Not using `if attached` pattern

**Example:**
```eiffel
class MY_CLASS
feature
  test
    local
      l_str: detachable STRING
    do
      print (l_str.count)  -- VUTA: l_str might be void
    end
end
```

**Fix:**
```eiffel
-- Use if attached pattern
if attached l_str as al_str then
  print (al_str.count)  -- Safe now
end

-- Or ensure initialization
create l_str.make_empty
print (l_str.count)  -- Safe because initialized
```

---

### VTCT - Type Conformance to Class Type
**Category:** Types  
**Meaning:** Type name must be a valid class name

**Common Causes:**
- Class name misspelled
- Class not in project
- Missing library dependency
- Class in wrong cluster

**Example:**
```eiffel
class MY_CLASS
feature
  test
    local
      l_obj: ARRAYED_LSIT [INTEGER]  -- VTCT: typo in class name
    do
      -- ...
    end
end
```

**Fix:**
- Check class name spelling
- Verify class is in project
- Check ECF includes necessary libraries
- Verify cluster configuration

---

### VMFN - Member Feature Name
**Category:** Members  
**Meaning:** Feature name must be unique within class

**Common Causes:**
- Duplicate feature declaration
- Inherited feature with same name not renamed
- Conflict with keyword

**Example:**
```eiffel
class MY_CLASS
feature
  count: INTEGER
  
  count: INTEGER  -- VMFN: duplicate feature name
end
```

**Fix:**
- Rename one of the features
- Use `rename` clause in inheritance
- Check for hidden conflicts

---

### VJAR - Java-like Assignment with Reference
**Category:** Types  
**Meaning:** Type must conform to expected type

**Common Causes:**
- Assigning incompatible types
- Missing type conversion
- Incorrect generic parameter

**Example:**
```eiffel
class MY_CLASS
feature
  test
    local
      l_int: INTEGER
      l_str: STRING
    do
      l_str := l_int  -- VJAR: can't assign INTEGER to STRING
    end
end
```

**Fix:**
```eiffel
-- Use conversion
l_str := l_int.out

-- Or check type hierarchy
-- Ensure types are compatible through inheritance
```

---

### VHPR - Heir Precondition
**Category:** Contracts  
**Meaning:** Redefined precondition must be equal or weaker

**Common Causes:**
- Strengthening parent's precondition
- Using `require` instead of `require else`
- Breaking Liskov Substitution Principle

**Example:**
```eiffel
deferred class PARENT
feature
  process (n: INTEGER)
    require
      positive: n > 0
    deferred
    end
end

class CHILD
inherit
  PARENT
feature
  process (n: INTEGER)
    require  -- VHPR: Wrong! Replaces parent's precondition
      larger: n > 100
    do
      -- ...
    end
end
```

**Fix:**
```eiffel
class CHILD
inherit
  PARENT
feature
  process (n: INTEGER)
    require else  -- Correct! Adds alternative
      larger: n > 100
    do
      -- ...
    end
end
```

---

### VAPE - Assertion Precondition Error
**Category:** Contracts  
**Meaning:** Precondition violated at runtime

**Common Causes:**
- Calling feature without satisfying preconditions
- Logic error in calling code
- Incorrect assumption about state

**Example:**
```eiffel
class STRING_PROCESSOR
feature
  process (s: STRING)
    require
      not_empty: not s.is_empty
    do
      -- ...
    end
end

-- Caller
local
  l_processor: STRING_PROCESSOR
  l_empty: STRING
do
  create l_empty.make_empty
  create l_processor
  l_processor.process (l_empty)  -- VAPE: violates not_empty precondition
end
```

**Fix:**
```eiffel
-- Check precondition before calling
if not l_empty.is_empty then
  l_processor.process (l_empty)
end
```

---

### VPIR - Parent Introduction Rule
**Category:** Redefinition  
**Meaning:** Feature redefinition signature must be compatible

**Common Causes:**
- Changing parameter types in redefinition
- Changing return type incompatibly
- Adding/removing parameters

**Example:**
```eiffel
deferred class PARENT
feature
  compute (n: INTEGER): INTEGER
    deferred
    end
end

class CHILD
inherit
  PARENT
feature
  compute (n: REAL): INTEGER  -- VPIR: changed parameter type
    do
      Result := n.truncated_to_integer
    end
end
```

**Fix:**
- Keep signature exactly the same
- Or use covarian return types (allowed)
- Or don't redefine, create new feature

---

## Additional Codes (In JSON Catalog)

### VHAY - Heir Assertion
**Category:** Contracts  
**Meaning:** Postcondition must be equal or stronger than parent

**Fix:** Use `ensure then` to add guarantees, not replace them

---

### VWOE - Wrong Once Execution
**Category:** Usage  
**Meaning:** Once feature cannot be called on separate target

**Fix:** Review SCOOP usage and once feature semantics

---

## Categories Explained

### Entities
Issues with names, declarations, and scope of program entities (features, variables, classes)

### Types
Type conformance, class types, generic parameters

### Usage
Proper usage of features, targets, void-safety

### Members
Class member issues - features, attributes

### Redefinition
Inheritance, feature redefinition, signature compatibility

### Contracts
Design by Contract - preconditions, postconditions, invariants

### Generics
Generic parameter constraints and usage

### Concurrency
SCOOP and concurrent programming issues

---

## Quick Diagnostic Guide

### "Cannot find feature/class"
→ Likely VEEN (entity) or VTCT (type)

### "Void target"
→ Likely VUTA (usage)

### "Type mismatch"
→ Likely VJAR (conformance)

### "Duplicate feature"
→ Likely VMFN (members)

### "Contract violation"
→ Likely VAPE (precondition) or VHPR/VHAY (inheritance)

### "Redefinition error"
→ Likely VPIR (signature)

---

## Tips for Avoiding Common Errors

1. **Use `if attached` for detachable types**
   - Prevents VUTA errors
   - Makes void-safety explicit

2. **Check preconditions before calling**
   - Prevents VAPE errors
   - Documents assumptions

3. **Use `require else` and `ensure then`**
   - Prevents VHPR/VHAY errors
   - Proper contract inheritance

4. **Verify class names and imports**
   - Prevents VEEN/VTCT errors
   - Check spelling carefully

5. **Keep signatures compatible**
   - Prevents VPIR errors
   - Use covariance carefully

---

## Resources

- **ECMA-367 Standard:** Full specification of Eiffel language
- **EiffelStudio Documentation:** Error code reference
- **Eiffel Style Guide:** Best practices for avoiding errors

---

**This reference covers the most common 85% of compilation errors in Eiffel development.**
