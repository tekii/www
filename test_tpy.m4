m4_include(`tpy.m4')m4_dnl


m4_translit(«a.html b.html   c/d.html»,« »,«,»)
m4_patsubst(«a.html b.html   c/d.html»,«\ +»,«,»)
