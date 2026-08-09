# SMPlayer + mpv (Arch Linux)

Configurația este păstrată în fișiere, dar SMPlayer pornește mpv cu
`--no-config`. De aceea, `mpv.conf` și `input.conf` sunt incluse explicit prin
opțiunea SMPlayer `mplayer_additional_options`.

## Instalare fresh pe Arch Linux

Instalează pachetele de bază:

```bash
sudo pacman -Syu
sudo pacman -S mpv smplayer
```

Pentru AMD + Vulkan/VA-API (opțional, dar recomandat pentru această configurație):

```bash
sudo pacman -S vulkan-radeon libva-mesa-driver libva-utils
```

Copiază configurația mpv:

```bash
mkdir -p "$HOME/.config/mpv/watch_later"
install -m 644 ./mpv/mpv.conf "$HOME/.config/mpv/mpv.conf"
install -m 644 ./mpv/input.conf "$HOME/.config/mpv/input.conf"
```

Pornește SMPlayer o dată, selectează **mpv** ca motor multimedia, apoi
închide-l complet. În `~/.config/smplayer/smplayer.ini`, în secțiunea
`[advanced]`, setează:

```ini
[advanced]
disable_player_config=true
mplayer_additional_options="--include=/home/UTILIZATOR/.config/mpv/mpv.conf --input-conf=/home/UTILIZATOR/.config/mpv/input.conf"
```

Înlocuiește `UTILIZATOR` cu numele utilizatorului Linux. Îl poți afla cu:

```bash
printf '%s\n' "$USER"
```

Dacă secțiunea `[advanced]` există deja, modifică doar cheile; nu crea o a
 doua secțiune cu același nume. Poți automatiza setarea (face backup înainte):

```bash
cp "$HOME/.config/smplayer/smplayer.ini" "$HOME/.config/smplayer/smplayer.ini.bak"
sed -i 's/^disable_player_config=.*/disable_player_config=true/' "$HOME/.config/smplayer/smplayer.ini"
sed -i 's#^mplayer_additional_options=.*#mplayer_additional_options="--include=/home/'"$USER"'/.config/mpv/mpv.conf --input-conf=/home/'"$USER"'/.config/mpv/input.conf"#' "$HOME/.config/smplayer/smplayer.ini"
```

Poți edita manual fișierul cu:

```bash
nano "$HOME/.config/smplayer/smplayer.ini"
```

`./mpv/smplayer.ini` este doar un fragment documentativ; nu îl copia peste
fișierul complet al SMPlayer.

## Verificare

Închide și repornește SMPlayer, redă un fișier video, apoi verifică procesul:

```bash
pgrep -af '/usr/bin/mpv'
```

Comanda trebuie să conțină:

```text
--no-config
--include=/home/UTILIZATOR/.config/mpv/mpv.conf
--input-conf=/home/UTILIZATOR/.config/mpv/input.conf
```

Pentru verificarea valorilor efective prin IPC, instalează `socat`:

```bash
sudo pacman -S socat
socket=$(find /tmp -maxdepth 1 -type s -name 'smplayer-mpv-*' | head -1)
printf '%s\n' '{"command":["get_property","gpu-api"]}' | socat - UNIX-CONNECT:"$socket"
printf '%s\n' '{"command":["get_property","video-sync"]}' | socat - UNIX-CONNECT:"$socket"
printf '%s\n' '{"command":["get_property","interpolation"]}' | socat - UNIX-CONNECT:"$socket"
printf '%s\n' '{"command":["get_property","deband"]}' | socat - UNIX-CONNECT:"$socket"
```

Rezultatele așteptate sunt `audio`, `false`, `true`. Nu activa `video-sync=display-resample` / `interpolation`: în SMPlayer (XWayland) randarea la 144 Hz nu ține pasul și cadrele sunt aruncate sau afișate decalat (pare că merge cu încetinitorul în full screen). API-ul GPU va fi ales de mpv/SMPlayer (în configurația actuală SMPlayer folosește X11 EGL). Nu forța `gpu-api=vulkan` împreună cu `--gpu-context=x11egl`: această combinație poate produce o fereastră neagră sau lipsa imaginii.

## Notă despre opțiunile SMPlayer

SMPlayer poate adăuga propriile opțiuni după includerea configurației. Dacă
vrei ca valorile din `mpv.conf` să fie cele finale, dezactivează în SMPlayer
opțiunile care le suprascriu, de exemplu `--no-keepaspect`, `--sub-font=Arial`
sau `--sub-font-size=50`. Verificarea prin IPC arată valoarea finală.

Nu folosi `user_args` pentru această integrare; cheia relevantă este
`mplayer_additional_options` din secțiunea `[advanced]`.
