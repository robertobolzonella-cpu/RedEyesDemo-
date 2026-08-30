<!-- res://README.md -->
# RedEyesDemo

Run & gun 2D stile Metal Slug in Godot 4.x. Il player pilota il SAA
**Mk-54**. Gli sprite dei personaggi vengono dai concept art del progetto
(PNG in `assets/sprites/**`); effetti (flash, traccianti, pickup)
generati via codice, nessun altro asset esterno.

- Viewport 640x360, stretch `canvas_items` / `expand`, landscape.
- Renderer **Compatibility** (GL) — gira anche su iPhone/iPad (Xogot).
- Input: `move_left`, `move_right`, `jump`, `fire` (tastiera: A/D o frecce,
  Space/W, X/J) + controlli touch a schermo.
- Layer fisici: `1` mondo, `2` player, `4` nemici (proiettili Area2D su
  layer 0 con mask impostata da chi spara).
- Animazioni procedurali: bob di corsa, tilt in salto, rinculo; flash al
  muzzle e traccianti (gialli il player, rossi i nemici).

## Personaggi

| Sprite | Ruolo |
|---|---|
| `assets/sprites/saa/mk54/mk54.png` | **Mk-54** — il player (hp 100) |
| `assets/sprites/enemies/trooper.png` | **Fante Barume** — colpo singolo (hp 3) |
| `assets/sprites/saa/swashbuckler/swashbuckler.png` | **Samurai Cobra** — raffica x3 a distanza, charge melee sotto i 200 px |
| `assets/sprites/saa/player_exo.png` | Esoscheletro crema — riserva/variante futura |

## Level design — `scenes/levels/level_01.tscn` (3200 px)

| Beat | Zona | Contenuto |
|---|---|---|
| 1 "tutorial" | 0–700 | Terreno piano, 1 fante, power-up vita (+30). Nessun salto obbligatorio |
| 2 "piattaforme" | 700–1500 | 3 piattaforme one-way ad altezze diverse, 2 fanti appostati (sopra/sotto), 2 burroni saltabili da 120 px con kill zone |
| 3 "pressione" | 1500–2400 | Checkpoint visivo (bandiera), trigger → ondata di 3 fanti + 1 Cobra melee |
| 4 "mini-boss" | 2400–3200 | Trigger → muro d'arena alle spalle + boss Cobra (hp 25, scala 1.15). Alla sua morte il muro cade e appare il traguardo → MISSION COMPLETE |

Meccaniche: `spawn_point.gd` (Area2D one-shot: scena nemico, count,
spacing, overrides, boss flag), `pickup.gd` (+30 HP), `checkpoint.gd`
(bandiera rossa→verde), `level.gd` (regia arena/goal/kill zone), charger
melee in `enemy.gd` (`melee=true`: sotto `melee_range` smette di sparare
e corre a velocità doppia, colpo da mischia con cooldown).

## Struttura dei file

| Path | Contenuto |
|---|---|
| `project.godot` | Config, input map, layer; main scene = level_01 |
| `scenes/levels/level_01.tscn` | Il livello a 4 beat |
| `scripts/level.gd` | Regia: boss, muro arena, traguardo, kill zone |
| `scenes/player.tscn` + `scripts/player.gd` | Mk-54 (speed 240, jump -560, gravity 1500, `heal()`) |
| `scenes/bullet.tscn` + `scripts/bullet.gd` | Proiettile condiviso |
| `scenes/enemies/enemy_soldier.tscn` | Fante Barume |
| `scenes/enemies/enemy_saa.tscn` | Samurai Cobra |
| `scripts/enemy.gd` | AI nemici + charger melee |
| `scenes/pickup.tscn` + `scripts/pickup.gd` | Power-up vita |
| `scripts/spawn_point.gd` | Trigger ondate |
| `scripts/checkpoint.gd` | Checkpoint visivo |
| `scripts/sprite_factory.gd` | Flash di sparo + sprite procedurali di riserva |
| `scenes/ui/hud.tscn` + `scripts/hud.gd` | Barra HP, messaggi, `show_permanent` |
| `scenes/ui/touch.tscn` + `scripts/touch.gd` | 4 TouchScreenButton |

## Come ricrearlo in Xogot (Godot su iPhone/iPad)

1. Nuovo progetto vuoto `RedEyesDemo`.
2. Sostituisci il contenuto di `project.godot`; chiudi e riapri il progetto.
3. Copia i PNG di `assets/sprites/**` negli stessi percorsi (app File):
   l'import è automatico.
4. Cartelle: `scripts`, `scenes`, `scenes/enemies`, `scenes/ui`,
   `scenes/levels`.
5. Script, in quest'ordine:
   1. `scripts/sprite_factory.gd`
   2. `scripts/bullet.gd`
   3. `scripts/player.gd`
   4. `scripts/enemy.gd`
   5. `scripts/hud.gd`
   6. `scripts/touch.gd`
   7. `scripts/pickup.gd`
   8. `scripts/spawn_point.gd`
   9. `scripts/checkpoint.gd`
   10. `scripts/level.gd`
6. Scene, in quest'ordine:
   1. `scenes/bullet.tscn`
   2. `scenes/player.tscn`
   3. `scenes/enemies/enemy_soldier.tscn`
   4. `scenes/enemies/enemy_saa.tscn`
   5. `scenes/pickup.tscn`
   6. `scenes/ui/hud.tscn`
   7. `scenes/ui/touch.tscn`
   8. `scenes/levels/level_01.tscn` (ultima)
7. Play. Touch: ◀ ▶ a sinistra, salto e fuoco a destra.

Nota: la prima riga di ogni `.tscn` è un commento `; res://...` col path —
promemoria di dove incollarlo.

## Demo web e CI

La demo gira nel browser: build HTML5 sul branch `gh-pages`, servita da
GitHub Pages (repo pubblico richiesto). La GitHub Action
`.github/workflows/deploy-web.yml` ri-esporta e aggiorna `gh-pages` a
ogni push su `main` o sul branch di lavoro — il link resta allineato al
codice. Kit per i tester in `TESTER_KIT.md`.

## Cartelle asset

Le sottocartelle vuote di `assets/` (audio, fx, ui, background, `saa/cobra`,
`saa/barume`…) sono pronte per i prossimi asset. I concept originali ad
alta risoluzione restano fuori dal repo; qui ci sono le versioni
game-ready (sfondo trasparente, 84–100 px).
