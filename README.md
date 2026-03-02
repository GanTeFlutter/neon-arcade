<h1 align="center">
  arcadeX — NEON ARCADE
</h1>

<h3 align="center">5-in-1 Neon Mini Game Pack</h3>

<p align="center">
  <b>Stack blocks. Solve puzzles. Match colors. Smash pong. Escape mazes.</b><br/>
  Five addictive arcade games wrapped in a vibrant neon aesthetic.
</p>

---

## Gameplay

<p align="center">
  <a href="https://www.instagram.com/p/DVXCn3YjOMY/">
    <img src="https://img.shields.io/badge/Watch%20Gameplay-Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white" alt="Watch on Instagram"/>
  </a>
</p>

---

## Games

| # | Game | Color | Description |
|---|------|-------|-------------|
| 1 | **NEON STACK** | `#39FF14` | Stack falling blocks with pixel-perfect precision. Land them perfectly for combo bonuses. |
| 2 | **GLOW GRID** | `#FFE700` | Toggle lights on a grid to solve each puzzle. 3 hints per level, star rating system. |
| 3 | **COLOR PULSE** | `#FF00FF` | Match falling colored orbs to a rotating ring. Build combos, don't lose your lives. |
| 4 | **NEON PONG** | `#FF6B35` | Classic pong reborn with 10 power-ups, 6 obstacle types, boss battles, and 3 game modes. |
| 5 | **NEON MAZE** | `#00FFFF` | Navigate procedural mazes in the dark under time pressure. Drag or joystick controls. |

### NEON PONG — Deep Dive

Neon Pong is the flagship game with three distinct modes:

- **Campaign** — 30 levels across 5 themed worlds (Neon City, Magenta Forge, Toxic Grid, Solar Flare, Red Void), each ending with a boss battle featuring unique attack patterns (spread shots, shields, lasers, clones, blackout).
- **Endless** — Survive as long as you can against increasingly aggressive AI.
- **Quick Match** — First to 11 points. Choose Easy, Medium, or Hard difficulty.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.10+ / Dart 3.10+ |
| **State Management** | flutter_bloc / Cubit + Freezed |
| **Dependency Injection** | get_it |
| **Navigation** | go_router (type-safe, code-generated) |
| **Localization** | easy_localization (EN / TR) |
| **Local Storage** | SharedPreferences + Hive CE |
| **Audio** | audioplayers |
| **Remote Config** | Firebase Remote Config |
| **Linting** | very_good_analysis |

---

## Architecture

```
lib/
├── feature/                 # Feature modules
│   ├── games/
│   │   ├── neon_stack/      # StatefulWidget + Ticker
│   │   ├── glow_grid/       # Cubit + Freezed
│   │   ├── color_pulse/     # StatefulWidget + Ticker
│   │   ├── neon_pong/       # StatefulWidget + Ticker + Mixins
│   │   └── neon_maze/       # StatefulWidget + Ticker
│   ├── main_menu/
│   └── settings/
└── product/                 # Shared infrastructure
    ├── cache/               # SharedCache & ProductCache
    ├── const/               # NeonColors, fonts
    ├── navigation/          # GoRouter config
    ├── service/             # Audio, Score, Vibration services
    ├── theme/               # Dark neon theme + NeonGameColors extension
    └── widget/              # Reusable neon UI components
```

**Key patterns:**
- Real-time games (Pong, Stack, Maze, Pulse) use `StatefulWidget` + `Ticker` for 60 FPS game loops with `CustomPainter` rendering.
- Discrete/puzzle games (Glow Grid) use `Cubit` + `Freezed` for clean state transitions.
- All rendering is done via `CustomPainter` — no game engine dependency.

---

## Theme & Design

| Property | Value |
|----------|-------|
| Background | `#0A0A1A` |
| Surface | `#0F0F2A` |
| Mode | **Dark only** — forced neon aesthetic |
| Display Font | **Orbitron** — futuristic headings |
| Arcade Font | **Press Start 2P** — retro scores & labels |
| Body Font | **Poppins** / **Inter** |

All game colors are defined in `NeonColors` with glow helper utilities for consistent neon effects across the app.

---

## Getting Started

```bash
# Clone the repository
git clone https://github.com/neonoyunlar/arcadex_akillisletme.git
cd arcadex_akillisletme

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run
flutter run
```

### Requirements

- Flutter SDK `>=3.10.7`
- Dart `>=3.10.7`
- Android SDK / Xcode for target platform

---

## Project Info

| | |
|--|--|
| **Package** | `com.arcadex.akillisletme` |
| **Version** | 1.0.1+2 |
| **Languages** | English, Turkish |
| **Developer** | [Neon Oyunlar](https://www.instagram.com/p/DVXCn3YjOMY/) |

---

<p align="center">
  Built with Flutter & neon dreams
</p>
