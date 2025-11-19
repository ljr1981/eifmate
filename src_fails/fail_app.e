note
	description: "Summary description for {FAIL_APP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FAIL_APP

feature -- Initialization

	my_not_a_feature_fail
			--	Rule	Description	Location	Position	Severity	
			--1	VEEN	Unknown identifier `not_a_feature'.	FAIL_APP.my_not_a_feature_fail (fails)	16, 4		
			--		Error code: VEEN

			--Error: unknown identifier.
			--What to do: make sure that identifier, if needed, is final name of
			--  feature of class, or local entity or formal argument of routine.

			--Class: FAIL_APP
			--Feature: my_not_a_feature_fail
			--Identifier: not_a_feature
			--Target type: [attached like Current] attached FAIL_APP
			--Line: 16
			--        do_nothing
			--->      not_a_feature
			--      end				
		do
			do_nothing
			not_a_feature
		end

end
