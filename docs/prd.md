📄 Project Requirements Document (PRD)
🍬 "Candy Spin" - Mobile Slot Machine Game
Theme: Sweets & Candy, inspired by Sweet Bonanza & Sugar78
Platform: Flutter
Engine: Flame

A mobile android-only Flutter app. The type of the app and type-specific requirements are described.

I do not need any iOS parts.

1️⃣ Screens Overview & Navigation Flow
📂 Screens List & Purposes
Screen	Purpose	Navigation From / To
Loading	Initial app load, preload assets.	→ Home Page
Home Page	Start game, view credits, access shop/settings.	→ Main Game / Shop / Settings
Main Game	Core gameplay: 5x6 slot grid, spin button, winnings.	← Home / → Home
Shop	Purchase/select visual backgrounds using credits.	← Home
Settings	Adjust sounds/music, reset credits.	← Home

🔄 Navigation Logic
Loading → Home

Home → Game / Shop / Settings

Shop → Home

Settings → Home

Game → Home

2️⃣ 🎮 Game Rules & Win Conditions
Basic Mechanics:
5x6 grid of candy symbols.

Player presses Spin (costs credits per spin).

Symbols appear randomly (equal probability per symbol for MVP).

Clusters of 5+ same symbols adjacent horizontally or vertically trigger a win.

Winnings scale with cluster size (more candies = higher multiplier).

Winnings are added to credits immediately after spin.

Credits:
Starting Credits: 1000

Cost per Spin: 10 credits

Payouts (Example, MVP numbers):

5 adjacent: +20 credits

6 adjacent: +30 credits

7 adjacent: +50 credits

8+: +100 credits

3️⃣ 🖥 UI Elements per Screen
🔄 Loading
Static candy-themed splash image or logo.

Animated loading bar (candy fills, etc.).

Transition to Home on completion.

🏠 Home Page
Background (selected from shop).

Buttons: Start Game, Shop, Settings

Display: Current Credits (large font)

Small candy animation loop in background.

🎰 Main Game
Background (from selection)

5x6 grid with candy symbols.

Spin button (big, centered below grid).

Display:

Current Credits

Last Winnings (+X)

Simple particle/sparkle effect on wins.

🛍 Shop
Grid/list of background thumbnails (locked/unlocked).

Cost in credits to unlock.

Equipped background highlighted.

Display: Current Credits

Buttons: Back to Home

⚙️ Settings
Toggle Sound / Music.

Reset Credits to 1000.

Version info, simple About section.

Back to Home

4️⃣ 📦 Required Assets
🎨 Visuals
Backgrounds (4 total):

Default Candy Land

Chocolate World

Ice Cream Hills

Gummy Swamp

Candy Symbols (minimum 7 types):

Lollipop

Jellybean

Chocolate bar

Candy cane

Gummy bear

Cupcake

Macaron

UI Elements:

Buttons: Spin, Shop, Settings, Back, Buy, Equip

Currency Icon (Candy Coin / Credits)

Win Animation Sparkles

Loading Animation

🎵 Audio
Background Music: 1 looping cheerful, relaxing track (AI-generated via Suno).

Sound Effects:

Spin start

Spin stop

Winning cluster

Button clicks

Shop purchase

5️⃣ 🚩 MVP Required Features
✅ Core Features
Home, Game, Shop, Settings screens implemented with navigation.

Functional 5x6 slot grid logic with random symbol placement.

Credits system (deduct on spin, add on win).

Winning detection & payout.

Shop to unlock/select backgrounds using credits.

Persistent storage for:

Credits

Purchased backgrounds

Selected background

Basic animations: spin, wins, transitions.

Audio: 1 music track, core SFX.

Bright, candy-themed, cartoonish UI.

🚀 Stretch Goals (Post-MVP)
More complex win patterns (e.g., diagonal, special shapes).

Bonus rounds / free spins.

Special symbols (e.g., wilds, multipliers).

Achievements system.

Leaderboard / social sharing.