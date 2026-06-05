# 🪐 ORBIT DEFENDER

<p align="center">
<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0b0f19,50:1e3a8a,100:000000&height=220&section=header&text=ORBIT%20DEFENDER&fontSize=54&fontColor=ffffff&animation=fadeIn&fontAlignY=35&desc=2D%20Sci-Fi%20Space%20Defense%20Built%20with%20Flutter%20and%20Flame&descAlignY=60"/>
</p>

<p align="center">
<img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter">
<img alt="Dart" src="https://img.shields.io/badge/Dart-3.x-blue?logo=dart">
<img alt="Flame Engine" src="https://img.shields.io/badge/Engine-Flame-orange">
<img alt="Platform" src="https://img.shields.io/badge/Platform-Web%20%7C%20Mobile-green">
<img alt="Game" src="https://img.shields.io/badge/Genre-Sci--Fi%20Orbital%20Defense-purple">
</p>

---

# 🚀 About The Project

**ORBIT DEFENDER** is an intense **2D sci-fi space defense game** built using **Flutter** and the **Flame Game Engine**. 

You play as the last operational defense satellite orbiting a vulnerable home planet. Your mission is simple: hold the orbital line, manage your energy reserves, and intercept incoming cosmic threats.

* 🔫 **Shoot** through fields of asteroids and alien fighter squadrons.
* 🛡️ **Defend** the planetary core from catastrophic impacts.
* 📦 **Collect** floating energy cores, shield generators, and weapon upgrades.
* 🌌 **Survive** increasingly chaotic waves of deep-space enemies.

This project demonstrates **radial physics, circular movement math, projectile collision detection, wave-based state management, and neon particle effects** across mobile and web platforms.

---

# 🎮 Gameplay

The gameplay loop is built around precision movement and target prioritization:

1. Orbit around the central planet to position yourself against incoming threats.
2. Intercept and destroy asteroids and enemy ships before they breach the atmosphere.
3. Manage your weapon's energy levels to prevent overheating.
4. Pick up dropped salvage (planet shields, scatter lasers, EMP blasts) to turn the tide.
5. Survive the sector to face faster, heavily armored dreadnoughts in the next wave.

---

# ✨ Features

## 🛰️ Defense Satellite & Arsenal

* Smooth 360-degree orbital movement mechanics.
* Energy management and overheating systems.
* Multiple weapon states (e.g., Twin Plasma, Spread Laser, Railgun).
* Auto-aiming or manual targeting mechanics based on control scheme.

## ☄️ Cosmic Threats

* **Asteroids:** Unpredictable space debris that fragments upon taking damage.
* **Seekers:** Fast, agile alien drones that try to crash into the planet.
* **Dreadnoughts:** Heavy, shielded cruisers that require sustained fire to destroy.
* Radial pathfinding logic converging from the edge of the screen to the center.

## 🌊 Dynamic Wave System

* Endless scaling difficulty across different cosmic sectors.
* Enemies increase in velocity, armor, and spawn density as waves progress.
* Intermission periods for cooling down weapons and repairing the planet.

## 📱 Custom HUD & Menus

* Native Flutter UI overlays for Main Menu, Pause, and Mission Failed screens.
* Real-time survival HUD tracking:
  * 🌍 Planetary Core Health & 🛡️ Shield Integrity
  * ⚡ Weapon Energy/Heat Bar
  * 🌌 Sector/Wave Number
  * 🏆 Score & Threat Elimination Count

---

# 🎮 Controls

## Desktop & Web

| Action | Control |
|--------|---------|
| Orbit Left/Right | A & D / Left & Right Arrow Keys |
| Aim & Shoot | Mouse Cursor & Left Click |
| Pause | Top-Right Pause Button |

## Mobile

| Action | Control |
|--------|---------|
| Orbit Left/Right | Left Virtual Joystick / Screen Edge Taps |
| Aim & Shoot | Right Virtual Joystick / Auto-fire toggle |
| Pause | Top-Right Pause Button |

---

# 🧱 Tech Stack

| Technology | Role |
|------------|------|
| Flutter | Cross‑platform framework & Overlay UI |
| Flame Engine | 2D game engine loop & physics |
| Dart | Core programming language |
| Canvas Rendering | Sprite rendering and neon visuals |

---

# 📂 Project Structure

```text
lib/
│
├── main.dart                 # App entry point, neon theme, and UI Overlays
├── orbit_game.dart           # Core game loop, wave manager, rendering state
├── constants.dart            # Global space physics (gravity, speeds, damage)
│
└── components/
    ├── planet_core.dart      # Central base logic, health, and atmosphere
    ├── satellite.dart        # Player logic, orbital movement, shooting
    ├── enemy_ship.dart       # Alien logic, radial tracking, collisions
    ├── asteroid.dart         # Debris physics and fragmentation logic
    ├── laser_beam.dart       # Projectile mechanics and hit registration
    ├── space_loot.dart       # Power-up mechanics (Shields, Energy, Weapons)
    ├── starfield.dart        # Parallax background rendering
    └── hud.dart              # Flame-based text and circular progress bars