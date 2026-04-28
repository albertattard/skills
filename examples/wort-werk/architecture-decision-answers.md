Q: Which architecture decisions should be recorded as ADRs for the first release?
A: Record ADRs for durable technical choices that materially constrain implementation tasks:

- Use OCI as the production platform, with source repository, CI/CD pipeline, container registry, and Kubernetes runtime hosted in OCI.
- Use Terraform for project infrastructure, with remote state in an OCI Object Storage bucket that may be treated as pre-existing.
- Use a simple one-node OCI Kubernetes cluster for the first release.
- Use OCI DevOps to run the build, container build, functional tests, image publishing, and deployment pipeline.
- Use OCI Container Registry with short Git commit hash image tags.
- Keep the application stateless for the MVP and save learner progress in browser local data.
- Bundle image, audio, and CSV learning assets into the container for the first release.

Do not create ADRs for routine task sequencing, UI details, documentation index updates, individual Terraform resource names, or deferred asset hosting outside the container.

Q: What ADR status should unattended runs use?
A: Use `Accepted` when the decision is explicit in the path-to-production plan or source artefacts. Use `Proposed` only when the source artefacts identify a durable architecture decision but leave the actual choice unresolved.

Q: Which candidate decisions should remain open instead of becoming accepted ADRs?
A: Keep OCI registry endpoint and tenancy namespace, exact OCIDs for existing compartment and Terraform state bucket, TLS certificate storage, Kubernetes deployment access, image pull authentication, and detailed OCI IAM policy mapping as proposed ADRs or open questions unless the source artefacts clearly settle them.

Q: How should ADRs relate to downstream implementation tasks?
A: Implementation tasks should reference only the ADRs that materially constrain them. Infrastructure tasks should reference the OCI and Terraform ADRs. Delivery pipeline tasks should reference the OCI DevOps and Container Registry ADRs. Kubernetes deployment tasks should reference the one-node Kubernetes ADR. Learner progress tasks should reference the stateless/browser-local progress ADR. Asset loading and packaging tasks should reference the bundled assets ADR.

Q: Should the ADR step ask follow-up questions?
A: No. The runbook must run unattended. Use the source artefacts, repository context, and these answers. When a durable decision is unresolved, create a proposed ADR or leave the candidate in its source context and mention it in the final summary.
