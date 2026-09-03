# CI/CD Configuration Governance

A production-style reference implementation for version-controlled configuration deployment, validation gates, failure evidence, and AI-assisted change review.

## Why This Exists

A deployment pipeline should not only deploy files successfully.

It should prove that the approved configuration version was deployed.

A common operational risk is when a pipeline succeeds technically, but deploys the wrong configuration version. That kind of success is worse than failure because everyone trusts the green checkmark, and the green checkmark lies like a tiny automated politician.

## What This Repository Demonstrates

- Git-backed application configuration
- Ansible-based deployment
- Configuration validation gate
- Failure on unapproved configuration version
- Evidence logging
- Failure scenario simulation
- Pre-deployment rejection of unapproved configuration
- Post-deployment state verification
- SHA-256 configuration integrity verification
- Separation of configuration and approval policy
- Foundation for AI-assisted configuration risk review

## Architecture

```text
Git-backed candidate configuration
        ↓
Pre-deployment governance validation
        ↓
Approved release policy check
        ↓
        ├── Fail → deployment blocked
        │
        └── Pass
              ↓
        Ansible deployment
              ↓
        Post-deployment verification
              ↓
        Version + SHA-256 verification
              ↓
        Evidence captured
              ↓
        Deployment accepted
```

See:

```text
architecture.md
```

## Repository Structure

```text
.
├── .github/
│   ├── CODEOWNERS
│   └── workflows/
│       └── configuration-governance.yml
├── ai-review/
│   ├── config_change_review_prompt.md
│   ├── risk_matrix.md
│   └── sample_ai_review.md
├── ansible/
│   ├── inventory.ini
│   ├── pre_validate.yml
│   ├── deploy.yml
│   └── post_validate.yml
├── config-repo/
│   └── app-config.yml
├── policy/
│   └── approved-release.yml
├── docs/
│   ├── failure-scenarios.md
│   └── production-scenario.md
├── examples/
│   ├── setup-evidence.log
│   ├── deployment-evidence.log
│   ├── validation-success.log
│   ├── runner-success.log
│   └── bad-config-failure.log
├── scripts/
│   ├── run_deployment.sh
│   └── simulate_bad_config.sh
└── architecture.md
```

## Run Deployment

```bash
./scripts/run_deployment.sh
```

## Simulate an Unapproved Configuration

```bash
./scripts/simulate_bad_config.sh
```

## Failure Scenario

The repository includes a failure scenario where the configuration version is changed from:

```yaml
version: "7.2"
```

to:

```yaml
version: "7.3"
```

The pre-deployment governance gate rejects the candidate before deployment because only version `7.2` is approved. The previously approved target state remains unchanged.

Evidence:

```text
examples/bad-config-failure.log
```

## Production Scenario

This is a sandboxed implementation of a production control pattern.

In a real environment, this pattern could be used to validate:

- application configuration versions
- release configuration
- environment-specific settings
- feature flag state
- approved deployment metadata
- service ownership metadata

## AI-Assisted Review Direction

The next extension is AI-assisted configuration review.

The AI layer should not approve or deploy changes automatically.

It should help summarize:

- what changed
- risk level
- possible production impact
- required validation checks
- rollback considerations
- whether human approval is required

## Key Principle

Automation should not only move changes forward.

It should stop unsafe changes before they become accepted state.
