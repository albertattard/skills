Q: For the first version, what single workflow must prove the product is useful?
A: A trainer can prepare one customer workshop plan, build an ordered agenda with exercises and facilitation notes, track required preparation items, and open a facilitator view that is useful during the workshop.

Q: Should the MVP support one workshop plan at a time or a list/history of multiple workshops?
A: Support one active workshop plan at a time. The first version is a local laptop tool for preparing the current workshop, not a long-term workshop portfolio or archive.

Q: What agenda behaviour is essential for the MVP?
A: The trainer must be able to add, edit, delete, and reorder agenda blocks. Each agenda block should capture at least a title or topic, duration in minutes, facilitation notes, and optional exercise/material references. The app should show the total planned duration and make it visible when the agenda does not match the workshop duration.

Q: What preparation tracking is essential for the MVP?
A: The trainer must be able to add preparation items, mark them pending or done, and see pending items in the facilitator view. Preparation items should stay simple: title, optional note, and status. Do not add owners, due dates, reminders, or notifications.

Q: What should the facilitator view include?
A: The facilitator view should show the workshop context, ordered agenda blocks, block durations, cumulative timing or total duration, facilitation notes, exercise/material references, and preparation item status. It should be readable from a laptop during the workshop.

Q: How should data be stored in the MVP?
A: Use an H2 in-memory database through the Spring application while it is running. Data may survive page refreshes during the same running application session, but it is intentionally lost when the application stops. Do not add file persistence, H2 file mode, external databases, export storage, or backup behaviour.

Q: What should be explicitly out of scope?
A: Exclude authentication, multiple users, durable persistence, workshop history, PDF export, email invitations, calendar integration, attendee management, resource booking, cloud deployment, containers, CI/CD, and production operations.
