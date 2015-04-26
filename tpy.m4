m4_divert(`-1')m4_dnl

m4_changequote(`«', `»')

# foreach(x, (item_1, item_2, ..., item_n), stmt)
#   parenthesized list, simple version

m4_define(«tpy_foreach», «m4_pushdef(«$1»)_foreach($@)m4_popdef(«$1»)»)
m4_define(«_arg1», «$1»)
m4_define(«_foreach», «m4_ifelse(«$2», «()», «»,
 «m4_define(«$1», _arg1$2)$3«»$0(«$1», (m4_shift$2), «$3»)»)»)



m4_define(TPY_TEKY,«<span style="color:black;">TEK</span><span style="color:red;">Y</span><span style="color:black;">$1</span>»)
m4_define(TPY_TEKY_SRL,TPY_TEKY(« SRL»))
m4_define(TPY_TEKII,«<span style="color:black;">TEK</span><span style="color:red;">II</span><span style="color:black;">$1</span>»)
m4_define(TPY_TEKII_SRL,TPY_TEKII(« SRL»))


m4_define(«TPY_LANG»,«m4_ifelse(__LANG__,«$1»,«$2»,__LANG__,«$3»,«$4»)»)
m4_define(«TPY_LAN4»,«m4_ifelse(«$#»,«0»,,«$#»,«1»,,__LANG__,«$1»,«$2»,«$0(m4_shift(m4_shift($@)))»)»)

m4_define(«TPY_DEPS»,«$1»)

m4_divert(«0»)m4_dnl
