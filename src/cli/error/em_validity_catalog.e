note
	description: "[
		Catalog of ECMA-367 validity error codes with descriptions.
		Provides lookup of error codes to get helpful explanations.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	EM_VALIDITY_CATALOG

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize catalog with known error codes
		do
			create codes.make (100)
			load_common_codes
		ensure
			codes_attached: codes /= Void
			has_common_codes: codes.count > 0
		end

	load_common_codes
			-- Load most commonly encountered error codes
		local
			l_category: EM_VALIDITY_CATEGORY
		do
			create l_category.make ("dummy")
			
			-- VEEN - Entities (most common during development)
			add_code ("VEEN", 
				"Entity name must be properly declared. Check spelling, imports, and scope.",
				l_category.entities)
			
			-- VUTA - Usage/Target (void-safety violations)
			add_code ("VUTA",
				"Target must be attached (not void). Use 'if attached' pattern or ensure initialization.",
				l_category.usage)
			
			-- VTCT - Types (class name errors)
			add_code ("VTCT",
				"Type must be a valid class name. Check that class exists and is properly imported.",
				l_category.types)
			
			-- VMFN - Members (feature name conflicts)
			add_code ("VMFN",
				"Feature name must be unique within class. Check for conflicting feature names.",
				l_category.members)
			
			-- VJAR - Types (conformance errors)
			add_code ("VJAR",
				"Type must conform to expected type. Check inheritance hierarchy and conversions.",
				l_category.types)
			
			-- VHPR - Preconditions (contract inheritance)
			add_code ("VHPR",
				"Precondition must be equal or weaker than parent. Use 'require else' for additional alternatives.",
				l_category.contracts)
			
			-- VAPE - Assertions (precondition violations)
			add_code ("VAPE",
				"Precondition violation. Ensure all required conditions are met before calling feature.",
				l_category.contracts)
			
			-- VPIR - Redefinition (inheritance conflicts)
			add_code ("VPIR",
				"Feature redefinition must maintain signature compatibility. Check parameter and return types.",
				l_category.redefinition)
		end

feature -- Access

	codes: HASH_TABLE [EM_VALIDITY_CODE, STRING]
			-- Map of error code to validity code info

	has_code (a_code: STRING): BOOLEAN
			-- Does catalog contain `a_code'?
		require
			code_attached: a_code /= Void
			code_not_empty: not a_code.is_empty
		do
			Result := codes.has (a_code)
		end

	code_info (a_code: STRING): detachable EM_VALIDITY_CODE
			-- Get information for `a_code' if available
		require
			code_attached: a_code /= Void
			code_not_empty: not a_code.is_empty
		do
			if codes.has (a_code) then
				Result := codes.item (a_code)
			end
		ensure
			has_code_implies_result: has_code (a_code) implies Result /= Void
		end

feature -- Element change

	add_code (a_code: STRING; a_description: STRING; a_category: EM_VALIDITY_CATEGORY)
			-- Add error code with description and category
		require
			code_attached: a_code /= Void
			code_not_empty: not a_code.is_empty
			description_attached: a_description /= Void
			description_not_empty: not a_description.is_empty
			category_attached: a_category /= Void
		local
			l_validity_code: EM_VALIDITY_CODE
		do
			create l_validity_code.make (a_code, a_description, a_category)
			codes.force (l_validity_code, a_code)
		ensure
			code_added: has_code (a_code)
			code_retrievable: attached code_info (a_code) as l_code implies
				l_code.code ~ a_code and l_code.description ~ a_description
		end

invariant
	codes_attached: codes /= Void

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
