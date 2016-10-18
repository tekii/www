#
# diverts
# 1 sitemap
# 2 header
# 3 body
# 5 amp custom styles
# 6 amp custom elements
#
m4_define([_m4_divert(DEFAULT)], 0)
m4_define([_m4_divert(SITEMAP)], 1)
m4_define([_m4_divert(HEADER)], 2)
m4_define([_m4_divert(BODY)], 3)
m4_define([_m4_divert(AMP_CUSTOM_STYLES)], 5)
m4_define([_m4_divert(AMP_CUSTOM_ELEMENTS)], 6)

# foreach(x, (item_1, item_2, ..., item_n), stmt)
#   parenthesized list, simple version
#m4_define(«tpy_foreach», «m4_pushdef(«$1»)_foreach($@)m4_popdef(«$1»)»)
#m4_define(«_arg1», «$1»)
#m4_define(«_foreach», «m4_ifelse(«$2», «()», «»,
# «m4_define(«$1», _arg1$2)$3«»$0(«$1», (m4_shift$2), «$3»)»)»)

#
# constants
#
m4_define([__TEKII__],[<strong>TEKii$1</strong>])
m4_define([__TEKII_SRL_]_,__TEKII__([ SRL]))
m4_define([__AMP_BOILERPLATE__],[<style amp-boilerplate>body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}</style><noscript><style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}</style></noscript>])

#
# LANG conditionals
#
m4_define([__LANGS__],[[en,[English]], [es,[Español]], [pt,[Portuguese]]])

m4_define([__FOREACH_LANG],
[m4_foreach([Iter], [__LANGS__],
            [m4_pushdef([$1])m4_pushdef([$2])m4_define([$1],m4_car(Iter))m4_define([$2],m4_cdr(Iter))$3[]m4_popdef([$2])m4_popdef([$1])])])

m4_define([__FOREACH_LANG_EXCEPT],
[m4_foreach([Iter], [__LANGS__],
            [m4_pushdef([$2])m4_pushdef([$3])m4_define([$2],m4_car(Iter))m4_define([$3],m4_cdr(Iter))m4_if(__L__,$1,[],[$4])m4_popdef([$3])m4_popdef([$2])])])

m4_define([__LOOKUP_LANG_NAME],
[m4_if([$#], 0, [m4_fatal([$0: cannot be called without arguments]],
       [$#], 1, [m4_fatal([$0: cannot be called with 1 arguments])],
       [$#], 2, [UNDEFINED LANG],
       [m4_if($1,$2,$3,[__LOOKUP_LANG_NAME($1,m4_shift3($@))])])])

m4_define([__LANG_NAME], [__LOOKUP_LANG_NAME($1,m4_unquote(__LANGS__))])
m4_define([__LANG_NAME__], __LANG_NAME(__LANG__))

m4_define([TPY_LANG],
[m4_if(__LANG__,[$1],[$2],__LANG__,[$3],[$4])])

#m4_define(«TPY_LAN4»,«m4_ifelse(«$#»,«0»,,«$#»,«1»,,__LANG__,«$1»,«$2»,«$0(m4_shift(m4_shift($@)))»)»)

m4_define([TPY_ESEN],
m4_case(__LANG__,__ES__,$1,__EN__,$2))

m4_define([TPY_ENES],
m4_case(__LANG__,__EN__,$1,__ES__,$2))

#m4_define(«TPY_DEPS»,«$1»)

#
# calculate path jump relative to __BASE__ or $2
#
m4_define([__HREF],
[m4_esyscmd_s(relpath $1 m4_default([$2],[__BASE__]))])

m4_define([__FNAME],
[m4_bregexp($1,[\([^/]+\..+\)$], [\1])])

m4_define([__RDATE],
[m4_chomp_all(m4_esyscmd(date --reference=$1 +%Y-%m-%d))])
