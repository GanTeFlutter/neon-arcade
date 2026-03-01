# Neon Maze Runner

Karanlik labirentte yolunu bul. Sinirli gorunurluk, neon iz, zamana karsi yaris. 50 level, 5 zorluk kademesi.

## Dosya Yapisi

| Dosya | Amac |
|-------|------|
| `model/maze_cell.dart` | Hucre modeli: 4 duvar (ust, sag, alt, sol) + visited bayragii |
| `model/maze_game_state.dart` | Oyun durumu: grid, oyuncu, cikis, trail, timer, yildiz |
| `data/maze_generator.dart` | Recursive Backtracker algoritmasiyla labirent uretimi |
| `data/maze_levels.dart` | 50 level tanimi: boyut, sure, isik yaricapi |
| `painter/maze_game_painter.dart` | CustomPainter: duvarlar, fog of war, iz, oyuncu, cikis |
| `widget/control_joystick.dart` | 4 yonlu sanal joystick |
| `widget/maze_timer.dart` | NeonProgressBar ile zamanlayici |
| `neon_maze_view_model.dart` | Oyun mantigi: timer, hareket, duvar carpmasi, kontrol tipleri |
| `neon_maze_view.dart` | UI: GameScaffold, CustomPaint, joystick/drag, overlay'lar |
| `neon_maze_wrapper.dart` | Level secim <-> oyun gecis yoneticisi |
| `level_select/maze_level_select_view.dart` | 50 level secim ekrani (5 tier) |
| `level_select/widget/maze_level_tile.dart` | Level karti: kilit, numara, yildizlar |

## Labirent Uretim Algoritmasi (Recursive Backtracker)

### Adimlar
1. Tum hucreler 4 duvarli olarak olusturulur
2. Baslangic: hucre (0,0), visited olarak isaretle, stack'e ekle
3. Dongu (stack bosalana kadar):
   - Mevcut hucrenin ziyaret edilmemis komsularini bul (4 yon)
   - Komsu varsa: rastgele birini sec, aralarindaki duvari kaldir, komsuyu ziyaret et, stack'e ekle
   - Komsu yoksa: geri git (stack.pop)
4. Sonuc: her hucre ulasılabilir, tek dogru yol olan labirent

### Deterministik Uretim
- Seed: `levelId * 31`
- Ayni level ID her zaman ayni labirenti uretir

## Calisma Mekanizmasi

### Oyuncu Hareketi
Iki kontrol tipi (Ayarlar'dan secilir):

**Surukle (Drag) Modu:**
- Pan gesture ile surukle
- Birikimli delta takibi: `_dragDx`, `_dragDy`
- Esik: `cellSize * 0.4` piksel
- Yatay/dikey yone gore hareket karari
- Esik asilinca hareket et ve delta'yi sifirla

**Joystick Modu:**
- 4 yonlu butonlar: ust(0), sag(1), alt(2), sol(3)
- Her butona basista aninda hareket denemesi

### Duvar Carpmasi
```
Mevcut hucrenin ilgili duvari acik mi kontrol:
- Yukari: cell.top == false mi?
- Asagi: cell.bottom == false mi?
- Sola: cell.left == false mi?
- Saga: cell.right == false mi?
Duvar kapaliysa hareket engellenir.
```

### Sinir Kontrolu
- `0 <= yeniSatir < rows` ve `0 <= yeniSutun < cols`
- Sinir disina cikma engellenir

### Fog of War (Sis Mekanigi)
Radyal gradient shader ile gorunurluk sinirlamasi:
```
Gradient merkezi: oyuncu pozisyonu (piksel)
Gradient yaricapi: lightRadius * cellWidth

Renk duraklar:
[0%]    seffaf
[50%]   seffaf
[80%]   arka plan %85 opak
[100%]  arka plan %100 opak
```
- Oyuncu etrafinda aydinlik alan, gerisi karanlik
- Isik yaricapi level zorluguna gore azalir

### Oyuncu Izi (Trail)
- Her hareket `Offset(col, row)` olarak kaydedilir
- Tekrar kontrolu: son pozisyonla ayni degilse eklenir
- Painter'da soluklasan daireler olarak cizilir
- Alpha: `(index / toplamIz) * 0.25` (giderek parlayan)

### Zamanlayici
- Her tick'te `timeLeft -= dt`
- Kalan sure 0'a ulasinca: **TIME UP** (Game Over)
- Timer %25'in altina dustugunde kirmiziya doner

### Yildiz Hesaplama
```
Kalan sure orani = timeLeft / totalTime
>= %50: 3 yildiz
>= %25: 2 yildiz
<  %25: 1 yildiz
```

## Level Yapisi — 50 Level, 5 Tier

| Tier | Leveller | Izgara | Sure | Isik Yaricapi | Renk |
|------|----------|--------|------|---------------|------|
| EASY | 1-10 | 8x8 | 30 sn | 4.0 hucre | Cyan |
| MEDIUM | 11-20 | 10x10 | 25 sn | 3.5 hucre | Magenta |
| HARD | 21-30 | 12x12 | 25 sn | 3.0 hucre | Yesil |
| EXPERT | 31-40 | 15x15 | 22 sn | 2.5 hucre | Sari |
| MASTER | 41-50 | 18x18 | 20 sn | 2.0 hucre | Kirmizi |

### Kilit Acma
```
acik = (id == 1) VEYA (onceki levelin yildizi > 0) VEYA (kendi yildizi > 0)
```

## Painter Detaylari

### Cizim Sirasi
1. **Trail**: Soluklasan daireler (radius: min(cellW,cellH)*0.15, blur: 4px)
2. **Duvarlar**: Ince cizgiler (1.5px, alpha 0.5) — sadece acik duvarlar cizilmez
3. **Cikis**: Yesil neon daire — glow (12px blur) + border (2px) + dolgu
4. **Oyuncu**: Tier renginde daire — glow (10px blur) + govde + ic parlama (beyaz)
5. **Fog of War**: Radyal gradient overlay (tum canvas uzerine)

## Sabitler

| Sabit | Deger | Aciklama |
|-------|-------|----------|
| Drag esigi | cellSize * 0.4 | Surukle modu hareket esigi |
| Oyuncu yaricapi | min(cellW,cellH) * 0.3 | Oyuncu boyutu |
| Cikis yaricapi | min(cellW,cellH) * 0.3 | Cikis isareti boyutu |
| Trail yaricapi | min(cellW,cellH) * 0.15 | Iz boyutu |
| Trail maks alpha | 0.25 | En parlak iz noktasi |
| Duvar kalinligi | 1.5 px | Duvar cizim kalinligi |
| Fog gradient duraklar | [0, 0.5, 0.8, 1] | Sis gecis noktalari |
| Joystick boyutu | 150x150 px | Joystick alani |
| Joystick butonu | 44x44 px | Tek buton boyutu |
| Timer kirmizi esik | %25 | Renk degisim esigi |

## Ses ve Titresim

| Olay | Ses | Titresim |
|------|-----|----------|
| Hareket | `playBlip()` | `light()` |
| Level tamamlama | `playPerfect()` | `heavy()` |
| Sure dolma | `playBuzz()` | `heavy()` |

## State Yonetimi

- **Cubit/BLoC yok** — dogrudan `State` icinde yonetilir
- `MazeGameState` mutable state nesnesi
- `SingleTickerProviderStateMixin` ile Ticker
- `NeonMazeWrapper` level secim <-> oyun gecisini yonetir
- Kontrol tipi SharedPreferences'tan okunur: `mazeControlType` ('drag' / 'joystick')
