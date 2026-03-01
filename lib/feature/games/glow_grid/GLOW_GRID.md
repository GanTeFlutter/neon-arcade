# Glow Grid

Lights Out bulmaca oyunu. Hucrelere tiklayarak tum isiklari sondur. 100 level, 5 zorluk kademesi.

## Dosya Yapisi

| Dosya | Amac |
|-------|------|
| `data/grid_levels.dart` | 100 level tanimi, tier konfigurasonu, prosedural level uretimi |
| `model/grid_move.dart` | Geri alma icin hamle kaydi (row, col) |
| `state/glow_grid_state.dart` | Freezed state: hucreler, hamle sayisi, undo stack, yildiz |
| `state/glow_grid_cubit.dart` | Oyun mantigi: tap, toggle, undo, tamamlanma kontrolu |
| `widget/grid_cell.dart` | Animasyonlu hucre: acik/kapali/kilitli durumlari |
| `widget/grid_toolbar.dart` | Geri al + hamle sayaci + sifirla |
| `widget/level_complete_overlay.dart` | Tamamlanma ekrani: yildizlar + butonlar |
| `level_select/level_select_view.dart` | 100 level secim ekrani (5 tier) |
| `level_select/widget/level_tile.dart` | Tekil level karti: kilit/yildiz gosterimi |
| `glow_grid_view.dart` | Level secim <-> oyun gecis yoneticisi |

## Oyun Mekanizmasi

### Temel Mekanik
- Hucreye tikla -> kendisi + 4 komsu (ust/alt/sag/sol) toggle olur
- Amac: tum hucreleri kapatmak (0 yapmak)
- Kazanma kosulu: `cells.every((c) => c <= 0)` (kilitli hucreler -1)

### Hucre Durumlari
| Deger | Durum | Aciklama |
|-------|-------|----------|
| `1` | Acik | Isik yaniyor, tiklanabilir |
| `0` | Kapali | Isik sonuk, tiklanabilir |
| `-1` | Kilitli | Degistirilemez, toggle engelliyor |

### Tier 5 Capraz Efekt
- Master tier'da (81-100) tiklandinginda 8 komsu da toggle olur
- Normal: 4 yon (ust, alt, sag, sol)
- Capraz: 8 yon (4 kardinal + 4 capraz)

### Geri Alma (Undo)
- Her hamle `GridMove(row, col)` olarak stack'e kaydedilir
- Undo: ayni hucreye tekrar tiklama simule edilir (toggle idempotency)
- Level tamamlanmissa undo kullanilamaz

### Yildiz Hesaplama
```
3 yildiz: hamle <= optimal hamle
2 yildiz: hamle <= optimal hamle + 2
1 yildiz: hamle > optimal hamle + 2
```
- Optimal hamle = baslangic durumundaki `1` degeri olan hucre sayisi

## Level Yapisi — 100 Level, 5 Tier

| Tier | Leveller | Izgara | Ozellik | Renk |
|------|----------|--------|---------|------|
| EASY | 1-20 | 3x3 | Temel pattern'lar | Cyan |
| MEDIUM | 21-40 | 4x4 | Zor pattern'lar | Magenta |
| HARD | 41-60 | 5x5 | Prosedural uretim | Yesil |
| EXPERT | 61-80 | 5x5 | Kilitli hucreler (2-3) | Sari |
| MASTER | 81-100 | 6x6 | Kilitli + Capraz toggle | Kirmizi |

### Level Uretimi
- **Tier 1-2**: Onceden tanimlanmis sabit pattern'lar (20'ser adet)
- **Tier 3**: Prosedural 5x5 — bos grid uzerinde 2-5 simule tap uygulayarak uretilir
- **Tier 4**: Tier 3 gibi + 2-3 kilitli hucre eklenir (sadece kapali hucrelere)
- **Tier 5**: 6x6 capraz toggle + 2-4 kilitli hucre

### Kilit Acma Mantigi
```
acik = (id == 1) VEYA (onceki levelin yildizi > 0) VEYA (kendi yildizi > 0)
```
- Level 1 her zaman acik
- Sonraki leveller icin onceki basarilmis olmali

## State Yonetimi

- **BLoC + Freezed** mimarisi
- `GlowGridCubit` ile oyun mantigi
- `GlowGridState` Freezed state class'i (immutable)
- Her eylem `copyWith()` ile yeni state emit eder
- Tamamlanma tespiti her tap'ten sonra otomatik yapilir

## Sabitler

| Sabit | Deger | Aciklama |
|-------|-------|----------|
| Hucre animasyonu | 200ms | Toggle animasyon suresi |
| Backdrop blur | 8px | Tamamlanma overlay'i |
| Baslangic ipucu | 3 | Level basina ipucu hakki |
| Grid sutunlari | 5 | Level secim gridinde |
| Hucre margin | 2px | Hucreler arasi bosluk |
| Yildiz esikleri | +0 / +2 | 3 yildiz / 2 yildiz siniri |

## Ses ve Titresim

| Olay | Ses | Titresim |
|------|-----|----------|
| Hucre tap | `playBlip()` | `light()` |
| Level tamamlama | `playSynth()` | `medium()` |
