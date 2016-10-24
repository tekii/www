m4_include([tpy.m4])dnl

#m4_changequote(`«', `»')#m4_fatal(«bye»)
dnlm4_translit(«a.html b.html   c/d.html»,« »,«,»)
dnlm4_patsubst(«a.html b.html   c/d.html»,«\ +»,«,»)
dnlm4_syscmd(«date --reference=index.html +%Y-%m-%d»)

#m4_esyscmd(relpath  __ROOT__ __BASE__)


m4_bregexp([index.html],       [\([^/]+\..+\)$], [\1])
m4_bregexp([en/about.html],    [\([^/]+\..+\)$], [\1])
m4_bregexp([en/en/about.html], [\([^/]+\..+\)$], [\1])

|__HREF([/tmp/bucket/es/about.html],[/tmp/bucket/en])|
|__HREF([./img/logo.png])|


m4_foreach_w([__X__], m4_unquote([__LIST__]), [==__X__==])



m4_define([m4_foreach_lang],
[m4_if([$2], [], [],
       [m4_pushdef([$1])_m4_foreach([m4_define([$1],], [)$3], [],
  $2)m4_popdef([$1])])])

m4_define([TEST],[------$1---$2---])

m4_define([m4_foreach_xxx],
        [m4_foreach(
                [Iter],
                [[__EN__,[Enghish]],[__ES__,[Español]]],
                [m4_pushdef([$1])m4_pushdef([$2])m4_define([$1],m4_car(Iter))m4_define([$2],m4_cdr(Iter))$3[]m4_popdef([$2])m4_popdef([$1])])])




---------------------------------------------------
#m4_traceon([_m4_foreach_xxx])
#m4_foreach_xxx(
#        [__L__],[__N__],
#        [
#     -__L__=__N__-])
#m4_traceoff([m4_foreach_xxx])


m4_divert([DEFAULT])dnl


m4_define([__L],
[m4_if([$#], 0, [m4_fatal([$0: cannot be called without arguments]],
       [$#], 1, [m4_fatal([$0: cannot be called with 1 arguments])],
       [$#], 2, [UNDEFINED LANG],
       [m4_if($1,$2,$3,[__L($1,m4_shift(m4_shift(m4_shift($@))))])])])


m4_traceon([__LANG_NAME3])
---------------------------------------
>>>>>__LOOKUP_LANG_NAME(en,m4_unquote(__LANGS__))<<<<<
>>>>>__LOOKUP_LANG_NAME(es,m4_unquote(__LANGS__))<<<<<
>>>>>__LOOKUP_LANG_NAME(pt,m4_unquote(__LANGS__))<<<<<
>>>>>__LOOKUP_LANG_NAME(nn,m4_unquote(__LANGS__))<<<<<
>>>>>__LANG_NAME(en)<<<<<
>>>>>__LOOKUP_LANG_NAME(nn)<<<<<
---------------------------------------
m4_traceoff([__LANG_NAME3])
