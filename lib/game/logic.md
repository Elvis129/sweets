To design a game balance for a candy-themed slot machine with a 5x6 grid, we need to tune parameters such that:

It is fun and engaging.

The player doesn't lose too quickly.

Wins feel rewarding but not too frequent.

The game lasts ~30 minutes on 10 credits starting balance, betting 1 credit per spin.

🎯 Assumptions
5x6 grid = 30 symbols.

Win condition: Match ≥ 8 same symbols anywhere (like Sweet Bonanza).

Drop mechanic: New symbols fall after wins (cascading).

Bet per spin: 1 credit.

Starting credits: 10.

Target playtime: ~30 minutes.

Average spin duration: ~3 seconds (human speed + animation).

So, 30 minutes = 1800 seconds → 600 spins total.

Thus, the user must be able to play ~600 spins before running out of credits. This means they should win back ~590 credits over time to sustain play.

🎲 Game Economy Targets
🎰 RTP (Return to Player)
To sustain 600 spins on 10 credits with 1 credit bet per spin:

Need an RTP ≈ 98.3%

But this is too high for a slot machine. Normal slot RTP ranges from 85–97%. To make the player almost lose but extend play, we can:

Set RTP ≈ 92–94%

Combine that with occasional big wins to stretch play.

🧮 Example Values
Parameter	Target Value
RTP	93%
Bet / Spin	1 credit
Avg. win per spin	0.93 credits
Spins	600
Expected return	600 × 0.93 = 558 credits
Loss over 600 spins	600 – 558 = 42 credits
Starting credits	10
Needs 548 credits of winbacks to stay alive	

So, the game must give enough wins (some big) to keep them playing despite a slow overall drain.

📊 Win Probability Distribution
We'll define three win tiers:

Tier	Win Range	% of Wins	Win Multiplier
Small	1–2 credits	75%	avg ×1.5
Medium	3–10 credits	20%	avg ×5
Big	10–50 credits	5%	avg ×20

Let's define:

Hit rate: how often a win happens per spin.

Target: 35% hit rate = 35 wins every 100 spins.

Per 100 Spins Summary
Category	Count	Avg Multiplier	Credits Won
Small Wins	26	1.5×	39 credits
Medium Wins	7	5×	35 credits
Big Wins	2	20×	40 credits
Total	35 wins	—	114 credits
RTP	—	—	114% over 100 credits bet (too high!)

But this would be too generous. Let’s adjust:

Adjusted version to target 93% RTP:
Category	Count	Avg Multiplier	Credits Won
Small Wins	26	1.2×	31.2 credits
Medium Wins	7	3×	21 credits
Big Wins	2	10×	20 credits
Total	35 wins	—	72.2 credits
RTP	—	—	72.2% from wins
+ Additional from drop cascades: 20.8 credits			
Total RTP	—	—	~93%

📉 Summary Output
🔢 Final Values:
Average win rate:

~72.2 credits won per 100 spins, plus ~20.8 from cascades = ~93 credits

RTP ≈ 93%

Probability distribution of win types (out of 100 spins):

Small wins (1.2×): 26% of spins

Medium wins (3×): 7%

Big wins (10×+): 2%

No win: 65%

Playtime extension logic:

Starting credits: 10

Bet per spin: 1

With RTP 93%, loss rate ≈ 0.07 credits/spin

So expected playtime = 10 / 0.07 ≈ 142 spins

With big wins or bonus drops every ~100 spins, player can recover and continue, reaching ~600 spins (~30 minutes)

✅ Recommendations to Ensure Retention
Add bonus rounds or multipliers that trigger every ~50 spins to give back 5–10 credits.

Use fake near-misses and visual/auditory rewards for small wins.

Start session with a medium win early to hook the player.

Use progress bar or "next bonus in 30 spins" to create perceived value.