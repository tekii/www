#!/bin/bash
if [ ! -e "./bootstrap.sh" ]; then
  # el huevo y la gallina
  echo "ejecutando bootstrap base"
  wget $WGETOPTIONS "http://10.160.229.142/~bamboo-agent/bootstrap.tgz"
  tar xvzf bootstrap.tgz
fi

#para que el bootstrap no genere ruido por consola
PREVOPS=$WGETOPTIONS
WGETOPTIONS="-q"
. ./bootstrap.sh $2
WGETOPTIONS=$PREVOPS

PATH="$TBIN:$PATH"

export GOROOT="$TOOLCHAIN/go"
export GOPATH="$TOOLCHAIN/hugo"

function do_clean {
  rm -rf "$GOPATH/pkg"
  rm -rf "$GOPATH/bin"
  rm -rf "$WD/www/public"
}

# leer parametros y ejecutar
case $1 in
realclean)
    $ECHO
    $ECHO "haciendo realclean"
    do_clean
    rm -rf $TOOLCHAIN
    rm -rf $TMP/
    ;;
clean)
    $ECHO
    $ECHO "haciendo clean"
    do_clean
    ;;
build)
    $ECHO
    $ECHO "haciendo build"

    toolchain_get "go" $2
    abort_on_error "$?" "no se puede descargar go"

    ensure_dir "$GOPATH"
    cd "$GOPATH"

    go get -v github.com/spf13/hugo
    abort_on_error "$?" "no se puede instalar github.com/spf13/hugo"

    ensure_link "$GOPATH/bin/hugo" "$TBIN/hugo"

    cd "$WD"
    ;;
server)
    $ECHO
    $ECHO "serving"

    cd "$WD/www"
    ensure_dir "$WD/www/archetypes"
    ensure_dir "$WD/www/content"
    ensure_dir "$WD/www/layouts"

    hugo --theme=teppanyaki -w server

    cd "$WD"
    ;;

compile)
    $ECHO
    $ECHO "compiling"

    cd "$WD/www"
    ensure_dir "$WD/www/archetypes"
    ensure_dir "$WD/www/content"
    ensure_dir "$WD/www/layout"

    hugo --theme=teppanyaki 

    cd "$WD"
    ;;

test)
    $ECHO
    ensure_dir "$TMP"
    $ECHO "no implementado"
    exit 1
    ;;

dry-run)
    rsync --dry-run -az --force --delete --progress --exclude-from=publish_exclude.txt -e "ssh -o UserKnownHostsFile=/dev/null -o CheckHostIP=no -o StrictHostKeyChecking=no" www/public/ gummo.teky.io:/var/www/default
    exit 1
    ;;    
publish)
    rsync           -az --force --delete --progress --exclude-from=publish_exclude.txt -e "ssh -o UserKnownHostsFile=/dev/null -o CheckHostIP=no -o StrictHostKeyChecking=no" www/public/ gummo.teky.io:/var/www/default

    curl 'https://www.teky.io/pagespeed_admin/cache?purge=*'
    exit 1
    ;;    
package)
    $ECHO
    $ECHO "no implementado"
    exit 1
    ;;
env)
    $ECHO
    $ECHO "GO environment..."
    $ECHO
    # esto se hace de otra forma pero bueno
    go env
    if [ "$2" != "" ]; then
      PARAMS=( $@ )
      LENP=${#PARAMS[@]}
      CMD=${PARAMS[@]:1:$LENP}
      $ECHO "ejecutando $CMD..."
      $CMD
    fi
    cd "$WD"
    ;;
*)
    $ECHO
    $ECHO "Missing parameter"
    $ECHO
    $ECHO "Modo de uso:"
    $ECHO "./hugo.sh [clean|realclean|build|test|package|env|server] flags"
    $ECHO "flags: --ignore-tati-toolchain solo da warning si falla el wget"
    exit 2
esac
