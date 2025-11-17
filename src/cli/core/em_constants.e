note
	description: "[
		Named constants for EifMate project.
		Replaces all magic values with semantically meaningful names.
		
		Provides constants for:
		- Error severity levels
		- Request types
		- Default values
		- JSON keys
		- File paths
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EM_CONSTANTS

feature -- Error severity levels

	Error_severity_error: INTEGER = 1
			-- Error severity level

	Error_severity_warning: INTEGER = 2
			-- Warning severity level

	Error_severity_info: INTEGER = 3
			-- Informational severity level

feature -- Request types

	Request_type_compile: STRING_8 = "compile"
			-- Standard compile request

	Request_type_compile_clean: STRING_8 = "compile_clean"
			-- Clean compile request

	Request_type_freeze: STRING_8 = "freeze"
			-- Freeze compile request

	Request_type_finalize: STRING_8 = "finalize"
			-- Finalize compile request

	Request_type_test: STRING_8 = "test"
			-- Test execution request

	Request_type_query: STRING_8 = "query"
			-- Code query request (flat, flatshort, etc.)

feature -- Query subtypes

	Query_type_flat: STRING_8 = "flat"
			-- Flat view query

	Query_type_flatshort: STRING_8 = "flatshort"
			-- Interface view query

	Query_type_clients: STRING_8 = "clients"
			-- Client classes query

	Query_type_suppliers: STRING_8 = "suppliers"
			-- Supplier classes query

	Query_type_descendants: STRING_8 = "descendants"
			-- Descendant classes query

	Query_type_ancestors: STRING_8 = "ancestors"
			-- Ancestor classes query

feature -- JSON keys

	Json_key_request_type: STRING_8 = "type"
			-- Request type key in JSON

	Json_key_ecf_path: STRING_8 = "ecf_path"
			-- ECF file path key

	Json_key_target: STRING_8 = "target"
			-- Target name key

	Json_key_class_name: STRING_8 = "class_name"
			-- Class name key

	Json_key_query_type: STRING_8 = "query_type"
			-- Query type key

	Json_key_success: STRING_8 = "success"
			-- Success flag key

	Json_key_output: STRING_8 = "output"
			-- Raw output key

	Json_key_errors: STRING_8 = "errors"
			-- Errors array key

	Json_key_warnings: STRING_8 = "warnings"
			-- Warnings array key

	Json_key_timestamp: STRING_8 = "timestamp"
			-- Timestamp key

	Json_key_error_code: STRING_8 = "code"
			-- Error code key

	Json_key_message: STRING_8 = "message"
			-- Message key

	Json_key_severity: STRING_8 = "severity"
			-- Severity key

	Json_key_file_path: STRING_8 = "file"
			-- File path key

	Json_key_line_number: STRING_8 = "line"
			-- Line number key

	Json_key_feature_name: STRING_8 = "feature"
			-- Feature name key

	Json_key_suggestion: STRING_8 = "suggestion"
			-- Suggestion key

feature -- Default values

	Default_buffer_size: INTEGER = 4096
			-- Default buffer size for string operations

	Default_max_errors: INTEGER = 100
			-- Maximum number of errors to collect

feature -- Version

	Eifmate_version: STRING_8 = "0.1.0"
			-- Current EifMate version

note
	copyright: "Copyright (c) 2024, Larry Rix"
	license: "MIT License"
	source: "[
		EifMate - Claude-to-EiffelStudio Bridge
		https://github.com/ljr1981/eifmate
	]"

end
