Q: What production target should the first release assume?
A: A small public web application deployment for learners on Oracle Cloud Infrastructure (OCI). The first production path should keep the platform simple while still exercising the full release flow: source repository, CI/CD pipeline, container registry, and Kubernetes runtime all hosted in OCI.

The application should run on a simple OCI Kubernetes cluster with one node. The first release should not over-design the cluster for high availability, complex scaling, or multi-region deployment.

Use the existing OCI tenancy. Use the Frankfurt region for the application infrastructure. The OCI CLI is installed locally and the `FRANKFURT` profile can be used. Note that the tenancy home region is Ashburn, and OCI resources that must be created in the home region should be handled there.

Q: What infrastructure and deployment responsibilities should be part of the project?
A: The project should include Infrastructure as Code using Terraform to create and manage the OCI infrastructure required by the first release.

Terraform should manage at least:

- the `wort-werk` compartment only if it is not treated as pre-existing for a given run
- an OCI Git code repository for the application source
- an OCI CI/CD pipeline that is triggered when a commit is pushed to the repository
- an OCI Container Registry repository for the application image
- a simple one-node Kubernetes cluster to run the application
- the minimum IAM, networking, and deployment resources required for the pipeline to build, publish, and deploy the application

The application build, container build, functional tests, image publishing, and Kubernetes deployment should run in the OCI CI/CD pipeline.

Secrets and OCI credentials must not be hard-coded in the repository. Use OCI-native secret, policy, dynamic group, or pipeline credential mechanisms where appropriate.

All project resources should live in one OCI compartment named `wort-werk`.

Terraform state should ideally be stored in an OCI Object Storage bucket in the same `wort-werk` compartment. The compartment and the Terraform state bucket may be managed outside this project's Terraform because Terraform needs them before it can initialise remote state. Assume they already exist, and record that the required OCIDs and names will be provided when needed.

Q: Who owns the first production release and ongoing operation?
A: The product maintainer owns release and operation for the first version. There is no separate support team for the MVP.

Q: What data posture should the first release use?
A: The MVP should minimise personal data. If accounts or learner progress storage are not already required by the PRD and slices, treat anonymous local or server-side progress as an assumption to validate, and record account-based progress as an open decision.

Q: What release strategy should the first version use?
A: Release the first level only: learners practise definite articles with nouns, images, audio, feedback, and completion after 25 distinct nouns. Defer additional levels, additional exercise types, and advanced grammar.

The build and delivery path should stay simple:

- use Maven to build the project and its artefacts
- build a runtime container based on `container-registry.oracle.com/java/jdk-no-fee-term:25.0.3`
- tag the container image with the short Git commit hash
- publish the container image to an OCI Container Registry repository using `wort-werk` as the registry repository path
- deploy the image to the one-node OCI Kubernetes cluster

When a commit is pushed to the OCI Git repository, the OCI CI/CD pipeline should automatically:

- check out the source
- run the Maven test suite
- build the application artefact with Maven
- build the container image
- run functional tests against the built container image
- publish the container image to OCI Container Registry only after tests pass
- deploy the tested image to the Kubernetes cluster

Q: What validation should block production release?
A: Automated tests should cover the article selection flow, correct and incorrect answer feedback, progression to the next noun only after the correct answer and audio completes, and level completion after 25 distinct nouns.

The functional tests should run against the built container image before the image is published or deployed. Manual smoke checks should verify the deployed Kubernetes application responds correctly and that image and audio assets load in production-like conditions.

The production plan should call out any missing Maven test, build, container, functional-test, or Kubernetes deployment commands as implementation work.

Q: What observability and rollback expectations should the plan assume?
A: The first release should include basic application health checks, client-side error visibility or reporting if available, and a simple rollback path to a previously published container image tag. The Kubernetes deployment should be able to redeploy a previous image tag if the latest release fails.

The plan should call out missing asset monitoring and learner progress backup as open decisions when relevant.

Learner progress should be saved in browser local data. The application should be stateless for the MVP.

Media assets will be provided under the `assets` directory and bundled into the container for now. The assets include a CSV file where each line lists the noun, its article, the image path, the noun-only audio path, and the audio path that includes the article. The referenced images and audio files will also be provided under `assets`. Moving these assets to a better storage or delivery mechanism is deferred.

Q: What OCI, Terraform, and CI/CD details still need answers?
A: The main path-to-production direction is answered: Terraform-managed OCI infrastructure, Frankfurt as the application region, one `wort-werk` compartment, Terraform remote state in an OCI Object Storage bucket, OCI Git repository, OCI CI/CD pipeline, OCI Container Registry, one-node Kubernetes runtime, Maven build, functional tests against the container, short-hash image tags, bundled assets, stateless application behaviour, and automatic deploy on commit.

The production plan should still record the following details and open questions:

- The user can provide the OCIDs and names for the existing `wort-werk` compartment and Terraform state bucket when needed.
- Use `wortwerk.xyz` as the public domain. The user can update DNS once the public IPs are known and can provide the TLS certificate, private key, and public certificate chain right away.
- Use `wort-werk` as the OCI Container Registry repository path. The final image reference still needs the OCI registry endpoint and tenancy namespace.
- Keep budget, availability, and backup expectations simple because this is a demo intended to prove a real end-to-end system.

Pipeline authentication to Kubernetes and Container Registry needs to be expanded in the production plan:

- Prefer OCI-native authentication for the OCI DevOps pipeline instead of long-lived user credentials.
- Define the OCI dynamic groups and IAM policies required for the build and deployment pipelines to read source, push images to OCI Container Registry, read deployment artifacts, and deploy to the OKE cluster.
- Define whether the pipeline uses OCI DevOps deployment stages directly against an OKE environment or runs Kubernetes commands from a build/deploy step.
- Define how the pipeline obtains Kubernetes deployment access, including the OKE environment reference, kubeconfig handling if needed, target namespace, and service account or OCI IAM mapping.
- Define how the Kubernetes cluster pulls images from OCI Container Registry, including whether worker nodes need policies, image pull secrets, or private network access to the registry.
- Define where TLS certificate material is stored for pipeline or Kubernetes use, for example OCI Vault, Kubernetes TLS secrets created by the pipeline, or a manually applied secret.
- Define the minimum required permissions; avoid granting broad tenancy-level access when compartment-scoped policies are sufficient.
