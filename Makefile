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

M4_FLAGS= -P -D __IMAGES__=\/img -D __BOOTSTRAP_FILE__=$(BOOTSTRAP_FILE) \
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


CSS_DEPS = css

$(BUCKET)/favicon.ico : $(SOURCE)/favicon.ico | $(BUCKET)
	cp $< $@

$(BUCKET)/%.html : $(SOURCE)/%.html $(SOURCE)/layout2.html | $(BUCKET)
	$(M4) $(M4_FLAGS) -D __FNAME__=$(@F) layout2.html >$@

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

EN_PAGES = $(EN_ROOT)/about.html $(EN_ROOT)/contact.html 
ES_PAGES = $(ES_ROOT)/about.html $(ES_ROOT)/contact.html 
ALL_PAGES = $(BUCKET)/404.html $(BUCKET)/index.html \
 $(EN_PAGES) $(ES_PAGES) $(CSS_ROOT)/$(BOOTSTRAP_FILE) \
 $(CSS_ROOT)/footer.css $(JS_ROOT)/main.js $(BUCKET)/favicon.ico \
 $(IMG_ROOT)/us.png $(IMG_ROOT)/es.png

all: $(ALL_PAGES) $(SOURCE)/Makefile

clean:
	rm -f $(ALL_PAGES)
	rmdir $(EN_ROOT) $(ES_ROOT) $(CSS_ROOT) $(JS_ROOT) $(IMG_ROOT)
	rmdir $(BUCKET)


#gsutil -m rsync -ndr ../bucket/ gs://www.teky.io 
#gsutil web set -m en/index.html -e en/404.html gs://www.teky.io
#gsutil acl ch -r -u AllUsers:R gs://www.teky.io/