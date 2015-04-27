m4_include(`tpy.m4')m4_dnl


m4_translit(«a.html b.html   c/d.html»,« »,«,»)
m4_patsubst(«a.html b.html   c/d.html»,«\ +»,«,»)
m4_syscmd(«date --reference=index.html +%Y-%m-%d»)

m4_regexp(«index.html»,      «\([^/]+\..+\)$», «\1»)
m4_regexp(«en/about.html»,   «\([^/]+\..+\)$», «\1»)
m4_regexp(«en/en/about.html»,«\([^/]+\..+\)$», «\1»)
