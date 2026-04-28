Q: What task granularity should the first implementation task plan use?
A: Use small, independently grabbable tasks. A task may include UI, domain logic, assets, tests, and documentation when those pieces are needed to deliver one observable learner or release-readiness outcome. Do not split tasks by technical layer unless the technical work is shared across multiple product capabilities or is required as its own production-readiness task.

Q: What capability areas should the tasks use?
A: Use these capability areas where they fit:

- `article-practice`: definite article exercise flow, answer selection, correctness feedback, progression, and level completion.
- `learning-assets`: CSV asset loading, image display, noun-only audio, article+noun audio, and bundled media validation.
- `learner-progress`: progress tracking for 25 distinct nouns, browser-local progress persistence, and stateless MVP behaviour.
- `container-delivery`: Maven build, container image build, short-hash image tags, functional tests against the container, and OCI Container Registry publishing.
- `oci-infrastructure`: Terraform-managed OCI resources, compartment assumptions, remote state references, OCI Git repository, OCI DevOps pipeline, OCI Container Registry, OKE cluster, networking, IAM, and deployment resources.
- `operations`: health checks, client-side error visibility or reporting, smoke checks, rollback to a previous image tag, TLS/DNS handling, and operational documentation.

Prefer product/domain capability areas over technical areas. Use `container-delivery`, `oci-infrastructure`, and `operations` only for work that is shared across product capabilities or comes directly from the path-to-production plan.

Q: Should production-readiness work become implementation tasks?
A: Yes. Include production-readiness tasks required for the first release, especially Maven test/build commands, container image build, functional tests against the built container, OCI Container Registry publishing, Terraform infrastructure, OCI DevOps pipeline setup, one-node OKE deployment, health checks, smoke checks, TLS/DNS handling, and rollback documentation.

Q: What first release boundary should the task plan assume?
A: The first release should cover the first level only: learners practise definite articles with nouns, images, audio, immediate feedback, progression to the next noun only after the correct answer and audio completes, and completion after 25 distinct nouns. Defer additional levels, additional exercise types, advanced grammar, account-based progress, and asset hosting outside the container.

Q: Should the task plan create capability sub-indexes from the start?
A: Yes. Create the main `docs/tasks/README.md` and capability sub-indexes under `docs/tasks/capabilities/` because this example includes several product and infrastructure capability areas and should demonstrate the growth-friendly structure.

Q: What readiness values should the task plan prefer?
A: Mark tasks as `ready-for-agent` when the source artefacts and repository context provide enough information to implement them. Mark tasks as `needs-human-decision` for unresolved OCI OCIDs, Terraform state bucket details, registry endpoint and tenancy namespace, TLS certificate storage, pipeline authentication, Kubernetes access, and any account-based learner progress decision. Mark tasks as `manual-only` only for work that requires external access, credentials, DNS updates, certificate material, or production operation. Use `blocked-by-task` when another generated task must land first.

Q: What validation expectations should tasks include?
A: Acceptance criteria must be observable and verifiable. Include automated test expectations when practical, including article selection flow tests, feedback tests, progression tests, level-completion tests, Maven tests, functional tests against the running container, and manual smoke checks for deployed assets. Use measurable thresholds only when they clarify behaviour or readiness; do not invent fake precision.

Q: Should remote tracker issues be created?
A: No. Write local Markdown task files under `docs/tasks/` only. Do not create GitHub, Jira, Linear, or other remote tracker issues.
