#!/usr/bin/env bash
# Gera o slideshow do GNOME com as imagens desta pasta e ativa como wallpaper.
# Uso: ./gerar-slideshow.sh
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$DIR/slideshow.xml"
STATIC=57   # segundos com a imagem parada
FADE=3      # segundos de transição (total = 60s por imagem)

python3 - "$DIR" "$OUT" "$STATIC" "$FADE" <<'PY'
import os, sys, datetime
import xml.etree.ElementTree as ET

folder, out, static, fade = sys.argv[1], sys.argv[2], float(sys.argv[3]), float(sys.argv[4])
exts = ('.jpg', '.jpeg', '.png', '.webp', '.jxl')
files = sorted(
    os.path.join(folder, f) for f in os.listdir(folder)
    if f.lower().endswith(exts) and os.path.isfile(os.path.join(folder, f))
)
if len(files) < 2:
    sys.exit('Precisa de pelo menos 2 imagens na pasta.')

now = datetime.datetime.now().replace(microsecond=0)
root = ET.Element('background')
st = ET.SubElement(root, 'starttime')
for tag, val in (('year', now.year), ('month', now.month), ('day', now.day),
                 ('hour', now.hour), ('minute', now.minute), ('second', now.second)):
    ET.SubElement(st, tag).text = str(val)

n = len(files)
for i, path in enumerate(files):
    s = ET.SubElement(root, 'static')
    ET.SubElement(s, 'duration').text = f'{static:.1f}'
    ET.SubElement(s, 'file').text = path
    t = ET.SubElement(root, 'transition', {'type': 'fade'})
    ET.SubElement(t, 'duration').text = f'{fade:.1f}'
    ET.SubElement(t, 'from').text = path
    ET.SubElement(t, 'to').text = files[(i + 1) % n]

ET.indent(root, space='  ')
ET.ElementTree(root).write(out, encoding='utf-8', xml_declaration=True)
print(f'{n} imagens -> {out} ({n * (static + fade):.0f}s por ciclo)')
PY

URI="file://$OUT"
CURRENT="$(gsettings get org.gnome.desktop.background picture-uri | tr -d "'")"
if [ "$CURRENT" = "$URI" ]; then
    # força o GNOME a recarregar o XML
    gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
fi
gsettings set org.gnome.desktop.background picture-uri "$URI"
gsettings set org.gnome.desktop.background picture-uri-dark "$URI"
gsettings set org.gnome.desktop.background picture-options 'zoom'
echo "Wallpaper ativado: $URI"
