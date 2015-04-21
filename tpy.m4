m4_divert(`-1')m4_dnl
m4_changequote(`«', `»')
m4_define(TPY_TEKY,«<span style="color:black;">TEK</span><span style="color:red;">Y</span><span style="color:black;">$1</span>»)
m4_define(TPY_TEKY_SRL,TPY_TEKY(« SRL»))
m4_define(«TPY_LANG»,«m4_ifelse(__LANG__,$1,«$2»,«m4_ifelse(__LANG__,$3,«$4»,ERROR)»)»)
m4_define(«TPY_DEPS»,«$1»)
m4_divert(«0»)m4_dnl
