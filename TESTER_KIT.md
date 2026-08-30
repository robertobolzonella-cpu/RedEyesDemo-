# RedEyesDemo — Kit del tester 🎮

Grazie per testare la demo! Servono ~10 minuti. Nessuna installazione:
si gioca dal browser del telefono.

## 1. Avvio

- **URL**: https://robertobolzonella-cpu.github.io/RedEyesDemo-/
- Oppure inquadra il QR: ![QR della demo](tester_qr.png)
- Requisiti: iPhone/Android con browser aggiornato (Safari 16+ / Chrome),
  connessione dati (~35 MB al primo caricamento, poi resta in cache).
- **Ruota il telefono in orizzontale** prima di iniziare.
- Primo avvio: 10–30 secondi di caricamento su schermo scuro: è normale.
- Se resta bloccato oltre 1 minuto: ricarica la pagina.

## 2. Controlli (touch)

| Zona schermo | Azione |
|---|---|
| Cerchio in basso a sinistra (1°) | ◀ cammina a sinistra |
| Cerchio in basso a sinistra (2°) | ▶ cammina a destra |
| Cerchio in basso a destra (1°) | salto |
| Cerchio in basso a destra (2°) | fuoco (tieni premuto = raffica) |

Da PC: A/D o frecce, Space/W = salto, X/J = fuoco.

## 3. Obiettivo e percorso

Sei il pilota del SAA **Mk-54**. Vai sempre a destra fino al
**MISSION COMPLETE**. Il livello ha 4 zone:

1. **Tutorial** — un fante isolato ti attacca; raccogli la croce verde
   (+30 vita) dopo aver subito danni.
2. **Piattaforme** — 3 piattaforme e 2 burroni: caderci dentro = morte.
   Le piattaforme si attraversano saltando da sotto.
3. **Pressione** — checkpoint (bandiera che diventa verde), poi
   un'imboscata: 3 fanti + un samurai **Cobra** che ti carica in mischia
   quando gli sei vicino.
4. **Mini-boss** — un muro si alza alle tue spalle: arena chiusa col
   Cobra potenziato. Uccidilo (25 colpi), poi tocca la bandiera verde.

Morto? Ricarica la pagina per ripartire.

## 4. Cosa osservare durante il test

- [ ] Il gioco carica e parte (scritta "RED EYES - DEMO")
- [ ] I 4 tasti touch rispondono sempre (anche premuti insieme:
      correre + sparare, correre + saltare)
- [ ] Il personaggio non attraversa mai pavimenti o muri
- [ ] Salto dei burroni: si riesce al primo tentativo partendo dal bordo?
- [ ] Il pickup cura davvero (barra vita in alto a sinistra)
- [ ] Il Cobra smette di sparare e ti corre addosso sotto i ~3 cm di schermo
- [ ] Nell'arena finale non si riesce a scappare a sinistra
- [ ] "MISSION COMPLETE" appare e il gioco si ferma pulito
- [ ] Frame rate: scatti o rallentamenti? Dove?
- [ ] Surriscaldamento/batteria anomali dopo 10 minuti?

## 5. Come segnalare un bug 🐛

Apri una Issue su GitHub (o manda un messaggio) con:

```
Dispositivo: (es. iPhone 13, iOS 18.2, Safari)
Zona del livello: (1 tutorial / 2 piattaforme / 3 imboscata / 4 boss)
Cosa stavi facendo:
Cosa è successo:
Cosa ti aspettavi:
Screenshot/video: (se possibile)
Riproducibile: sempre / a volte / una volta sola
```

Issues: https://github.com/robertobolzonella-cpu/RedEyesDemo-/issues

## Problemi noti (non serve segnalarli)

- Niente audio: previsto, non ancora implementato.
- Niente animazioni di camminata a frame: i personaggi "ondeggiano"
  (animazione procedurale provvisoria).
- Morendo si ricomincia dall'inizio: il checkpoint è solo visivo.
- Su schermi molto stretti i tasti touch possono risultare piccoli.
