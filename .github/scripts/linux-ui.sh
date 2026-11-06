#!/bin/bash
# Prueba de interfaz de ReadIt en Linux con Xvfb, xdotool y capturas en shots/.
#   linux-ui.sh               ReadIt base
#   linux-ui.sh Prioridades   ReadIt con la característica Prioridades
set -u
VARIANT=${1:-base}
OUT=shots/$VARIANT
mkdir -p "$OUT"
export DISPLAY=:99 GDK_BACKEND=x11 GSK_RENDERER=cairo LANG=C.UTF-8 LC_ALL=C.UTF-8
pgrep -x Xvfb >/dev/null || { Xvfb :99 -screen 0 1280x800x24 2>/dev/null & sleep 2; }

TRAITS=()
case "$VARIANT" in
    base) ;;
    Prioridades) TRAITS=(--traits Prioridades) ;;
    *) echo "Variante desconocida: $VARIANT" >&2; exit 2 ;;
esac
swift build --product ReadIt "${TRAITS[@]}" || exit 1
BIN="$(swift build --product ReadIt "${TRAITS[@]}" --show-bin-path)/ReadIt"

# Aislar los libros y ajustes de prueba sin tocar los datos del usuario.
TEST_HOME="$(mktemp -d)"
mkdir -p "$TEST_HOME/Documents" "$TEST_HOME/.config"
export HOME="$TEST_HOME" XDG_CONFIG_HOME="$TEST_HOME/.config"
APP=
cleanup() {
    if [ -n "$APP" ]; then kill "$APP" 2>/dev/null || true; fi
    rm -rf "$TEST_HOME"
}
trap cleanup EXIT

start() { "$BIN" > "$OUT/app.log" 2>&1 & APP=$!; sleep 5; }
shot()  { import -window root "$OUT/$1.png"; echo "captura: $OUT/$1.png"; }
click() { xdotool mousemove "$1" "$2" click 1; sleep 1; }
alive() { kill -0 $APP 2>/dev/null || { echo "La app se ha cerrado"; cat "$OUT/app.log"; exit 1; }; }

# Barra lateral (Libros / Ajustes) a la izquierda; la lista, a la derecha.
if [ "$VARIANT" = base ]; then FILA3=173; TITULO2=124; else FILA3=188; TITULO2=131; fi

start; alive; shot 1-inicio
click 285 $FILA3;   shot 2-tercer-libro-marcado
click 360 $TITULO2; shot 3-detalle                      # abre «Dune»
xdotool key End; xdotool type --delay 60 " hoy"; sleep 1
shot 4-detalle-editado
click 42 26;        shot 5-libros-tras-volver           # Volver a la lista
click 77 106;       shot 6-ajustes                      # Ajustes
click 284 100;      shot 7-sin-fechas                   # Mostrar fechas de vencimiento: no
click 77 74;        shot 8-libros-sin-fechas             # Libros
alive
kill $APP; sleep 1
APP=

# Al volver a abrir se conservan los libros y los ajustes.
start; alive; shot 9-tras-reiniciar
kill $APP
APP=
