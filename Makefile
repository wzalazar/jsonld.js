TESTS = tests/test.js
REPORTER = spec

all:

test: test-node test-browser \
  test-normalization-node test-normalization-browser \
	test-embed-api-node test-embed-api-browser \
	test-named-graph-framing-node test-named-graph-framing-browser

test-suite: test-suite-node test-suite-browser

test-suite-node:
	@if [ "x$(JSONLD_TEST_SUITE)" = x ]; then \
		echo "Error: JSONLD_TEST_SUITE env var not set"; \
		exit 1; \
	fi
	@if [ -d $(JSONLD_TEST_SUITE) ]; then \
		NODE_ENV=test ./node_modules/.bin/mocha -A -R $(REPORTER) $(TESTS); \
	else \
		echo "Error: tests not found at $(JSONLD_TEST_SUITE)"; \
		exit 1; \
	fi

test-suite-browser:
	@if [ "x$(JSONLD_TEST_SUITE)" = x ]; then \
		echo "Error: JSONLD_TEST_SUITE env var not set"; \
		exit 1; \
	fi
	@if [ -d ../json-ld.org/test-suite ]; then \
		NODE_ENV=test ./node_modules/.bin/phantomjs $(TESTS); \
	else \
		echo "Error: tests not found at $(JSONLD_TEST_SUITE)"; \
		exit 1; \
	fi

test-node:
	@JSONLD_TEST_SUITE=../json-ld.org/test-suite $(MAKE) test-suite-node

test-browser:
	@JSONLD_TEST_SUITE=../json-ld.org/test-suite $(MAKE) test-suite-browser

test-normalization-node:
	@JSONLD_TEST_SUITE=../normalization/tests $(MAKE) test-suite-node

test-normalization-browser:
	@JSONLD_TEST_SUITE=../normalization/tests $(MAKE) test-suite-browser

test-embed-api-node:
	@JSONLD_TEST_SUITE=./tests/new-embed-api $(MAKE) test-suite-node

test-embed-api-browser:
	@JSONLD_TEST_SUITE=./tests/new-embed-api $(MAKE) test-suite-browser

test-named-graph-framing-node:
	@JSONLD_TEST_SUITE=./tests/named-graph-framing $(MAKE) test-suite-node

test-named-graph-framing-browser:
	@JSONLD_TEST_SUITE=./tests/named-graph-framing $(MAKE) test-suite-browser

test-coverage:
	./node_modules/.bin/istanbul cover ./node_modules/.bin/_mocha -- \
		-u exports -R $(REPORTER) $(TESTS)

clean:
	rm -rf coverage

.PHONY: test test-node test-browser \
  test-normalization-node test-normalization-browser \
	test-embed-api-node test-embed-api-browser \
	test-named-graph-framing-node test-named-graph-framing-browser \
	test-coverage clean
