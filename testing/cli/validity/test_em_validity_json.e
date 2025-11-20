note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_EM_VALIDITY_JSON

inherit
	TEST_SET_BASE_WITH_CONSTANTS

feature -- Test routines

	test_validity_json
			-- Test that our JSON in EM_VALIDITY_JSON is valid and comes back pretty-printed like
			-- we think it should.
		local
			l_json_content: EM_VALIDITY_JSON
			l_json: SIMPLE_JSON
			l_json_value: SIMPLE_JSON_VALUE
		do
			create l_json_content
			create l_json
			l_json_value := l_json.parse (l_json_content.validity_json)
			check attached l_json.parse (l_json_content.validity_json) as al_json_value then
				assert ("object?", al_json_value.is_object)
				assert_strings_equal_diff ("contents", l_json_content.validity_json, al_json_value.to_pretty_json) -- + {STRING_32} "%N")
			end

		end

end


