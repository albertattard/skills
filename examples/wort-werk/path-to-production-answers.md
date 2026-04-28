Q: What production target should the first release assume?
A: A small public web application deployment for learners on Oracle Cloud Infrastructure (OCI). The plan should assume one production environment and one pre-production or staging environment in OCI.

The project must include the infrastructure-as-code needed to create and manage the required OCI resources with Terraform. Terraform state and infrastructure changes are managed from the maintainer's laptop, not from the CI/CD pipeline. The application must be built in the CI/CD pipeline and deployed from the pipeline to the OCI-managed runtime.

Q: What infrastructure and deployment responsibilities should be part of the project?
A: The project should include Terraform configuration for the OCI infrastructure needed by the first release, plus a CI/CD pipeline that builds, tests, packages, and deploys the application. The path to production should separate these responsibilities:

- Infrastructure provisioning and changes: run Terraform from the maintainer's laptop.
- Application build and verification: run in the CI/CD pipeline.
- Application deployment: run from the CI/CD pipeline to the provisioned OCI environment.
- Secrets and OCI credentials: do not hard-code them in the repository; use the CI/CD platform's secret mechanism and local secure configuration for Terraform.

The first production plan should identify the minimum viable OCI architecture rather than over-designing the platform.

Q: Who owns the first production release and ongoing operation?
A: The product maintainer owns release and operation for the first version. There is no separate support team for the MVP.

Q: What data posture should the first release use?
A: The MVP should minimise personal data. If accounts or learner progress storage are not already required by the PRD and slices, treat anonymous local or server-side progress as an assumption to validate, and record account-based progress as an open decision.

Q: What release strategy should the first version use?
A: Release the first level only: learners practise definite articles with nouns, images, audio, feedback, and completion after 25 distinct nouns. Defer additional levels, additional exercise types, and advanced grammar.

The release strategy should include:

- provision or update OCI infrastructure with Terraform from the maintainer's laptop
- build and test the application in the CI/CD pipeline
- publish the deployable application artifact from the pipeline
- deploy the artifact from the pipeline into the OCI pre-production environment
- run pre-production smoke checks
- promote or redeploy the same verified artifact to production
- retain a way to roll back to the previous deployable artifact

Q: What validation should block production release?
A: Automated tests should cover the article selection flow, correct and incorrect answer feedback, progression to the next noun only after the correct answer and audio completes, and level completion after 25 distinct nouns. Manual smoke checks should verify image and audio assets load in production-like conditions.

The CI/CD pipeline must run the automated checks before building or deploying the release artifact. The production plan should call out any missing test, build, or deployment commands as implementation work.

Q: What observability and rollback expectations should the plan assume?
A: The first release should include basic application health checks, client-side error visibility or reporting if available, and a simple rollback path to the previous deployable version. The plan should call out missing asset monitoring and learner progress backup as open decisions when relevant.

Q: What OCI, Terraform, and CI/CD details still need answers?
A: The production plan should record the following as open questions until answered:

- Which CI/CD system should be used?
- Which OCI region and tenancy should host pre-production and production?
- Should pre-production and production use separate OCI compartments, separate Terraform workspaces, separate state files, or another separation model?
- Where should Terraform state be stored when managed from the laptop?
- What OCI runtime should host the application: static object storage plus CDN, container service, VM, Kubernetes, or another target?
- How should DNS and TLS certificates be managed?
- How should the pipeline authenticate to OCI for application deployment?
- What artifact format should the pipeline produce and retain for rollback?
- Are learner progress data, media assets, or generated audio files stored in OCI-managed services, bundled with the application, or served from an external location?
- What budget, availability, and backup expectations should constrain the OCI architecture?
