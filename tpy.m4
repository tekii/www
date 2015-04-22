m4_divert(`-1')m4_dnl
m4_changequote(`«', `»')
m4_define(TPY_TEKY,«<span style="color:black;">TEK</span><span style="color:red;">Y</span><span style="color:black;">$1</span>»)
m4_define(TPY_TEKY_SRL,TPY_TEKY(« SRL»))
m4_define(«TPY_LAN»,«m4_ifelse(__LANG__,$1,«$2»,m4_ifelse(__LANG__,$3,«$4»,ERROR))»)
m4_define(«TPY_LANG»,«m4_ifelse(__LANG__,«$1»,«$2»,__LANG__,«$3»,«$4»)»)

m4_define(«TPY_LAN4»,«m4_ifelse(«$#»,«0»,,«$#»,«1»,,__LANG__,«$1»,«$2»,«$0(m4_shift(m4_shift($@)))»)»)

m4_define(«TPY_LAN2»,«m4_ifelse(__LANG__,«$1»,«$2»,«m4_ifelse(«$3»,«»,«»,«$0(shift(shift($@)))»)»)»)
m4_define(«TPY_LAN3»,«m4_ifelse(«$#»,«0»,,«m4_ifelse(«__LANG__»,«$1»,«$2»,«$0(shift(shift($@)))»)»)»)

m4_define(«TPY_DEPS»,«$1»)
m4_divert(«0»)m4_dnl
