Q: For the first version, what single workflow must prove the product is useful?
A: A manager can scan all PoCs, identify blocked or stale work, and decide where to intervene.

Q: In the manager triage view, what should count as a stale PoC?
A: Use a concrete default: any non-terminal PoC whose latest activity is at least seven calendar days old. Terminal states are `Accepted` and `Rejected`; all other states are non-terminal. Latest activity is the most recent of the PoC creation timestamp and any journal entry timestamp. State transitions must create system journal entries, so their timestamps count through the journal. Calendar-day calculations should use the application's configured business timezone. For the MVP, default that timezone to `Europe/Berlin` and keep it configurable so a later deployment can change it without changing stale-calculation logic.

Q: When the manager “decides where to intervene,” should the MVP stop at surfacing the PoCs that need attention, or should it let the manager record/assign an intervention action inside the app?
A: Stop at surfacing the PoCs that need attention and letting the manager open the PoC context. Recording assignments or intervention tasks would pull the MVP towards workflow management.

Q: For the MVP, how do PoC records and journal/state updates get into the system?
A: PoC records should be maintained manually in the app, with only the minimal create, edit, journal entry, and state update capabilities needed to keep the manager triage view accurate.

Q: For the MVP, how should manager selection affect visibility and attribution?
A: Every manager can see every PoC in the portfolio triage view. Manager selection is used only to attribute manual changes, journal entries, and state transitions to the manager who made them. It must not filter the portfolio by owner or selected manager. State transitions should be recorded as system journal entries attributed to the selected manager.
