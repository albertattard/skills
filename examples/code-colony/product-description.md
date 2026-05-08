# Product Description

Code Colony is a browser-based programming strategy game where learners restore a silent off-world colony by writing Java code. The player acts as a remote engineer for Helix Dynamics and controls CORE maintenance units through short mission-based coding challenges.

The product is designed for kids, early teens, and other beginning programmers who need Java concepts to feel concrete. Instead of solving abstract exercises, learners write small Java statements, run them in the browser, watch a CORE unit act in a visible mission space, and revise the code based on immediate feedback.

The first experience should make coding feel like commanding a machine in a real world. A learner reads a short mission briefing, reviews a limited command list, edits a small Java code area, clicks `Run`, and sees the CORE unit connect, charge, move, repair, or fail with readable feedback.

The story should support motivation without overwhelming the lesson. The colony on Eryndor-IV has gone silent, direct personnel deployment is suspended, and the player must restore systems remotely through CORE units. The tone should be mysterious, technical, and optimistic rather than frightening.

The educational design should introduce one or two concepts per mission. Early missions should focus on:

- calling a method to trigger an action
- storing the result of `Core.connect()` in a local variable
- calling instance methods repeatedly
- sequencing commands to move and repair a CORE unit

The learner should not need to install Java, use an IDE, manage project files, understand engine internals, or configure a build. The game should hide the surrounding Java structure and expose only the small student-facing API needed by the current mission.

The coding surface should use progressive disclosure. Early missions should show only the smallest useful editable area, such as a few statements inside a hidden method body. As learners gain confidence, later missions should gradually zoom out: first editing and creating methods, then working with a full class, and eventually understanding package-level organization. The goal is to reveal Java structure only when the learner has a reason to use it, instead of exposing the whole project model on day one.

Missions should be data-driven and editable outside compiled code. Structured mission data, including mission order, grid size, tiles, stations, CORE spawn state, allowed commands, objectives, and validation rules, should live in YAML files under top-level `content/`. Markdown should be reserved for learner-facing prose such as briefings, hints, command explanations, and narrative text. A learner or content author should be able to adjust an existing mission that uses supported mechanics by editing mission files without recompiling Java.

The first release should prove that a beginner can start in the browser, understand the premise, run real Java code, see visible mission feedback, and complete a short sequence of beginner-friendly missions.
