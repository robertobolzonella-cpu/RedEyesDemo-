<!-- res://README.md -->
# RedEyesDemo

Run & gun 2D stile Metal Slug in Godot 4.x. Protagonista su esoscheletro
SAA. Gli sprite dei personaggi vengono dai concept art del progetto
(PNG in `assets/sprites/**`, ritagliati e scalati alla risoluzione di
gioco); niente altre risorse esterne — effetti (flash di sparo,
traccianti) generati via codice.

- Viewport 640x360, stretch `canvas_items` / `expand`, landscape.
- Renderer **Compatibility** (GL) — gira anche su iPhone/iPad (Xogot).
- Input: `move_left`, `move_right`, `jump`, `fire` (tastiera: A/D o frecce,
  Space/W, X/J) + controlli touch a schermo.
- Layer fisici: `1` mondo, `2` player, `4` nemici (i proiettili sono
  Area2D su layer 0 con mask impostata da chi spara).
- Animazioni procedurali sui sprite: bob di corsa, tilt in salto/caduta,
  rinculo allo sparo; flash al muzzle e proiettili traccianti (gialli il
  player, rossi i nemici).

## Personaggi

| Sprite | Ruolo in gioco |
|---|---|
| `assets/sprites/saa/player_exo.png` | **Player** — esoscheletro SAA crema (hp 100) |
| `assets/sprites/enemies/trooper.png` | **Fante** — corazzato verde, colpo singolo (hp 3) |
| `assets/sprites/saa/swashbuckler/swashbuckler.png` | **SAA "Barume"** — mech samurai, raffica x3 (hp 10) |
| `assets/sprites/saa/mk54/mk54.png` | **MK54** — élite bianco con scudo, raffica x2 (hp 6) |

## Struttura dei file

| Path | Contenuto |
|---|---|
| `project.godot` | Config progetto, input map, layer |
| `scenes/main.tscn` | Livello: Player, Ground 3200x64, 3 nemici, HUD, Touch |
| `scenes/player.tscn` + `scripts/player.gd` | Player (speed 240, jump -560, gravity 1500, cooldown sparo) |
| `scenes/bullet.tscn` + `scripts/bullet.gd` | Proiettile condiviso player/nemici |
| `scenes/enemies/enemy_soldier.tscn` | Fante (burst 1) |
| `scenes/enemies/enemy_saa.tscn` | SAA Barume (burst 3) |
| `scenes/enemies/enemy_mk54.tscn` | MK54 élite (burst 2, `art_faces_left`) |
| `scripts/enemy.gd` | Logica nemici (`@export hp/speed/burst/damage/range`) |
| `scripts/sprite_factory.gd` | Flash di sparo + sprite procedurali di riserva |
| `scenes/ui/hud.tscn` + `scripts/hud.gd` | Barra HP + messaggi |
| `scenes/ui/touch.tscn` + `scripts/touch.gd` | 4 TouchScreenButton |

## Come ricrearlo in Xogot (Godot su iPhone/iPad)

1. Crea un nuovo progetto vuoto chiamato `RedEyesDemo`.
2. Apri `project.godot` e **sostituisci tutto il contenuto** con quello di
   questo repo. Chiudi e riapri il progetto perché input map e viewport
   vengano ricaricati.
3. Copia i 4 PNG di `assets/sprites/**` nel progetto **negli stessi
   percorsi** (via app File/iCloud o import di Xogot): al primo accesso
   Godot li importa da solo (i file `.import` si rigenerano).
4. Nel FileSystem crea le cartelle: `scripts`, `scenes`,
   `scenes/enemies`, `scenes/ui`.
5. Crea e incolla gli script (Script → New… → vuoto → incolla):
   1. `scripts/sprite_factory.gd`
   2. `scripts/bullet.gd`
   3. `scripts/player.gd`
   4. `scripts/enemy.gd`
   5. `scripts/hud.gd`
   6. `scripts/touch.gd`
6. Crea e incolla le scene come file di testo `.tscn`:
   1. `scenes/bullet.tscn`
   2. `scenes/player.tscn`
   3. `scenes/enemies/enemy_soldier.tscn`
   4. `scenes/enemies/enemy_saa.tscn`
   5. `scenes/enemies/enemy_mk54.tscn`
   6. `scenes/ui/hud.tscn`
   7. `scenes/ui/touch.tscn`
   8. `scenes/main.tscn` (ultima: dipende da tutte le altre)
7. Premi Play. Controlli touch: ◀ ▶ a sinistra, salto e fuoco a destra.

Nota: la prima riga di ogni `.tscn` è un commento `; res://...` col path del
file — serve solo come promemoria di dove incollarlo.

## Cartelle asset

Le sottocartelle di `assets/` ancora vuote (audio, fx, ui, background,
`saa/cobra`, `saa/barume`…) sono pronte per i prossimi asset. I concept
art originali ad alta risoluzione restano fuori dal repo; qui ci sono le
versioni game-ready ritagliate (sfondo trasparente, altezza 84–112 px).
