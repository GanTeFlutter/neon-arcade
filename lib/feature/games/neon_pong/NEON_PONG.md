# Neon Pong

Klasik pong oyunu neon stilde. Topu paddle ile sektir, power-up'lar topla, en yuksek skoru kir.

## Dosya Yapisi

| Dosya | Amac |
|-------|------|
| `model/pong_ball.dart` | Top modeli: pozisyon, hiz, yaricap, trail listesi (max 12) |
| `model/power_up.dart` | Power-up turleri (expand, slow, shield) ve PowerUp sinifi |
| `model/pong_game_state.dart` | Oyun durumu: toplar, paddle, skor, can, power-up'lar, kalkan |
| `painter/pong_game_painter.dart` | CustomPainter: top+trail, paddle, kalkan, power-up, ust duvar |
| `neon_pong_view_model.dart` | Oyun mantigi: top fizigi, carpma, power-up spawn, can sistemi |
| `neon_pong_view.dart` | UI: GameScaffold, yatay surukle, can iconlari, overlay'lar |

## Oyun Dongusu

1. `Ticker` ile 60fps game loop
2. Delta time hesaplama
3. Power-up efekt suresi guncelleme
4. Power-up spawn zamanlayici
5. Power-up hareketi ve paddle carpismasi
6. Top fizigi: pozisyon guncelleme, duvar/paddle carpmasi
7. Can kaybi kontrol
8. `setState()` ile UI yenilenir

## Calisma Mekanizmasi

### Top Fizigi
- Pozisyon: `x += vx * dt`, `y += vy * dt`
- Baslangic hizi: 280 px/sn
- Spawn acisi: `-pi/2 ± pi/6` (yukari +/-30 derece sapma)
- Sol/sag duvar: `vx` yon degistirir
- Ust duvar: `vy` yon degistirir
- Alt sinir: top kaybolur -> can kaybi

### Paddle Etkilesimi
**Carpma Algilama:**
```
top asagi gidiyor (vy > 0)
VE top.y + radius >= paddleTop
VE top.y + radius <= paddleTop + 15
VE top.x paddleLeft ile paddleRight arasinda
```

**Sekme Acisi Hesabi:**
```
relativeHit = (top.x - paddleLeft) / paddleGenislik
aci = -pi/2 + (relativeHit - 0.5) * pi * 0.7
```
- Merkezden vurus: duz yukari (-90 derece)
- Sol kenardan: sola acili (-153 derece)
- Sag kenardan: saga acili (-27 derece)
- Maks aci yayilimi: +/-63 derece

**Hiz Artisi:**
- Her paddle sekisinde hiz %2 artar: `speed *= 1.02`
- `vx = cos(aci) * yeniHiz`, `vy = sin(aci) * yeniHiz`

### Paddle Kontrolu
- Yatay surukle (GestureDetector `onHorizontalDragUpdate`)
- Normalize koordinatlar: `paddleX += deltaX / ekranGenislik`
- Clamping: paddle ekrandan cikmaz

### Power-Up Sistemi

| Tur | Renk | Efekt | Sure |
|-----|------|-------|------|
| **Expand** | Yesil | Paddle 1.6x genisler (maks %50 ekran) | 8 sn |
| **Slow** | Cyan | Tum toplar 0.6x yavaslama | 5 sn |
| **Shield** | Sari | Alt sinirda tek kullanimlik kalkan | Tek kullanim |

- Spawn araligi: 8 saniye
- Dusus hizi: 80 px/sn
- Yaricap: 12 px
- Rastgele tur ve pozisyon (30px kenar margini)
- Paddle ile carpince aktif olur

### Kalkan Mekanigi
- Shield power-up ile aktif olur
- Alt sinirda top kaybolmak yerine geri sekmesi saglanir
- `vy = -|vy|` ile top yukari doner
- Tek kullanim sonrasi deaktif olur

### Can Sistemi
- 3 can ile baslar
- Top alt siniri gecerse 1 can kaybi (kalkan yoksa)
- Can = 0: Game Over
- UI'da 3 kalp ikonu ile gosterilir

### Top Trail
- Son 12 pozisyon kaydedilir
- Her frame `updateTrail()` yeni pozisyon ekler
- Eskiden yeniye: soluklasan ve kuculen dairelerle cizilir

## Painter Detaylari

### Cizim Sirasi
1. **Ust duvar**: Yatay cizgi (alpha 0.3, 2px) + glow (4px blur)
2. **Paddle**: RRect (10px yukseklik, 5px radius) + glow (10px blur), Cyan renk
3. **Kalkan**: Paddle uzerinde sari yatay cizgi (aktifse)
4. **Power-up'lar**: Daire — glow (8px blur) + border (2px) + dolgu (alpha 0.15)
5. **Top trail**: Soluklasan daireler (alpha 0-0.3, boyut artarak)
6. **Top**: Glow (12px blur) + govde (8px) + ic parlama (beyaz, 2px blur)

## Sabitler

| Sabit | Deger | Aciklama |
|-------|-------|----------|
| `_initialBallSpeed` | 280 px/sn | Baslangic top hizi |
| `radius` | 8 px | Top yaricapi |
| `maxTrail` | 12 | Maks trail noktasi |
| `paddleWidth` | 0.2 | Varsayilan paddle genisligi (%20) |
| `paddleY` | 30 px | Paddle'in alttan mesafesi |
| Hiz artisi | 1.02x | Her sekiste hiz carpani |
| Expand carpani | 1.6x | Genisleme miktari |
| Expand maks | 0.5 | Maks genislik (%50 ekran) |
| Slow carpani | 0.6x | Yavaslatma miktari |
| Power-up spawn | 8 sn | Uretme araligi |
| Power-up hizi | 80 px/sn | Dusus hizi |
| Power-up radius | 12 px | Boyutu |
| Expand suresi | 8 sn | Genisleme efekt suresi |
| Slow suresi | 5 sn | Yavaslatma efekt suresi |
| Baslangic can | 3 | Oyun basi can |

## Ses ve Titresim

| Olay | Ses | Titresim |
|------|-----|----------|
| Paddle sekme | `playBlip()` | `light()` |
| Power-up toplama | `playChime()` | `medium()` |
| Kalkan kullanimi | `playChime()` | — |
| Top kaybi | `playBuzz()` | `heavy()` |

## State Yonetimi

- **Cubit/BLoC yok** — dogrudan `State` icinde yonetilir
- `PongGameState` mutable state nesnesi
- `SingleTickerProviderStateMixin` ile Ticker
- `// ignore_for_file: cascade_invocations` — game loop okunabilirligi icin
