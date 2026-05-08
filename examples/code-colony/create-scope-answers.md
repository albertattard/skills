Q: Who is the first real user we are designing for?
A: The first real user is a beginner learner, especially a kid or early teen, who is curious about programming but has little or no Java experience.

Secondary users are teachers, workshop leaders, and parents, but the MVP should optimize the player experience for the learner first. Facilitator needs matter only where they make the learner flow practical to run in a classroom or workshop.

Q: What is the smallest first-version behaviour that would prove the product is useful?
A: A learner can open the game in a browser, read a short intro, start Mission 01, enter or run a small Java command, and see a CORE unit visibly change state because of that code.

The smallest useful mission is `Wake The CORE`: the learner calls `Core.connect();`, the game executes real Java behind the scenes, and the UI changes from an offline docked unit to an online CORE with visible status telemetry. This proves the core promise: code causes understandable action in the game world.

Q: What should count as completing the first playable release?
A: Completion for the first playable release should be a short classroom-friendly mission sequence, not a full game.

The release should include:

- an intro screen that explains the player's role, CORE units, and the browser code loop
- Mission 01: connect to CORE-01 with `Core.connect();`
- Mission 02: store the connected CORE in a variable and charge it to full battery
- Mission 03: move CORE-01 to the repair station and repair it
- session-based progression so successful code can carry forward into the next mission
- clear compile, runtime, mission-success, and mission-incomplete feedback

Do not include multiplayer, accounts, save slots, a large mission map, advanced Java topics, unrestricted scripting, free-form modding, or public hosting in the MVP.
