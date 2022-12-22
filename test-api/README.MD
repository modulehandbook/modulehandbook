# 3rd party apis tests

These are tests to clarify and ensure 3rd party interfaces.
They are in their own folder as they don't need to run with
the app and system tests.

run with make api_test:

api_test:
	rails test test/../test-api/
