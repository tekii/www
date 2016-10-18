##
## NICE HEADER
##
# SRC/index
# SRC/XX/about
# SRC/EN/twu
# SRC/ES/some es page
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

HTML_EXT:=.html
AMP__EXT:=.amp.html

BOOTSTRAP_FILE:=bootstrap.css
GLYPH:=glyphicons-halflings-regular

PAGES := about.html contact.html
HTML_FILES:= 404.html index.html
HTML_FILES+= $(addprefix $(__EN__)/,$(PAGES))
HTML_FILES+= $(addprefix $(__ES__)/,$(PAGES))

FON_FILES:= $(GLYPH).eot $(GLYPH).svg $(GLYPH).ttf $(GLYPH).woff $(GLYPH).woff2
CSS_FILES:= $(BOOTSTRAP_FILE)
IMG_FILES+= us.png es.png logo.png close.svg hamburger.svg hamburger_white.svg \
	logo-blue.svg lang-icon.svg lang-icon-inverted.svg

COPY_FILES:= favicon.ico
COPY_FILES+= $(addprefix $(__CSS__)/, $(CSS_FILES))
COPY_FILES+= $(addprefix $(__IMG__)/, $(IMG_FILES))
COPY_FILES+= $(addprefix $(__FON__)/, $(FON_FILES))

ALL_FILES:= $(HTML_FILES)
ALL_FILES+= $(COPY_FILES)
ALL_FILES+= sitemap.xml

ALL_ROOT:= $(addprefix $(__ROOT__)/, $(ALL_FILES))
ALL_GZIP:= $(addprefix $(__GZIP__)/, $(ALL_FILES))

TREE:= $(__EN__)/ $(__ES__)/ $(__CSS__)/ $(__IMG__)/ $(__FON__)/
##
## VPATH
##
#vpath %.html ./src
#vpath  %.html.in .
#vpath %.css $(__CSS__)
#vpath %.png $(__IMG__)
#vpath %.js  $(__JS__)
##
## TREE
##
$(__ROOT__)/ $(__GZIP__)/:
	mkdir -p $@
$(__ROOT__)/%/:
	mkdir -p $@
$(__GZIP__)/%/:
	mkdir -p $@
##
## M4
##
M4= $(shell which m4)
M4_FLAGS= \
	-I /usr/share/autoconf \
	-R /usr/share/autoconf/m4sugar/m4sugar.m4f \
	-D __IMAGES__=$(__IMG__) \
	-D __BOOTSTRAP_FILE__=$(BOOTSTRAP_FILE) \
	-D __EN__=$(__EN__) -D __ES__=$(__ES__) \
	-I $(__SRC__)
##
## HTML PAGES
##
#$(__ROOT__)/%.html	: $(__SRC__)/%.htm4
# consider using private to define __LANG__ es
$(__ROOT__)/% 		: EXTRA_FLAGS+= -D __LANG__=$(__EN__)
$(__ROOT__)/$(__EN__)/% : EXTRA_FLAGS+= -D __LANG__=$(__EN__) -D __ALTERNATE__=1
$(__ROOT__)/$(__ES__)/% : EXTRA_FLAGS+= -D __LANG__=$(__ES__) -D __ALTERNATE__=1

$(addprefix $(__ROOT__)/, $(HTML_FILES)): $(__SRC__)/layout.html $(__SRC__)/tpy.m4 $(__SRC__)/meta.json $(__SRC__)/$(__CSS__)/custom.css

.SECONDEXPANSION:
#%.html : %.html  | $$(@D)/
$(addprefix $(__ROOT__)/, $(HTML_FILES)): $$(__SRC__)/$$(@F) | $$(@D)/
	$(M4) $(M4_FLAGS) $(EXTRA_FLAGS) -D __FNAME__=$(@F) \
		-D __BASE__=$(@D) -D __ROOT__=$(__ROOT__) layout.html >$@
##
## SITEMAP.XML
##
# contemplar el uso de $^, falta la dependencia con los
# sources de los htmls (puede que esto no sea necesario y no haya problema
# en regenerarlo siempre que tomemos la fecha del source
$(__ROOT__)/sitemap.xml : $(__SRC__)/sitemap.xml | $(__ROOT__)/
	$(M4) $(M4_FLAGS) $(EXTRA_FLAGS) -D __FNAME__=$(@F) \
	-D __LIST__="$(filter-out 404.html,$(HTML_FILES))" $(__SRC__)/sitemap.xml >$@
##
## COPY TARGETS
##
.SECONDEXPANSION:
$(addprefix $(__ROOT__)/,$(COPY_FILES)): $$(patsubst $$(__ROOT__)%,$$(__SRC__)%,$$@) | $$(@D)/
	cp $< $@
##
## GZIPED TARGETS
##
GSUTIL_EXTRA_FLAGS=
$(__GZIP__)/$(__CSS__)/$(BOOTSTRAP_FILE): GSUTIL_EXTRA_FLAGS=-h "Cache-Control:public,max-age=86400"
$(__GZIP__)/$(__IMG__)/logo.png: GSUTIL_EXTRA_FLAGS=-h "Cache-Control:public,max-age=3600"
$(__GZIP__)/$(__IMG__)/es.png: GSUTIL_EXTRA_FLAGS=-h "Cache-Control:public,max-age=86400"
$(__GZIP__)/$(__IMG__)/us.png: GSUTIL_EXTRA_FLAGS=-h "Cache-Control:public,max-age=86400"
.SECONDEXPANSION:
$(__GZIP__)/%: $(__ROOT__)/% | $$(@D)/
	gzip -c --no-name --rsyncable $< >$@
	gsutil $(GSUTIL_EXTRA_FLAGS) -h "Content-Encoding:gzip" -h "Content-Type:$(shell mimetype --brief $< | tr -d '\n')" cp -a public-read -r $@  gs://www.tekii.com.ar$(subst $(__GZIP__),,$(dir $@))

##
## COMMANDS --debug=aeqt
##
PHONY += testm4
testm4:
	$(M4) $(M4_FLAGS) --debug= -D __FNAME__="test_tpy.m4" -D __BASE__=$(@D) -D __ROOT__=$(__ROOT__) -D __LIST__="$(filter-out 404.html,$(HTML_FILES))" test_tpy.m4

PHONY += tekii
tekii: EXTRA_FLAGS= -D __DOMAIN__=http://www.tekii.com.ar
tekii: $(ALL_ROOT)
	@echo [[[ DONE $@ ]]]

PHONY += publish
publish: EXTRA_FLAGS= -D __DOMAIN__=http://www.tekii.com.ar
publish: $(ALL_GZIP)
#	gsutil web set -m en/index.html -e en/404.html gs://www.teky.io
	@echo [[[ DONE $@ ]]]


PHONY += all
all: tekii

PHONY += clean
clean:
	rm -f $(ALL_ROOT)

PHONY += cleangzip
cleangzip:
	rm -f $(ALL_GZIP)

PHONY += realclean
realclean: clean cleangzip
	rmdir $(addprefix $(__ROOT__)/, $(TREE))
	rmdir $(addprefix $(__GZIP__)/, $(TREE))
	rmdir $(__ROOT__)
	rmdir $(__GZIP__)

#gsutil -m rsync -ndr ../bucket/ gs://www.teky.io
#gsutil web set -m en/index.html -e en/404.html gs://www.teky.io
#gsutil acl ch -r -u AllUsers:R gs://www.teky.io/
# mimetype --brief /tmp/bucketgz/favicon.ico | tr -d '\n'

.IGNORE: clean cleangzip realclean
.PHONY: $(PHONY)
.DEFAULT_GOAL := tekii
