# Production Scenario

## Scenario

A platform team manages application configuration through a Git-backed repository.

Before a deployment is accepted, the deployed configuration must match the approved release version.

## Risk

A pipeline can complete successfully while deploying an unapproved configuration.

This may happen because of:

- incorrect branch
- wrong config file
- manual change
- stale artifact
- unreviewed configuration update
- environment mismatch

## Control Objective

The deployment workflow must verify that the deployed configuration version matches the approved version.

## Implementation

This repository implements the control using:

- Git-backed configuration file
- Ansible deployment playbook
- Ansible validation playbook
- failure scenario simulation
- evidence logs

## Expected Behavior

| Condition | Expected Result |
|---|---|
| deployed version matches approved version | deployment accepted |
| deployed version does not match approved version | validation fails |
| validation fails | deployment is not considered accepted |

## Operational Lesson

Deployment success is not the same as release safety.

A deployment workflow should prove the target system is running the expected approved state.
