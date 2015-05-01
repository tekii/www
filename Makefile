M4 = $(shell which m4)

__EN__ := en
__ES__ := es

ROOT_TGT:=/tmp/bucket
GZIP_TGT:=/tmp/bucketgz

CSS:=css
IMG:=img
JS :=js
FONTS:=fonts

EN_TGT :=$(ROOT_TGT)/$(__EN__)
ES_TGT :=$(ROOT_TGT)/$(__ES__)
CSS_TGT:=$(ROOT_TGT)/$(CSS)
IMG_TGT:=$(ROOT_TGT)/$(IMG)
JS_TGT :=$(ROOT_TGT)/$(JS)
FONTS_TGT:=$(ROOT_TGT)/$(FONTS)
SOURCE	= .
vpath %.css $(CSS)
vpath %.png $(IMG)
vpath %.js  $(JS)
BOOTSTRAP_FILE=bootstrap.min.css
GLYPH:=glyphicons-halflings-regular

PAGES := about.html contact.html
HTML_FILES:= 404.html index.html
HTML_FILES+= $(addprefix $(__EN__)/,$(PAGES)) 
HTML_FILES+= $(addprefix $(__ES__)/,$(PAGES))

GLYPH_FILES:= $(GLYPH).eot $(GLYPH).svg $(GLYPH).ttf $(GLYPH).woff $(GLYPH).woff2
CSS_FILES:= $(BOOTSTRAP_FILE)
IMG_FILES+= us.png es.png logo.png

ALL_FILES:= $(HTML_FILES)  
ALL_FILES+= $(addprefix $(CSS)/, $(CSS_FILES))
ALL_FILES+= favicon.ico 
ALL_FILES+= $(addprefix $(IMG)/, $(IMG_FILES))
ALL_FILES+= $(addprefix $(FONTS)/, $(GLYPH_FILES))
ALL_FILES+= sitemap.xml

ALL_TGTS:= $(addprefix $(ROOT_TGT)/, $(ALL_FILES))
ALL_GZIP_TGTS:= $(addprefix $(GZIP_TGT)/, $(ALL_FILES))


M4_FLAGS= -P -D __IMAGES__=\/img -D __BOOTSTRAP_FILE__=$(BOOTSTRAP_FILE) \
 -D __EN__=$(__EN__) -D __ES__=$(__ES__) \
 -D __LANG__=$(__LANG__) -D __DOMAIN__="$(__DOMAIN__)" -I $(SOURCE) 

$(ROOT_TGT) $(EN_TGT) $(ES_TGT) $(CSS_TGT) $(IMG_TGT) $(JS_TGT) $(FONTS_TGT): 
	mkdir -p $@

#$(ROOT_TGT)/% : $(ROOT_TGT)
#$(EN_TGT)/% : | $(EN_TGT)
#$(ES_TGT)/% : | $(ES_TGT) 

$(ROOT_TGT)/% : __LANG__=$(__EN__) 
$(EN_TGT)/% : __LANG__=$(__EN__) -D __ALTERNATE__=1
$(ES_TGT)/% : __LANG__=$(__ES__) -D __ALTERNATE__=1

#$(EN_TGT)/%.html : $(SOURCE)/%.html
#$(ES_TGT)/%.html : $(SOURCE)/%.html

INCLUDE_FILES = $(SOURCE)/layout.html $(SOURCE)/tpy.m4 $(SOURCE)/meta.json $(SOURCE)/$(CSS)/custom.css

#$(ROOT_TGT)/%.html : $(SOURCE)/%.html $(INCLUDE_FILES) | $(ROOT_TGT)
#	$(M4) $(M4_FLAGS) -D __FNAME__=$(@F) -D __BASE__=$(@D) -D __ROOT__=$(ROOT_TGT) layout.html >$@

$(ROOT_TGT)/%.html $(EN_TGT)/%.html  : $(SOURCE)/%.html $(INCLUDE_FILES) | $(ROOT_TGT) $(EN_TGT) $(ES_TGT)
	$(M4) $(M4_FLAGS) -D __FNAME__=$(@F) -D __BASE__=$(@D) -D __ROOT__=$(ROOT_TGT) layout.html >$@

$(ES_TGT)/%.html : $(SOURCE)/%.html $(INCLUDE_FILES) | $(ES_TGT)
	$(M4) $(M4_FLAGS) -D __FNAME__=$(@F) -D __BASE__=$(@D) -D __ROOT__=$(ROOT_TGT) layout.html >$@

#%.html : $(SOURCE)/%.html $(INCLUDE_FILES) | $(ROOT_TGT) $(ES_TGT) $(EN_TGT)
#	$(M4) $(M4_FLAGS) -D __FNAME__=$(@F) -D __BASE__=$(@D) -D __ROOT__=$(ROOT_TGT) layout.html >$@


$(ROOT_TGT)/sitemap.xml : $(SOURCE)/sitemap.xml 
	$(M4) $(M4_FLAGS) -D __FNAME__=$(@F) \
	-D __LIST__="$(filter-out 404.html,$(HTML_FILES))" $(SOURCE)/sitemap.xml >$@

$(ROOT_TGT)/favicon.ico : $(SOURCE)/favicon.ico | $(ROOT_TGT)
	cp $< $@

$(CSS_TGT)/%.css : $(CSS)/%.css | $(CSS_TGT)
	cp $< $@

$(IMG_TGT)/% : $(IMG)/% | $(IMG_TGT)
	cp $< $@

$(JS_TGT)/%.js : $(JS)/%.js | $(JS_TGT)
	cp $< $@

$(FONTS_TGT)/$(GLYPH).% : $(FONTS)/$(GLYPH).% | $(FONTS_TGT)
	cp $< $@
	
$(GZIP_TGT)/%: $(ROOT_TGT)/% 
	mkdir -p $(dir $@)
	gzip -c --no-name --rsyncable $< >$@
	@echo "###gsutil --mime  $(shell mimetype --brief $< | tr -d '\n') cp $@ gs://www.tekii.com.ar$(subst $(GZIP_TGT),,$(dir $@))"

PHONY += testm4
testm4:
	$(M4) $(M4_FLAGS) --debug=aeqt -D __FNAME__="test_tpy.m4" -D __BASE__=$(@D) -D __ROOT__=$(ROOT_TGT) test_tpy.m4	

PHONY += tekii
tekii: $(ALL_TGTS) 
tekii: __DOMAIN__:=http://www.tekii.com.ar

PHONY += publish
publish: $(ALL_GZIP_TGTS) 
publish: __DOMAIN__:=http://www.tekii.com.ar

PHONY += all
all: $(ALL_TGTS) 



PHONY += clean
clean:
	rm -f $(ALL_TGTS)
	rm -f $(ALL_GZIP_TGTS)
	rmdir $(EN_TGT) $(ES_TGT) $(CSS_TGT) $(IMG_TGT) $(FONTS_TGT)
	rmdir $(ROOT_TGT)

PHONY += cleangz
cleangz:
	rm -f $(ALL_GZIP_TGTS)

#gsutil -m rsync -ndr ../bucket/ gs://www.teky.io 
#gsutil web set -m en/index.html -e en/404.html gs://www.teky.io
#gsutil acl ch -r -u AllUsers:R gs://www.teky.io/
# mimetype --brief /tmp/bucketgz/favicon.ico | tr -d '\n'

.PHONY: $(PHONY)
.DEFAULT_GOAL := tekii
