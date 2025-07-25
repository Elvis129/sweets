🍭 Candy Slot Game — Implementation Plan
Platform: Flutter
Game Engine: Flame
Design: Based on PRD + Visual Style Guide
Goal: MVP delivery with core game loop, visual polish, and shop feature

🗓 Timeline Overview
Week	Focus Areas
1	Project setup, asset planning, core screen scaffolding
2	Grid implementation, spin logic, credit/win system
3	UI integration (buttons, transitions), shop functionality
4	Asset integration, audio, visual polish
5	Testing, bug fixing, performance tuning

✅ 1. Project Setup & Dependencies
Tasks:
 Set up Flutter project (flutter create)

 Add Flame and Flame_audio for game loop & sounds

 Add Google Fonts, shared_preferences, flutter_svg

 Organize folder structure (/game, /screens, /ui, /assets)

 Configure Flame’s GameWidget and initialize base game loop

 Add initial routing (go_router or Navigator)

Timeline: Week 1

🎰 2. Core Game Mechanics
Tasks:
 Create 5x6 grid system for symbol rendering

 Implement random candy symbol generation

 Add spin logic (disable spin during animation)

 Deduct credits per spin, show updated total

 Detect clusters (5+ matching adjacent symbols)

 Calculate winnings, update credits

 Add simple win animations (sparkles, bounces)

 Display recent win amount (+X credits)

Timeline: Week 2

🖥 3. UI Implementation
Tasks:
 Build Loading screen with animated candy loader

 Build Home screen with buttons (Start Game, Shop, Settings)

 Build Game screen layout: grid, spin button, credit display

 Build Shop screen: grid of backgrounds, purchase & select

 Build Settings screen: toggle music/sfx, reset credits

 Implement responsive layout for mobile (portrait mode only)

 Add button animations and visual feedback (press, hover)

Timeline: Week 3

🛍 4. Shop Functionality
Tasks:
 Create background model (id, asset path, cost, purchased flag)

 Store owned & selected background in shared_preferences

 Deduct credits on purchase, confirm purchase popup

 Apply selected background to all screens dynamically

 Add "Equip" and "Buy" buttons for each background

Timeline: Week 3 (overlapping with UI)

📦 5. Asset Integration
Tasks:
 Add all sprite assets: candies, backgrounds, icons

 Create flame sprite/animation components for each candy

 Integrate background music via Suno audio file

 Add SFX: spin, win, button click, shop purchase

 Apply color palette and fonts (Baloo 2, Quicksand)

 Polish animations (spin entry, win flash, shop effects)

Timeline: Week 4

🧪 6. Testing & Polishing
Tasks:
 Test game loop for credit accuracy and win logic

 Test all UI buttons, screen transitions

 Test shop purchases, credit deduction, and persistence

 Add fallback logic if assets fail to load

 Profile game performance (FPS, jank, memory)

 Polish visual transitions and animations

 Prepare MVP build (Android/iOS)

Timeline: Week 5

🚀 Final MVP Checklist
 5x6 Candy Grid + Spin Logic

 Credit tracking & winning payouts

 4 Screens: Home, Game, Shop, Settings

 Candy-themed UI with custom buttons and fonts

 Shop system with 4 unlockable backgrounds

 Working audio (BGM + SFX)

 Persisted user data (credits, background)

 Responsive on various screen sizes