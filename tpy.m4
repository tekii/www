m4_divert(`-1')m4_dnl
#
# diverts
# 1 sitemap
# 2 header
# 3 body
#


m4_changequote(`«', `»')

# foreach(x, (item_1, item_2, ..., item_n), stmt)
#   parenthesized list, simple version

m4_define(«tpy_foreach», «m4_pushdef(«$1»)_foreach($@)m4_popdef(«$1»)»)
m4_define(«_arg1», «$1»)
m4_define(«_foreach», «m4_ifelse(«$2», «()», «»,
 «m4_define(«$1», _arg1$2)$3«»$0(«$1», (m4_shift$2), «$3»)»)»)

m4_define(«tpy_cleardivert»,
  «m4_pushdef(«_num», m4_divnum)m4_divert(«-1»)m4_ifelse(«$#», «0», «m4_undivert«»»,
  «m4_undivert($@)»)m4_divert(_num)m4_popdef(«_num»)»)

m4_define(TPY_TEKY,«<span style="color:black;">TEK</span><span style="color:red;">ii</span><span style="color:black;">$1</span>»)
m4_define(TPY_TEKY_SRL,TPY_TEKY(« SRL»))

m4_define(TPY_TEKII,«<strong><span style="color:black;">TEK</span><span style="color:black;">ii</span><span style="color:black;">$1</span></strong>»)
m4_define(TPY_TEKII_SRL,TPY_TEKII(« SRL»))


m4_define(«TPY_LANG»,«m4_ifelse(__LANG__,«$1»,«$2»,__LANG__,«$3»,«$4»)»)
m4_define(«TPY_LAN4»,«m4_ifelse(«$#»,«0»,,«$#»,«1»,,__LANG__,«$1»,«$2»,«$0(m4_shift(m4_shift($@)))»)»)

m4_define(«TPY_ESEN»,TPY_LANG(__ES__,$1,__EN__,$2))
m4_define(«TPY_ENES»,TPY_LANG(__EN__,$1,__ES__,$2))

m4_define(«TPY_DEPS»,«$1»)

# calculate relative jump e
# $1 base $2 target
define(__NL__,«
»)

m4_define(«TPY_RLNK2»,«m4_esyscmd(relpath $1 $2)»)
m4_define(«TPY_RLNK3»,«TPY_RLNK2($1,__BASE__)»)
m4_define(«TPY_LNK1»,«m4_syscmd(relpath $1 __BASE__ | tr -d '\n')»)

m4_divert(«0»)m4_dnl
