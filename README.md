<!-- res://README.md -->
# RedEyesDemo

Run & gun 2D stile Metal Slug in Godot 4.x. Protagonista su esoscheletro
SAA, sprite pixel-art e animazioni generati interamente via codice (nessuna
risorsa esterna: niente PNG, niente audio — tutto `Image.create`).

- Viewport 640x360, stretch `canvas_items` / `expand`, landscape.
- Renderer **Compatibility** (GL) — gira anche su iPhone/iPad (Xogot).
- Input: `move_left`, `move_right`, `jump`, `fire` (tastiera: A/D o frecce,
  Space/W, X/J) + controlli touch a schermo.
- Layer fisici: `1` mondo, `2` player, `4` nemici (i proiettili sono
  Area2D su layer 0 con mask impostata da chi spara).
- Animazioni: `AnimatedSprite2D` con `SpriteFrames` procedurali (idle,
  corsa, salto/caduta, fuoco con rinculo), flash di sparo al muzzle e
  proiettili traccianti (gialli il player, rossi i nemici).

## Struttura dei file

| Path | Contenuto |
|---|---|
| `project.godot` | Config progetto, input map, layer |
| `scenes/main.tscn` | Livello: Player, Ground 3200x64, 2 nemici, HUD, Touch |
| `scenes/player.tscn` + `scripts/player.gd` | Player (speed 240, jump -560, gravity 1500, cooldown sparo) |
| `scenes/bullet.tscn` + `scripts/bullet.gd` | Proiettile condiviso player/nemici |
| `scenes/enemies/enemy_soldier.tscn` | Fante: hp 3, burst 1 |
| `scenes/enemies/enemy_saa.tscn` | SAA Barume: hp 10, burst 3 |
| `scripts/enemy.gd` | Logica nemici (`@export hp/speed/burst` + `style`) |
| `scripts/sprite_factory.gd` | Sprite pixel-art e animazioni generati via `Image.create` |
| `scenes/ui/hud.tscn` + `scripts/hud.gd` | Barra HP + messaggi |
| `scenes/ui/touch.tscn` + `scripts/touch.gd` | 4 TouchScreenButton |

## Come ricrearlo in Xogot (Godot su iPhone/iPad)

Incolla i file **in questo ordine esatto** — prima gli script, poi le scene
che li usano, per ultima `main.tscn` che istanzia tutto:

1. Crea un nuovo progetto vuoto chiamato `RedEyesDemo`.
2. Apri `project.godot` e **sostituisci tutto il contenuto** con quello di
   questo repo. Chiudi e riapri il progetto perché input map e viewport
   vengano ricaricati.
3. Nel FileSystem crea le cartelle: `scripts`, `scenes`,
   `scenes/enemies`, `scenes/ui`.
4. Crea e incolla gli script (Script → New… → vuoto → incolla):
   1. `scripts/sprite_factory.gd`
   2. `scripts/bullet.gd`
   3. `scripts/player.gd`
   4. `scripts/enemy.gd`
   5. `scripts/hud.gd`
   6. `scripts/touch.gd`
5. Crea e incolla le scene come file di testo `.tscn` (in Xogot: crea il
   file col nome giusto e incolla il contenuto):
   1. `scenes/bullet.tscn`
   2. `scenes/player.tscn`
   3. `scenes/enemies/enemy_soldier.tscn`
   4. `scenes/enemies/enemy_saa.tscn`
   5. `scenes/ui/hud.tscn`
   6. `scenes/ui/touch.tscn`
   7. `scenes/main.tscn` (ultima: dipende da tutte le altre)
6. Project Settings → Application → Run → Main Scene =
   `res://scenes/main.tscn` (già impostata dal `project.godot` del punto 2).
7. Premi Play. Controlli touch: ◀ ▶ a sinistra, salto e fuoco a destra.

Nota: la prima riga di ogni `.tscn` è un commento `; res://...` col path del
file — serve solo come promemoria di dove incollarlo.

## Cartelle asset

`assets/**` è pronta per gli sprite veri (SAA mk54 / swashbuckler / cobra /
barume, nemici, fx, ui, audio, background): finché è vuota il gioco usa i
placeholder generati via codice.
