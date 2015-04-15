M4 = $(shell which m4)

EN_PARTICLE = en
ES_PARTICLE = es

BUCKET 	= /tmp/bucket
EN_ROOT = $(BUCKET)/$(EN_PARTICLE)
ES_ROOT = $(BUCKET)/$(ES_PARTICLE)
CSS_ROOT= $(BUCKET)/css
IMG_ROOT= $(BUCKET)/img
JS_ROOT	= $(BUCKET)/js

SOURCE	= .

BOOTSTRAP_FILE=bootstrap.css

M4_FLAGS=-D IMAGES=\/img -D __BOOTSTRAP_FILE__=$(BOOTSTRAP_FILE) \
 -D __EN__=$(EN_PARTICLE) -D __ES__=$(ES_PARTICLE) -I $(SOURCE)

EN_FLAGS=-D __LANG__=$(EN_PARTICLE)
ES_FLAGS=-D __LANG__=$(ES_PARTICLE)


SOURCE_M4 = index.m4.html faq.m4.html
PAGES = $(subst .m4.,.en.,$(SOURCE_M4)) $(subst .m4.,.sp.,$(SOURCE_M4))


$(BUCKET):
	mkdir -p $(BUCKET)

$(EN_ROOT):
	mkdir -p $(EN_ROOT)

$(ES_ROOT):
	mkdir -p $(ES_ROOT)

$(CSS_ROOT):
	mkdir -p $(CSS_ROOT)

$(IMG_ROOT):
	mkdir -p $(IMG_ROOT)

$(JS_ROOT):
	mkdir -p $(JS_ROOT)


EN_PAGES = $(EN_ROOT)/index.html $(EN_ROOT)/about.html $(EN_ROOT)/contact.html $(EN_ROOT)/faq.html
ES_PAGES = $(ES_ROOT)/index.html $(ES_ROOT)/about.html $(ES_ROOT)/contact.html $(ES_ROOT)/faq.html

CSS_DEPS = css

$(BUCKET)/favicon.ico : $(SOURCE)/favicon.ico | $(BUCKET)
	cp $< $@

INCLUDE_FILES = $(SOURCE)/layout.html

$(EN_ROOT)/%.html : $(SOURCE)/%.html $(INCLUDE_FILES) | $(EN_ROOT)
	$(M4) $(M4_FLAGS) $(EN_FLAGS) -D __FNAME__=$(@F) layout.html >$@

$(ES_ROOT)/%.html : $(SOURCE)/%.html $(INCLUDE_FILES) | $(ES_ROOT)
	$(M4) $(M4_FLAGS) $(ES_FLAGS) -D __FNAME__=$(@F) layout.html >$@

$(CSS_ROOT)/%.css : css/%.css | $(CSS_ROOT)
	cp $< $@

$(IMG_ROOT)/% : img/% | $(IMG_ROOT)
	cp $< $@

$(JS_ROOT)/%.js : js/%.js | $(JS_ROOT)
	cp $< $@

ALL_FILES = $(EN_PAGES) $(ES_PAGES) $(CSS_ROOT)/$(BOOTSTRAP_FILE) \
 $(CSS_ROOT)/local.css $(CSS_ROOT)/footer.css $(JS_ROOT)/main.js $(BUCKET)/favicon.ico

all: $(ALL_FILES) $(SOURCE)/Makefile

clean:
	rm -f $(ALL_FILES)
	rmdir $(EN_ROOT) $(ES_ROOT) $(CSS_ROOT) $(JS_ROOT)
	rmdir $(BUCKET)


#gsutil -m rsync -ndr ../bucket/ gs://www.teky.io 
