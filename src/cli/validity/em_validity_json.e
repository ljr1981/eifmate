note
	description: "[
		Complete ECMA-367 validity codes catalog with descriptions and common causes.
		Extracted from ECMA-367 2nd Edition (June 2006).
		
		This JSON catalog provides:
		- All 87 validity codes from the Eiffel standard
		- Category classification for each code
		- Human-readable descriptions
		- Common causes to help diagnose errors
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=ECMA-367 Standard", "src=https://www.ecma-international.org/publications/standards/Ecma-367.htm", "tag=eiffel,standard"

class
	EM_VALIDITY_JSON

feature -- Constants

	validity_json: STRING_32 = "[
{
  "validity_codes": [
    {
      "code": "VEEN",
      "category": "Entities",
      "description": "Entity name must be properly declared. Check spelling, imports, and scope.",
      "common_causes": [
        "Typo in feature or variable name",
        "Missing inheritance or import",
        "Incorrect scope or visibility"
      ]
    },
    {
      "code": "VUTA",
      "category": "Usage",
      "description": "Target must be attached (not void). Use 'if attached' pattern or ensure initialization.",
      "common_causes": [
        "Calling feature on potentially void reference",
        "Missing initialization",
        "Incorrect use of detachable types"
      ]
    },
    {
      "code": "VTCT",
      "category": "Types",
      "description": "Type must be a valid class name. Check that class exists and is properly imported.",
      "common_causes": [
        "Class name misspelled",
        "Class not in project",
        "Missing library dependency"
      ]
    },
    {
      "code": "VMFN",
      "category": "Members",
      "description": "Feature name must be unique within class. Check for conflicting feature names.",
      "common_causes": [
        "Duplicate feature declaration",
        "Inherited feature with same name",
        "Name conflict with keyword"
      ]
    },
    {
      "code": "VJAR",
      "category": "Types",
      "description": "Type must conform to expected type. Check inheritance hierarchy and conversions.",
      "common_causes": [
        "Incompatible type assignment",
        "Missing type conversion",
        "Incorrect generic parameter"
      ]
    },
    {
      "code": "VHPR",
      "category": "Contracts",
      "description": "Precondition must be equal or weaker than parent. Use 'require else' for additional alternatives.",
      "common_causes": [
        "Strengthening parent precondition",
        "Using 'require' instead of 'require else'",
        "Breaking Liskov Substitution Principle"
      ]
    },
    {
      "code": "VAPE",
      "category": "Contracts",
      "description": "Precondition violation. Ensure all required conditions are met before calling feature.",
      "common_causes": [
        "Calling feature without satisfying preconditions",
        "Logic error in calling code",
        "Incorrect assumption about state"
      ]
    },
    {
      "code": "VPIR",
      "category": "Redefinition",
      "description": "Feature redefinition must maintain signature compatibility. Check parameter and return types.",
      "common_causes": [
        "Changing feature signature in redefinition",
        "Incompatible parameter types",
        "Incompatible return type"
      ]
    },
    {
      "code": "VHAY",
      "category": "Contracts",
      "description": "Postcondition must be equal or stronger than parent. Use 'ensure then' to add guarantees.",
      "common_causes": [
        "Weakening parent postcondition",
        "Using 'ensure' instead of 'ensure then'",
        "Breaking contract strengthening rule"
      ]
    },
    {
      "code": "VWOE",
      "category": "Usage",
      "description": "Unary or binary operator expression must be valid. Check operator overloading.",
      "common_causes": [
        "Invalid operator usage",
        "Operator not defined for type",
        "Operator signature mismatch"
      ]
    },
    {
      "code": "VBAR",
      "category": "Assignment",
      "description": "Assignment source must be compatible with target entity type.",
      "common_causes": [
        "Type mismatch in assignment",
        "Missing conversion",
        "Incompatible conformance"
      ]
    },
    {
      "code": "VBAC",
      "category": "Assignment",
      "description": "Assigner call (target := source) must have compatible types.",
      "common_causes": [
        "Assigner command not properly defined",
        "Type incompatibility in assigner call",
        "Missing assigner mark in feature"
      ]
    },
    {
      "code": "VBGV",
      "category": "System",
      "description": "General validity: all validity constraints must be satisfied.",
      "common_causes": [
        "Multiple validity violations",
        "System-wide inconsistency",
        "Compound validity error"
      ]
    },
    {
      "code": "VCCH",
      "category": "Class",
      "description": "Class header must be properly formed with valid deferred/effective status.",
      "common_causes": [
        "Mixing deferred and effective features incorrectly",
        "Missing 'deferred' keyword for abstract class",
        "Deferred class has no deferred features"
      ]
    },
    {
      "code": "VCFG",
      "category": "Generics",
      "description": "Formal generic parameters must have unique names in class declaration.",
      "common_causes": [
        "Duplicate generic parameter names",
        "Generic parameter conflicts with class name",
        "Invalid generic constraint"
      ]
    },
    {
      "code": "VDJR",
      "category": "Inheritance",
      "description": "Join rule: features inherited under same name must be properly handled.",
      "common_causes": [
        "Feature name conflict from multiple inheritance",
        "Missing select or rename clause",
        "Invalid feature sharing"
      ]
    },
    {
      "code": "VDPR",
      "category": "Inheritance",
      "description": "Precursor call must reference valid parent feature.",
      "common_causes": [
        "Precursor called in non-redefined feature",
        "Parent feature not found",
        "Ambiguous precursor call"
      ]
    },
    {
      "code": "VDRD",
      "category": "Redefinition",
      "description": "Redeclaration must properly override inherited feature with compatible signature.",
      "common_causes": [
        "Signature incompatibility in redefinition",
        "Return type not covariant",
        "Argument types not contravariant"
      ]
    },
    {
      "code": "VDRS",
      "category": "Redefinition",
      "description": "Redefine clause must list valid inherited features to redefine.",
      "common_causes": [
        "Redefined feature not inherited",
        "Feature name misspelled in redefine clause",
        "Attempting to redefine frozen feature"
      ]
    },
    {
      "code": "VDUS",
      "category": "Redefinition",
      "description": "Undefine clause must list valid inherited features to undefine.",
      "common_causes": [
        "Undefined feature not inherited",
        "Cannot undefine deferred feature",
        "Feature name misspelled in undefine clause"
      ]
    },
    {
      "code": "VEVA",
      "category": "Entities",
      "description": "Variable entity must be properly declared (attribute, local, or formal argument).",
      "common_causes": [
        "Undeclared variable",
        "Variable used before declaration",
        "Scope violation"
      ]
    },
    {
      "code": "VEVI",
      "category": "Entities",
      "description": "Expression used as variable must be valid writable entity.",
      "common_causes": [
        "Attempting to assign to query result",
        "Assigning to non-variable expression",
        "Missing assigner command"
      ]
    },
    {
      "code": "VFAC",
      "category": "Features",
      "description": "Assigner mark must reference valid command feature for assignment.",
      "common_causes": [
        "Assigner feature not found",
        "Assigner signature mismatch",
        "Assigner on procedure feature"
      ]
    },
    {
      "code": "VFAV",
      "category": "Features",
      "description": "Alias clause must be valid for feature signature (operators, brackets, etc).",
      "common_causes": [
        "Alias used with wrong number of arguments",
        "Invalid operator alias",
        "Bracket alias on non-query"
      ]
    },
    {
      "code": "VFFB",
      "category": "Features",
      "description": "Feature value (attribute or constant) must be properly initialized.",
      "common_causes": [
        "Uninitialized attribute",
        "Invalid manifest constant",
        "Type mismatch in feature value"
      ]
    },
    {
      "code": "VFFD",
      "category": "Features",
      "description": "Feature declaration must be well-formed with valid signature and body.",
      "common_causes": [
        "Missing return type for function",
        "Procedure declared with return type",
        "Invalid feature body"
      ]
    },
    {
      "code": "VGCC",
      "category": "Creation",
      "description": "Creation clause must list valid creation procedures.",
      "common_causes": [
        "Creation procedure not found",
        "Non-procedure listed as creator",
        "Creation procedure has precondition"
      ]
    },
    {
      "code": "VGCE",
      "category": "Creation",
      "description": "Creation expression must have valid creation type and procedure.",
      "common_causes": [
        "Creating expression of deferred type",
        "Creation procedure not available",
        "Type mismatch in creation"
      ]
    },
    {
      "code": "VGCI",
      "category": "Creation",
      "description": "Creation instruction must use valid creation type and procedure.",
      "common_causes": [
        "Creating object of abstract class",
        "Creation procedure not exported",
        "Wrong arguments for creation procedure"
      ]
    },
    {
      "code": "VGCP",
      "category": "Creation",
      "description": "Creation type must be properly constrained (not deferred or generic).",
      "common_causes": [
        "Attempting to create instance of deferred class",
        "Unconstrained formal generic in creation",
        "Invalid expanded type creation"
      ]
    },
    {
      "code": "VGCX",
      "category": "Creation",
      "description": "Creation expression type must satisfy all constraints.",
      "common_causes": [
        "Generic constraint violation in creation",
        "Type parameter not properly bounded",
        "Creation of invalid generic type"
      ]
    },
    {
      "code": "VHCA",
      "category": "System",
      "description": "System must include non-generic class ANY as universal base.",
      "common_causes": [
        "ANY class missing from system",
        "ANY class modified incorrectly",
        "Library configuration error"
      ]
    },
    {
      "code": "VHRC",
      "category": "Inheritance",
      "description": "Rename clause must properly rename inherited feature.",
      "common_causes": [
        "Renamed feature not inherited",
        "New name conflicts with existing feature",
        "Invalid rename syntax"
      ]
    },
    {
      "code": "VHUC",
      "category": "Types",
      "description": "All types must conform to ANY (universal conformance rule).",
      "common_causes": [
        "Type system inconsistency",
        "Custom ANY replacement",
        "Library incompatibility"
      ]
    },
    {
      "code": "VIID",
      "category": "Syntax",
      "description": "Identifier cannot be a reserved word.",
      "common_causes": [
        "Using keyword as identifier (if, then, do, etc)",
        "Reserved word in feature name",
        "Invalid identifier syntax"
      ]
    },
    {
      "code": "VIIN",
      "category": "Syntax",
      "description": "Integer literal must be within valid range for its type.",
      "common_causes": [
        "Integer overflow",
        "Value exceeds INTEGER_32 range",
        "Invalid integer syntax"
      ]
    },
    {
      "code": "VLEL",
      "category": "Export",
      "description": "Export clause must properly control feature visibility.",
      "common_causes": [
        "Exported feature not found",
        "Invalid export list",
        "Export to non-existent class"
      ]
    },
    {
      "code": "VMCS",
      "category": "Inheritance",
      "description": "Repeatedly inherited shared feature must be properly resolved.",
      "common_causes": [
        "Feature sharing violation",
        "Inconsistent sharing from multiple parents",
        "Missing select clause"
      ]
    },
    {
      "code": "VMNC",
      "category": "Features",
      "description": "Feature names in class must follow uniqueness and inheritance rules.",
      "common_causes": [
        "Feature name collision",
        "Invalid inherited name combination",
        "Name resolution failure"
      ]
    },
    {
      "code": "VMRC",
      "category": "Inheritance",
      "description": "Multiple versions of feature from repeated inheritance must be valid.",
      "common_causes": [
        "Repeated inheritance without rename",
        "Feature replication issue",
        "Missing join or select"
      ]
    },
    {
      "code": "VMSS",
      "category": "Inheritance",
      "description": "Select clause must properly resolve feature name conflicts.",
      "common_causes": [
        "Selected feature not multiply inherited",
        "Invalid select list",
        "Select without name conflict"
      ]
    },
    {
      "code": "VNCC",
      "category": "Types",
      "description": "Type conformance rules must be satisfied for all type relationships.",
      "common_causes": [
        "Non-conforming type used where conformance required",
        "Breaking inheritance hierarchy",
        "Generic parameter constraint violation"
      ]
    },
    {
      "code": "VNCE",
      "category": "Types",
      "description": "No type can conform directly to expanded type (expanded types are value types).",
      "common_causes": [
        "Attempting to inherit from expanded class",
        "Treating expanded type as reference type",
        "Invalid expanded type usage"
      ]
    },
    {
      "code": "VNCF",
      "category": "Generics",
      "description": "Formal generic parameter usage must respect constraints.",
      "common_causes": [
        "Generic parameter used beyond constraint",
        "Constraint violation in generic class",
        "Invalid feature call on generic"
      ]
    },
    {
      "code": "VNCN",
      "category": "Types",
      "description": "Class type conformance must follow inheritance hierarchy rules.",
      "common_causes": [
        "Type doesn't inherit from required ancestor",
        "Generic parameter mismatch",
        "Conformance cycle"
      ]
    },
    {
      "code": "VNCS",
      "category": "Types",
      "description": "Feature signature conformance: covariant returns, contravariant arguments.",
      "common_causes": [
        "Return type not covariant in redefinition",
        "Argument type not contravariant",
        "Signature incompatibility"
      ]
    },
    {
      "code": "VNCT",
      "category": "Types",
      "description": "Tuple type conformance must match element types properly.",
      "common_causes": [
        "Tuple element type mismatch",
        "Wrong number of tuple elements",
        "Invalid tuple conformance"
      ]
    },
    {
      "code": "VOIN",
      "category": "Expressions",
      "description": "Interval (a..b) must be non-empty (a <= b).",
      "common_causes": [
        "Lower bound exceeds upper bound",
        "Invalid interval range",
        "Empty interval used incorrectly"
      ]
    },
    {
      "code": "VOMB",
      "category": "Control",
      "description": "Multi-branch (inspect) statement must have valid and complete branches.",
      "common_causes": [
        "Inspect on non-discrete type",
        "Missing else clause with incomplete cases",
        "Duplicate case values"
      ]
    },
    {
      "code": "VPCA",
      "category": "Agents",
      "description": "Call agent must reference valid feature with correct signature.",
      "common_causes": [
        "Agent feature not found",
        "Agent signature mismatch",
        "Invalid target type for agent"
      ]
    },
    {
      "code": "VPIA",
      "category": "Agents",
      "description": "Inline agent must be well-formed with valid routine body.",
      "common_causes": [
        "Inline agent syntax error",
        "Invalid agent body",
        "Agent closure variable error"
      ]
    },
    {
      "code": "VQMC",
      "category": "Features",
      "description": "Manifest constant declaration must have valid constant value.",
      "common_causes": [
        "Non-constant expression in constant",
        "Type mismatch in constant",
        "Invalid manifest constant syntax"
      ]
    },
    {
      "code": "VRED",
      "category": "Entities",
      "description": "Entity declaration must have unique identifier.",
      "common_causes": [
        "Duplicate entity name",
        "Entity name conflicts in declaration list",
        "Invalid entity declaration"
      ]
    },
    {
      "code": "VRFA",
      "category": "Routines",
      "description": "Formal arguments must have unique names within routine.",
      "common_causes": [
        "Duplicate argument names",
        "Argument name conflicts with local",
        "Invalid argument declaration"
      ]
    },
    {
      "code": "VRLV",
      "category": "Routines",
      "description": "Local variables must have unique names within routine.",
      "common_causes": [
        "Duplicate local variable names",
        "Local conflicts with argument",
        "Invalid local declaration"
      ]
    },
    {
      "code": "VSCN",
      "category": "System",
      "description": "Class names must be unique within universe (no duplicate class names).",
      "common_causes": [
        "Two classes with same name in system",
        "Class name collision between libraries",
        "Duplicate class definition"
      ]
    },
    {
      "code": "VSRP",
      "category": "System",
      "description": "Root procedure must be valid creation procedure of root type.",
      "common_causes": [
        "Root procedure not found",
        "Root procedure not exported for creation",
        "Root procedure has precondition"
      ]
    },
    {
      "code": "VSRT",
      "category": "System",
      "description": "Root type must be valid class type in system.",
      "common_causes": [
        "Root type not found in universe",
        "Root type is deferred class",
        "Invalid root type specification"
      ]
    },
    {
      "code": "VTAT",
      "category": "Types",
      "description": "Anchored type (like anchor) must reference valid anchor entity.",
      "common_causes": [
        "Anchor entity not found",
        "Circular anchored type definition",
        "Invalid anchor in signature"
      ]
    },
    {
      "code": "VTGC",
      "category": "Generics",
      "description": "Generic constraint must reference valid type.",
      "common_causes": [
        "Constraint type not found",
        "Circular generic constraint",
        "Invalid constraint specification"
      ]
    },
    {
      "code": "VTGD",
      "category": "Generics",
      "description": "Generic derivation must provide correct number of type parameters.",
      "common_causes": [
        "Wrong number of generic parameters",
        "Missing generic parameter",
        "Extra generic parameter"
      ]
    },
    {
      "code": "VTMC",
      "category": "Types",
      "description": "Feature must be applicable to target type (feature exists and is exported).",
      "common_causes": [
        "Feature not available on type",
        "Feature not exported to calling class",
        "Type doesn't support feature"
      ]
    },
    {
      "code": "VUAR",
      "category": "Usage",
      "description": "Call must be argument-valid (correct number and types of arguments).",
      "common_causes": [
        "Wrong number of arguments",
        "Argument type mismatch",
        "Missing required argument"
      ]
    },
    {
      "code": "VUCC",
      "category": "Usage",
      "description": "Call must be class-valid (export, argument, and type valid).",
      "common_causes": [
        "Calling non-exported feature",
        "Call validity violation",
        "Invalid feature call"
      ]
    },
    {
      "code": "VUCN",
      "category": "Usage",
      "description": "Call must properly denote feature (unqualified or qualified call rules).",
      "common_causes": [
        "Ambiguous feature call",
        "Call syntax error",
        "Invalid call form"
      ]
    },
    {
      "code": "VUDA",
      "category": "Usage",
      "description": "Call must be definitional (feature properly denoted by call).",
      "common_causes": [
        "Feature name ambiguity",
        "Invalid feature reference",
        "Denotational error in call"
      ]
    },
    {
      "code": "VUEX",
      "category": "Usage",
      "description": "Call must be export-valid (feature exported to calling class).",
      "common_causes": [
        "Calling private feature from outside",
        "Export clause violation",
        "Feature not visible"
      ]
    },
    {
      "code": "VUNO",
      "category": "Usage",
      "description": "Non-object call must be valid (precursor, current type feature, or static).",
      "common_causes": [
        "Invalid unqualified call",
        "Feature not available without target",
        "Missing Current target"
      ]
    },
    {
      "code": "VUOT",
      "category": "Usage",
      "description": "Object test {x: T} exp must have valid type and expression.",
      "common_causes": [
        "Object test type mismatch",
        "Invalid object test syntax",
        "Type not conforming in object test"
      ]
    },
    {
      "code": "VUSC",
      "category": "Usage",
      "description": "Call must be system-valid across all possible dynamic types.",
      "common_causes": [
        "CAT-call (Conforming Argument Type call)",
        "Polymorphic call validity issue",
        "Type safety violation in inheritance"
      ]
    },
    {
      "code": "VAON",
      "category": "Contracts",
      "description": "Old expression in postcondition 'only' clause must be valid.",
      "common_causes": [
        "'only' clause misuse",
        "Invalid old expression in only clause",
        "Only clause constraint violation"
      ]
    },
    {
      "code": "VAOX",
      "category": "Contracts",
      "description": "Old expression 'old e' must reference valid pre-state entity.",
      "common_causes": [
        "Old applied to non-persistent entity",
        "Old expression in precondition",
        "Invalid old expression context"
      ]
    },
    {
      "code": "VAVE",
      "category": "Contracts",
      "description": "Loop variant must be of type INTEGER.",
      "common_causes": [
        "Variant expression not INTEGER type",
        "Missing variant in loop",
        "Invalid variant expression"
      ]
    },
    {
      "code": "VWBE",
      "category": "Expressions",
      "description": "Basic expression used as boolean must be of type BOOLEAN.",
      "common_causes": [
        "Non-boolean expression in if/until condition",
        "Type mismatch in boolean context",
        "Missing boolean conversion"
      ]
    },
    {
      "code": "VWBR",
      "category": "Expressions",
      "description": "Bracket expression x[i] must have valid bracket feature.",
      "common_causes": [
        "Bracket alias not defined",
        "Wrong number of arguments in brackets",
        "Type mismatch in bracket call"
      ]
    },
    {
      "code": "VWCA",
      "category": "Features",
      "description": "Constant attribute must have unique name and valid constant value.",
      "common_causes": [
        "Constant name conflicts",
        "Non-constant value in constant attribute",
        "Invalid manifest constant"
      ]
    },
    {
      "code": "VWID",
      "category": "Expressions",
      "description": "Identifier in expression must reference valid entity or feature.",
      "common_causes": [
        "Undefined identifier",
        "Identifier outside valid scope",
        "Typo in identifier name"
      ]
    },
    {
      "code": "VWMQ",
      "category": "Expressions",
      "description": "Manifest constant with type qualifier must have compatible value.",
      "common_causes": [
        "Type qualifier doesn't match constant value",
        "Invalid manifest type",
        "Manifest constant type mismatch"
      ]
    },
    {
      "code": "VWVS",
      "category": "Syntax",
      "description": "Verbatim string must be properly formatted with valid delimiters.",
      "common_causes": [
        "Mismatched verbatim string delimiters",
        "Invalid verbatim string syntax",
        "Unterminated verbatim string"
      ]
    },
    {
      "code": "VXRC",
      "category": "Exceptions",
      "description": "Rescue clause only valid in routine (not in once function or inline agent).",
      "common_causes": [
        "Rescue in once function",
        "Rescue in inline agent",
        "Invalid rescue clause placement"
      ]
    },
    {
      "code": "VXRT",
      "category": "Exceptions",
      "description": "Retry instruction must appear inside rescue clause.",
      "common_causes": [
        "Retry outside rescue clause",
        "Invalid retry placement",
        "Retry in normal routine body"
      ]
    },
    {
      "code": "VYCP",
      "category": "Conversions",
      "description": "Conversion procedure must be valid command for type conversion.",
      "common_causes": [
        "Conversion procedure signature mismatch",
        "Invalid conversion procedure",
        "Conversion procedure not found"
      ]
    },
    {
      "code": "VYCQ",
      "category": "Conversions",
      "description": "Conversion query must be valid function for type conversion.",
      "common_causes": [
        "Conversion query return type mismatch",
        "Invalid conversion query",
        "Conversion query not found"
      ]
    },
    {
      "code": "VYEC",
      "category": "Conversions",
      "description": "Expression must convert properly to target entity type.",
      "common_causes": [
        "No valid conversion path",
        "Conversion rule violation",
        "Type incompatibility"
      ]
    },
    {
      "code": "VYPF",
      "category": "Contracts",
      "description": "Feature must be precondition-free for certain contexts.",
      "common_causes": [
        "Creation procedure has precondition",
        "Precondition in conversion feature",
        "Precondition where not allowed"
      ]
    },
    {
      "code": "VZCC",
      "category": "External",
      "description": "C external declaration must be properly formed.",
      "common_causes": [
        "Invalid C external syntax",
        "C signature mismatch",
        "External library not found"
      ]
    },
    {
      "code": "VZDL",
      "category": "External",
      "description": "DLL external must reference valid DLL and entry point.",
      "common_causes": [
        "DLL not found",
        "Invalid DLL entry point",
        "DLL signature mismatch"
      ]
    },
    {
      "code": "VZEF",
      "category": "External",
      "description": "External file specification must be valid path.",
      "common_causes": [
        "External file not found",
        "Invalid file path in external",
        "File access error"
      ]
    },
    {
      "code": "VZES",
      "category": "External",
      "description": "External signature must match external routine declaration.",
      "common_causes": [
        "External signature mismatch",
        "Wrong parameter types in external",
        "Return type mismatch"
      ]
    }
  ]
}
]"

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate Project
		Based on ECMA-367 2nd Edition (June 2006)
	]"

end
