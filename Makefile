COMPILE_FLAGS=-e require:process -p soup
TEST_FLAGS=-e require:process:describe:it

_build = $(1) -i main.soup -o $(2)

all:
	$(call _build,./soup.js $(COMPILE_FLAGS),soup.js)

recursive:all
	$(call _build,node ./soup.js $(COMPILE_FLAGS),soup-recur.js)

recursivecheck:recursive
	$(call _build,node ./soup-recur.js $(COMPILE_FLAGS),soup-recur-recur.js)
	sha1sum soup-recur.js soup-recur-recur.js

_unittest = $(1) $(TEST_FLAGS) -i test.soup -o test.js && mocha --bail test.js
_sampletest = $(1) -e require -i test/sample-test.soup | node

runtest:all
	$(call _unittest,./soup.js)
	$(call _sampletest,./soup.js)

recursivetest:recursive
	$(call _unittest,./soup.js)
	$(call _unittest,node ./soup.js)
	$(call _unittest,node ./soup-recur.js)
	$(call _sampletest,./soup.js)
	$(call _sampletest,node ./soup.js)
	$(call _sampletest,node ./soup-recur.js)

unittest:all
	$(call _unittest,soup)

sample-test:all
	$(call _sampletest,soup)
	$(call _sampletest,node ./soup.js)

clean:
	find -type f -name "*.js" -exec rm {} \;
	rm -f soup.js
