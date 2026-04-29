# Product Description

Preparing a customer workshop often involves scattered notes, agenda drafts, exercise ideas, and follow-up reminders spread across documents, emails, and chat messages. This makes it difficult for a trainer to keep the workshop plan coherent, especially when the plan needs to balance customer goals, available time, participant experience, exercises, breaks, and preparation work.

The Workshop Planner is a local web application designed to help a trainer prepare and run customer workshops from one structured plan. Its primary goal is to turn workshop preparation into a clear agenda that can be reviewed before the workshop and used as a facilitator guide during the session.

At its core, the application helps the trainer capture the workshop context:

- customer name
- workshop title
- workshop date
- total duration
- target audience
- workshop goals

The trainer can then build an agenda from ordered blocks. Each agenda block captures the time allocation, topic, facilitation notes, and optional exercise or material references. Blocks can represent introductions, teaching segments, hands-on exercises, discussions, breaks, wrap-ups, or other workshop activities.

The application also tracks preparation items needed before the workshop, such as creating slides, checking sample repositories, printing handouts, preparing exercises, or confirming room setup. Each preparation item can be marked as pending or done so the trainer can quickly see what remains before the session.

A key feature is the facilitator view. This view presents the workshop as a clean run-of-show: the ordered agenda, timing, topics, exercises, materials, notes, and preparation status. The facilitator view should make it easy to run the workshop from a laptop without switching between multiple documents.

The first version is intentionally simple and local. It runs on the trainer's laptop, uses an in-memory H2 database while the application is running, and does not preserve workshop plans after the application stops. It does not need accounts, cloud deployment, container delivery, CI/CD, external calendar integration, email invitations, attendee management, or long-term workshop history.

Ultimately, the Workshop Planner aims to help trainers move from scattered preparation notes to a practical, structured workshop plan that supports delivery on the day.
