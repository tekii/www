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
m4_define(TPY_TEKII,«<span style="color:black;">TEK</span><span style="color:red;">ii</span><span style="color:black;">$1</span>»)
m4_define(TPY_TEKII_SRL,TPY_TEKII(« SRL»))


m4_define(«TPY_LANG»,«m4_ifelse(__LANG__,«$1»,«$2»,__LANG__,«$3»,«$4»)»)
m4_define(«TPY_LAN4»,«m4_ifelse(«$#»,«0»,,«$#»,«1»,,__LANG__,«$1»,«$2»,«$0(m4_shift(m4_shift($@)))»)»)

m4_define(«TPY_DEPS»,«$1»)

m4_divert(«0»)m4_dnl
