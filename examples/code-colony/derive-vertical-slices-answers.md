Q: How should the first vertical slices be shaped?
A: Slice by learner-visible mission outcomes, not by technical layer.

Use these early slices:

- game intro and start flow
- Mission 01 connect flow with real Java execution and visible status update
- mission briefing modal and command reference
- Mission 02 charge flow with carried code and variable-based CORE reference
- Mission 03 repair flow with movement, station-dependent repair, and sequencing
- content-driven mission files, with YAML for structured map/objective/runtime data and Markdown only for learner-facing prose
- session progression between missions

Q: Should the first slice implement the full mission engine?
A: No. The first slice should prove one end-to-end mission loop with the smallest engine surface needed for Mission 01.

Avoid building a broad mission framework before the connect mission works in the browser. Expand the engine only when Mission 02 and Mission 03 require repeated actions, station rules, map state, and carried code.

Q: How should content-driven mission work be sliced?
A: Treat content-driven mission definition as an incremental migration, not a prerequisite for the first playable slice.

Start with enough structure for Mission 01 to run. Then move mission data into `content/missions/<mission-id>/` files as separate slices:

- map size, tile legend, base grid, stations, spawns, and telemetry into `map.yaml`
- allowed commands, runtime command gating, objectives, execution settings, validation copy, and completion rules into `mission.yaml`
- briefing, hints, command explanations, initial run prose, and explain text into `content.md`

The end state should allow adding or changing a mission that uses existing mechanics by editing mission files only, with no Java recompilation.

Q: Are prepared clarification answers needed for vertical slicing?
A: Yes. If the slicing skill sees a conflict between building the smallest possible MVP and the richer current project direction, prefer the three-mission classroom prototype as the first release boundary, with Mission 04 reserved for proving no-code mission addition later.
