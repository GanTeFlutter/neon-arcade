# Neon Stack

Dikey blok istifleme oyunu. Sag-sol salinan blogu dogru zamanda birakarak kuleleri yukseltir.

## Dosya Yapisi

| Dosya | Amac |
|-------|------|
| `model/stack_game_state.dart` | Oyun durumu modeli (bloklar, skor, combo, hiz) |
| `neon_stack_view_model.dart` | Oyun mantig: 60fps ticker loop, fizik, PERFECT algilama |
| `neon_stack_view.dart` | UI katmani: GameScaffold, kamera sistemi, overlay'lar |
| `widget/stack_block_widget.dart` | Tek blok widget'i: gradient + neon glow |
| `widget/perfect_flash.dart` | "PERFECT!" animasyonu: elastik scale + fade |
| `widget/falling_piece.dart` | Dusme animasyonu: kesilen parca asagi kayar |

## Oyun Dongusu

1. `Ticker` ile 60fps game loop (`_onTick`)
2. Delta time hesaplama: `dt = (elapsed - lastTick) / 1_000_000`
3. Blok pozisyonu guncelleme: `movingX += speed * direction * dt`
4. Sinir kontrolu: `maxX = 1.0 - movingWidth`, sinira ulasinca yon degisir
5. Her frame `setState()` ile UI yenilenir

## Calisma Mekanizmasi

### Blok Hareketi
- Blok normalize koordinatlarda (0.0-1.0) sag-sol gider
- `speed * direction * dt` formulu ile hiz hesaplanir
- Sinira carptiysa `direction` tersine doner

### Birakma ve Hizalama
- Tap ile blok birakiliyor
- Alttaki blokla overlap hesabi:
  ```
  overlapLeft  = max(movingLeft, targetLeft)
  overlapRight = min(movingRight, targetRight)
  overlapWidth = overlapRight - overlapLeft
  ```
- Overlap <= 0: blok tamamen iskalandi -> **Game Over**
- Overlap > 0: sadece ortusen kisim yeni blok olur (blok daralir)

### PERFECT Sistemi
- Tolerans: `perfectTolerance = 0.015` (ekran genisliginin %1.5'i)
- Sol VE sag kenar farki tolerans icindeyse PERFECT
- PERFECT'de blok daralmaz, combo artar
- Skor: PERFECT = `2 + combo`, Normal = `1`

### Combo Sistemi
- Ard arda PERFECT'lerde combo sayaci yukselir
- Combo >= 3: blok genisleme bonusu baslar
- Bonus formulu: `comboWidthBonus(0.02) * (combo - 2)` kadar genislik eklenir
- Maksimum genislik: 0.9 (ekranin %90'i)
- Herhangi bir hizasiz birakma combo'yu sifirlar

### Hiz Artisi
- Her 10 blokta `speed *= 1.08` (% 8 artis)
- Baslangic hizi: 0.6 birim/sn
- Maksimum hiz: 1.8 birim/sn (3x baslangic)

### Kamera Sistemi
- Blok yuksekligi: ekran yuksekliginin %4'u
- Gorulur blok sayisi asildiysa kamera yukari kayar
- `cameraOffset = (blockCount - visibleBlocks + 3) * blockH`

## Sabitler

| Sabit | Deger | Aciklama |
|-------|-------|----------|
| `perfectTolerance` | 0.015 | PERFECT esigi (%1.5 genislik) |
| `comboWidthBonus` | 0.02 | Combo basina genislik bonusu |
| `speedIncrement` | 0.08 | 10 blokta bir hiz carpani |
| `maxSpeed` | 1.8 | Maksimum hiz limiti |
| Baslangic `speed` | 0.6 | Ilk blok hizi |
| Baslangic `movingWidth` | 0.4 | Ilk blok genisligi (%40 ekran) |
| `blockH` | h * 0.04 | Blok yuksekligi |
| PERFECT flash suresi | 900ms | Animasyon goruntuleme |
| Dusme animasyonu | 600ms | Kesilen parcanin dusme suresi |
| Dusme mesafesi | 200px | Parcanin katedigi mesafe |

## Renk Paleti

Bloklar 6 renkten olusan gradient'te dongusel olarak renklendirilir:
```
Cyan -> Acik Cyan -> Cyan-Mavi -> Mavi -> Mavi-Magenta -> Magenta
```
Indeks arttikcaa palet basina doner.

## Ses ve Titresim

| Olay | Ses | Titresim |
|------|-----|----------|
| Normal birakma | `playBlip()` | `light()` |
| PERFECT | `playPerfect()` | `medium()` |
| Game Over | `playBuzz()` | `heavy()` |

## State Yonetimi

- **Cubit/BLoC yok** — oyun state'i dogrudan `State` icinde
- `StackGameState` class'i tum durumu tutar (mutable)
- `SingleTickerProviderStateMixin` ile 60fps Ticker
- `pauseGame()` / `resumeGame()` public metodlari
