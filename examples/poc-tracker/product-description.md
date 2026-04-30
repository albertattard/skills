# Product Description

Managing Proof of Concepts (PoCs) across an organisation is often fragmented and opaque. Information is scattered across emails, chat threads, and informal updates, making it difficult for managers to understand the current status, ownership, and progress of each initiative. This lack of visibility leads to missed risks, delayed interventions, and lost learning opportunities.

The PoC Tracker is a web-based application designed to provide a centralised, structured view of all ongoing and completed PoCs within an organisation. Its primary goal is to give managers a clear, current view of the records maintained in the application: what is being worked on, who is responsible, and how each PoC is progressing. The UI does not automatically poll for updates; users refresh the page to see changes made elsewhere.

At its core, the system organises PoCs into a defined lifecycle with clearly distinguishable states:

| State              | Description                                                                       |
| ------------------ | --------------------------------------------------------------------------------- |
| **Proposal**       | The PoC has been pitched and is awaiting customer feedback                        |
| **Planning**       | The PoC has been approved and scope and success criteria are being defined        |
| **Implementation** | The PoC is actively being implemented and technical work is in progress           |
| **Blocked**        | Progress on the PoC is currently halted due to an issue requiring attention       |
| **Evaluation**     | Implementation is complete and the PoC is under customer evaluation               |
| **Accepted**       | The PoC has been evaluated and confirmed as successful                            |
| **Rejected**       | The PoC has been evaluated and did not meet expectations, triggering a postmortem |

This structured lifecycle enables consistent tracking and makes it easy to identify bottlenecks, stalled efforts, and successful outcomes across the portfolio.

Each PoC record captures essential ownership and context, including the responsible internal owner, the customer involved, and key metadata needed for accountability and reporting.

A central feature of the application is the **journal system**, which provides a chronological narrative of each PoC. Every update-whether it is a progress note, a decision, or a state transition-is recorded as a journal entry. This is a simple append-only log for auditability and context, not an event-sourcing system that needs to replay changes. The journal creates a complete, transparent history that can be read end-to-end, allowing stakeholders to quickly understand what happened, why decisions were made, and how outcomes were reached.

By combining structured state tracking with rich, time-ordered activity logs, the PoC Tracker transforms scattered updates into a coherent, auditable story. Managers can quickly assess risk (e.g., blocked PoCs), monitor progress across teams, and ensure that both successes and failures contribute to organisational learning.

Ultimately, the PoC Tracker aims to replace fragmented communication with clarity, improve accountability, and turn every PoC into a source of actionable insight.
