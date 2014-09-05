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

PATH="$TBIN:$WD/bin:$PATH"
export GOROOT="$TOOLCHAIN/go"
export GOPATH="$WD"

function do_clean {
  rm -rf "$GOPATH/pkg"
  rm -rf "$GOPATH/bin"
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

    ensure_dir "$WD/src"
    ensure_dir "$WD/src/teky"

    go get -v github.com/spf13/hugo
    abort_on_error "$?" "no se puede instalar github.com/spf13/hugo"

    #cd "$WD/src"
    #go install ./...
    #abort_on_error "$?" "no se pueden compilar los paquetes"
    cd "$WD"
    ;;
test)
    $ECHO
    ensure_dir "$TMP"
    $ECHO "no implementado"
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
    $ECHO "./hugo.sh [clean|realclean|build|test|package|env] flags"
    $ECHO "flags: --ignore-tati-toolchain solo da warning si falla el wget"
    exit 2
esac
