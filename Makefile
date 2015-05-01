##
## NICE HEADER
##
__EN__ 	:=en
__ES__ 	:=es

__ROOT__:=/tmp/bucket
__GZIP__:=/tmp/bucketgz
__SRC__	:=.
__CSS__	:=css
__IMG__	:=img
__JS__ 	:=js
__FON__	:=fonts

EN_TGT :=$(__ROOT__)/$(__EN__)
ES_TGT :=$(__ROOT__)/$(__ES__)
CSS_TGT:=$(__ROOT__)/$(__CSS__)
IMG_TGT:=$(__ROOT__)/$(__IMG__)
JS_TGT :=$(__ROOT__)/$(__JS__)
FON_TGT:=$(__ROOT__)/$(__FON__)


BOOTSTRAP_FILE:=bootstrap.min.css
GLYPH:=glyphicons-halflings-regular

PAGES := about.html contact.html
HTML_FILES:= 404.html index.html
HTML_FILES+= $(addprefix $(__EN__)/,$(PAGES)) 
HTML_FILES+= $(addprefix $(__ES__)/,$(PAGES))

FON_FILES:= $(GLYPH).eot $(GLYPH).svg $(GLYPH).ttf $(GLYPH).woff $(GLYPH).woff2
CSS_FILES:= $(BOOTSTRAP_FILE)
IMG_FILES+= us.png es.png logo.png

COPY_FILES:= favicon.ico 
COPY_FILES+= $(addprefix $(__CSS__)/, $(CSS_FILES))
COPY_FILES+= $(addprefix $(__IMG__)/, $(IMG_FILES))
COPY_FILES+= $(addprefix $(__FON__)/, $(FON_FILES))

ALL_FILES:= $(HTML_FILES)  
ALL_FILES+= $(COPY_FILES)
ALL_FILES+= sitemap.xml

ALL_ROOT:= $(addprefix $(__ROOT__)/, $(ALL_FILES))
ALL_GZIP:= $(addprefix $(__GZIP__)/, $(ALL_FILES))

##
## VPATH
##
#vpath %.html ./src
vpath %.css $(__CSS__)
vpath %.png $(__IMG__)
vpath %.js  $(__JS__)

##
## M4
##
M4= $(shell which m4)
M4_FLAGS= -P -D __IMAGES__=\/img -D __BOOTSTRAP_FILE__=$(BOOTSTRAP_FILE) \
 -D __EN__=$(__EN__) -D __ES__=$(__ES__) \
 -D __LANG__=$(__LANG__) -D __DOMAIN__="$(__DOMAIN__)" -I $(__SRC__) 

##
## TREE
##
$(__ROOT__) $(EN_TGT) $(ES_TGT) $(CSS_TGT) $(IMG_TGT) $(JS_TGT) $(FON_TGT): 
	mkdir -p $@

##
## HTML PAGES
##
$(__ROOT__)/% 		: __LANG__=$(__EN__) 
# consider using private to define __LANG__ es
$(__ROOT__)/$(__EN__)/% : __LANG__=$(__EN__) -D __ALTERNATE__=1
$(__ROOT__)/$(__ES__)/% : __LANG__=$(__ES__) -D __ALTERNATE__=1

$(addprefix $(__ROOT__)/, $(HTML_FILES)): $(__SRC__)/layout.html $(__SRC__)/tpy.m4 $(__SRC__)/meta.json $(__SRC__)/$(__CSS__)/custom.css

.SECONDEXPANSION:
%.html : %.html  | $$(@D)
	@echo needs === $|
	mkdir -p $(@D)
	$(M4) $(M4_FLAGS) -D __FNAME__=$(@F) -D __BASE__=$(@D) -D __ROOT__=$(__ROOT__) layout.html >$@

##
## SITEMAP.XML
##
# contemplar el uso de $^
$(__ROOT__)/sitemap.xml : $(__SRC__)/sitemap.xml 
	$(M4) $(M4_FLAGS) -D __FNAME__=$(@F) \
	-D __LIST__="$(filter-out 404.html,$(HTML_FILES))" $(__SRC__)/sitemap.xml >$@

#
# COPY TARGETS
#
.SECONDEXPANSION:
$(addprefix $(__ROOT__)/, $(COPY_FILES)): $$(patsubst $$(__ROOT__)%,$$(__SRC__)%,$$@) | $$(@D)
	@echo needs === $|
	cp $< $@
		
#
# GZIPED TARGETS
#	
$(__GZIP__)/%: $(__ROOT__)/% 
	mkdir -p $(dir $@)
	gzip -c --no-name --rsyncable $< >$@
	@echo "###gsutil --mime  $(shell mimetype --brief $< | tr -d '\n') cp $@ gs://www.tekii.com.ar$(subst $(__GZIP__),,$(dir $@))"

#
# COMMANDS
#
PHONY += testm4
testm4:
	$(M4) $(M4_FLAGS) --debug=aeqt -D __FNAME__="test_tpy.m4" -D __BASE__=$(@D) -D __ROOT__=$(__ROOT__) test_tpy.m4	

PHONY += tekii
tekii: $(ALL_ROOT) 
tekii: __DOMAIN__:=http://www.tekii.com.ar

PHONY += publish
publish: $(ALL_GZIP) 
publish: __DOMAIN__:=http://www.tekii.com.ar

PHONY += all
all: tekii 

PHONY += clean
clean:
	rm -f $(ALL_ROOT)

PHONY += cleangz
cleangzip:
	rm -f $(ALL_GZIP)

PHONY += realclean
realclean: clean cleangzip
	rmdir $(EN_TGT) $(ES_TGT) $(CSS_TGT) $(IMG_TGT) $(FON_TGT)
	rmdir $(__ROOT__)
	rmdir $(__GZIP__)
	
#gsutil -m rsync -ndr ../bucket/ gs://www.teky.io 
#gsutil web set -m en/index.html -e en/404.html gs://www.teky.io
#gsutil acl ch -r -u AllUsers:R gs://www.teky.io/
# mimetype --brief /tmp/bucketgz/favicon.ico | tr -d '\n'

.IGNORE: clean cleangzip realclean
.PHONY: $(PHONY)
.DEFAULT_GOAL := tekii
