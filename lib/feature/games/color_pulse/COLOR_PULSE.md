# Color Pulse

Renk eslestirme ritim oyunu. Toplar merkezde donen renkli halkaya dogru dusuyor. Renk eslesince tap yap!

## Dosya Yapisi

| Dosya | Amac |
|-------|------|
| `model/falling_ball.dart` | Top modeli: renk, aci, hiz, mesafe, pozisyon hesabi |
| `model/pulse_game_state.dart` | Oyun durumu: toplar, halka rengi, skor, can, combo, araliklarr |
| `painter/pulse_game_painter.dart` | CustomPainter: halka, toplar, kilavuz cizgiler, can gostergesi |
| `color_pulse_view_model.dart` | Oyun mantigi: tick, top uretimi, tap eslestirme, zorluk artisi |
| `color_pulse_view.dart` | UI: GameScaffold, CustomPaint, combo flash, overlay'lar |

## Oyun Dongusu

1. `Ticker` ile 60fps game loop
2. Delta time hesaplama
3. Halka renk degisimi zamanlayici
4. Halka pulse animasyonu (0.6 - 1.0 nefes efekti)
5. Top uretimi zamanlayici
6. Top pozisyon guncelleme: `progress += speed * dt`
7. Merkeze ulasan toplari otomatik kaldirma (can kaybi)
8. `setState()` ile UI yenilenir

## Calisma Mekanizmasi

### Top Hareketi
- Toplar 4 yonden (0, 90, 180, 270 derece) spawn olur
- Kucuk rastgele sapma: `jitter = (random - 0.5) * 0.3` radyan
- Duz cizgi boyunca merkeze dogru ilerler
- Pozisyon: `mesafe = maxDist * (1 - progress)`, progress 0->1 (kenar->merkez)
- `maxDist = min(genislik/2, yukseklik/2) * 0.85`

### Halka Renk Degisimi
- 4 renk arasindan sirayla doner: Cyan, Magenta, Yesil, Sari
- Varsayilan aralik: 2.0 saniye
- Zorluk arttikca aralik kisalir (min 0.8 sn)

### Tap Eslestirme
- Ekrana dokunuldugunda merkeze en yakin top secilir (en yuksek progress)
- Top rengi == halka rengi: **Dogru esleme**
  - Top kaldirilir, combo artar
  - Skor: `min(combo, 5)` puan (maks 5x carpan)
- Top rengi != halka rengi: **Yanlis esleme**
  - Top kaldirilir, combo sifirlanir
  - 1 can kaybi

### Combo Sistemi
- Ard arda dogru tap'lerde combo artar
- Yanlis tap veya kacirilan top combo'yu sifirlar
- Combo >= 3: ekranda "x{combo}" gosterilir (700ms flash)
- Carpan: `min(combo, 5)` — maksimum 5x

### Can Sistemi
- 3 can ile baslar
- Kayip kosullari: yanlis tap VEYA kacirilan top (merkeze ulasan)
- Can = 0: Game Over

### Zorluk Artisi
Her 10 puanda:
```
topHizi      *= 1.1   (maks 0.9)
uretmeAraligi *= 0.92  (min 0.6 sn)
halkaAraligi  *= 0.95  (min 0.8 sn)
```

### Top Uretme Mantigi
- %60 ihtimalle halka rengiyle ayni renk (eslestirilebilir)
- %40 ihtimalle farkli renk (tuzak)

## Painter Detaylari

### Cizim Sirasi
1. **Kilavuz cizgiler**: 4 yonlu silik cizgiler (alpha 0.06)
2. **Merkez halka**: Cok katmanli — glow (20px blur) + dolgu + border (3px) + ic glow
3. **Toplar**: Her top — dis glow (10px blur) + govde (14px) + ic parlama (3px blur)
4. **Can gostergesi**: 3 daire, alt merkez, aktif=kirmizi+glow, pasif=soluk

## Sabitler

| Sabit | Deger | Aciklama |
|-------|-------|----------|
| `ballSpeed` | 0.35 | Baslangic top hizi (birim/sn) |
| `spawnInterval` | 1.8 sn | Top uretme araligi |
| `ringInterval` | 2.0 sn | Halka renk degisim araligi |
| `lives` | 3 | Baslangic can |
| `ballRadius` | 14 px | Top boyutu |
| `ringRadius` | 36 px | Halka boyutu |
| Combo flash suresi | 700ms | Ekranda gosterim suresi |
| Maks carpan | 5x | Combo puanlamasi limiti |
| Top hizi maks | 0.9 | Hiz siniri |
| Uretme araligi min | 0.6 sn | Min uretme araligi |
| Halka araligi min | 0.8 sn | Min renk degisim araligi |

## Ses ve Titresim

| Olay | Ses | Titresim |
|------|-----|----------|
| Dogru esleme | `playBlip()` | `light()` |
| Yanlis esleme | `playBuzz()` | `heavy()` |
| Kacirilan top | `playBuzz()` | `medium()` |

## State Yonetimi

- **Cubit/BLoC yok** — dogrudan `State` icinde yonetilir
- `PulseGameState` mutable state nesnesi
- `SingleTickerProviderStateMixin` ile Ticker
- Frame bazli guncelleme ve `setState()` cagrisi
