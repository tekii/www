M4 = $(shell which m4)

__EN__ := en
__ES__ := es

ROOT_TARGET:=/tmp/bucket
CSS:=css
IMG:=img
JS :=js
FONTS:=fonts
EN_TARGET :=$(ROOT_TARGET)/$(__EN__)
ES_TARGET :=$(ROOT_TARGET)/$(__ES__)
CSS_TARGET:=$(ROOT_TARGET)/$(CSS)
IMG_TARGET:=$(ROOT_TARGET)/$(IMG)
JS_TARGET :=$(ROOT_TARGET)/$(JS)
FONTS_TARGET:=$(ROOT_TARGET)/$(FONTS)
SOURCE	= .
vpath %.css $(CSS)
vpath %.png $(IMG)
vpath %.js  $(JS)
BOOTSTRAP_FILE=bootstrap.css
GLYPH:=glyphicons-halflings-regular

PAGES := about.html contact.html
HTML_FILES:= 404.html index.html
HTML_FILES+= $(addprefix $(__EN__)/,$(PAGES)) 
HTML_FILES+= $(addprefix $(__ES__)/,$(PAGES))

GLYPH_FILES:= $(GLYPH).eot $(GLYPH).svg $(GLYPH).ttf $(GLYPH).woff $(GLYPH).woff2

ALL_FILES:= $(HTML_FILES)  
ALL_FILES+= $(CSS)/$(BOOTSTRAP_FILE) $(CSS)/custom.css 
ALL_FILES+= $(JS)/main.js favicon.ico 
ALL_FILES+= $(IMG)/us.png $(IMG)/es.png 
ALL_FILES+= $(addprefix $(FONTS)/, $(GLYPH_FILES))
ALL_FILES+= sitemap.xml

ALL_TARGETS = $(addprefix $(ROOT_TARGET)/, $(ALL_FILES))


M4_FLAGS= -P -D __IMAGES__=\/img -D __BOOTSTRAP_FILE__=$(BOOTSTRAP_FILE) \
 -D __EN__=$(__EN__) -D __ES__=$(__ES__) \
 -D __LANG__=$(__LANG__) -D __DOMAIN__="$(__DOMAIN__)" -I $(SOURCE) 

$(ROOT_TARGET) $(EN_TARGET) $(ES_TARGET) $(CSS_TARGET) $(IMG_TARGET) $(JS_TARGET) $(FONTS_TARGET): 
	mkdir -p $@

$(ROOT_TARGET)/%.html : $(SOURCE)/%.html $(SOURCE)/layout2.html $(SOURCE)/meta.json | $(ROOT_TARGET)
	$(M4) $(M4_FLAGS) -D __FNAME__=$(@F) layout2.html >$@

$(EN_TARGET)/% : | $(EN_TARGET)
$(ES_TARGET)/% : | $(ES_TARGET) 

$(EN_TARGET)/% : __LANG__=$(__EN__) 
$(ES_TARGET)/% : __LANG__=$(__ES__) 

$(ROOT_TARGET)/%.html : $(SOURCE)/%.html $(SOURCE)/layout2.html $(SOURCE)/tpy.m4 | $(ROOT_TARGET)
	$(M4) $(M4_FLAGS) -D __FNAME__=$(@F) layout2.html >$@

INCLUDE_FILES = $(SOURCE)/layout.html $(SOURCE)/tpy.m4 $(SOURCE)/meta.json

$(EN_TARGET)/%.html : $(SOURCE)/%.html $(INCLUDE_FILES) | $(EN_TARGET)
	$(M4) $(M4_FLAGS) $(EN_FLAGS) -D __FNAME__=$(@F) layout.html >$@

$(ES_TARGET)/%.html : $(SOURCE)/%.html $(INCLUDE_FILES) | $(ES_TARGET)
	$(M4) $(M4_FLAGS) $(ES_FLAGS) -D __FNAME__=$(@F) layout.html >$@

#comma:= ,
#empty:=
#space:= $(empty) $(empty)
#"$(subst $(comma)$(comma),$(comma),$(subst $(space),$(comma),$(HTML_FILES)))"

$(ROOT_TARGET)/sitemap.xml : $(SOURCE)/sitemap.xml Makefile
	$(M4) $(M4_FLAGS) -D __FNAME__=$(@F) \
	-D __LIST__="$(filter-out 404.html,$(HTML_FILES))" $(SOURCE)/sitemap.xml >$@


$(ROOT_TARGET)/favicon.ico : $(SOURCE)/favicon.ico | $(ROOT_TARGET)
	cp $< $@

$(CSS_TARGET)/%.css : $(CSS)/%.css | $(CSS_TARGET)
	cp $< $@

$(IMG_TARGET)/% : $(IMG)/% | $(IMG_TARGET)
	cp $< $@

$(JS_TARGET)/%.js : $(JS)/%.js | $(JS_TARGET)
	cp $< $@

$(FONTS_TARGET)/$(GLYPH).% : $(FONTS)/$(GLYPH).% | $(FONTS_TARGET)
	cp $< $@

PHONY += testm4
testm4:
	$(M4) $(M4_FLAGS) -D __FNAME__="test_tpy.m4" test_tpy.m4	

PHONY += tekii
tekii: $(ALL_TARGETS) $(SOURCE)/Makefile
tekii: __DOMAIN__:=http://www.tekii.com.ar

PHONY += all
all: $(ALL_TARGETS) $(SOURCE)/Makefile



PHONY += clean
clean:
	rm -f $(ALL_TARGETS)
	rmdir $(EN_TARGET) $(ES_TARGET) $(CSS_TARGET) $(JS_TARGET) $(IMG_TARGET) $(FONTS_TARGET)
	rmdir $(ROOT_TARGET)

#gsutil -m rsync -ndr ../bucket/ gs://www.teky.io 
#gsutil web set -m en/index.html -e en/404.html gs://www.teky.io
#gsutil acl ch -r -u AllUsers:R gs://www.teky.io/

.PHONY: $(PHONY)
.DEFAULT_GOAL := tekii
