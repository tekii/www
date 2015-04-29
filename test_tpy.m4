m4_include(`tpy.m4')m4_dnl


m4_dnlm4_translit(«a.html b.html   c/d.html»,« »,«,»)
m4_dnlm4_patsubst(«a.html b.html   c/d.html»,«\ +»,«,»)
m4_dnlm4_syscmd(«date --reference=index.html +%Y-%m-%d»)

m4_dnlm4_regexp(«index.html»,      «\([^/]+\..+\)$», «\1»)
m4_dnlm4_regexp(«en/about.html»,   «\([^/]+\..+\)$», «\1»)
m4_dnlm4_regexp(«en/en/about.html»,«\([^/]+\..+\)$», «\1»)

-
TPY_RLNK2(«/tmp/bucket/es/about.html»,«/tmp/bucket/en»)
TPY_RLNK1(«./img/logo.png»)
-
m4_esyscmd(relpath  __ROOT__ __BASE__)
m4_esyscmd(relpath  __ROOT__ __BASE__)
