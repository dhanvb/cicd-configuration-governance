# Failure Scenarios

## Scenario 1: Unapproved Configuration Version

### Situation

A configuration file with version `7.3` was introduced into the deployment workflow while the approved version was `7.2`.

### Expected Behavior

The pre-deployment governance gate must reject version 7.3 before
the candidate configuration is copied to the target system.

The previously approved deployed configuration must remain unchanged.

### Control

The pre-deployment validation playbook compares the candidate
configuration version with policy/approved-release.yml.

If the candidate does not match the approved version, the pipeline
terminates before deployment.

### Evidence

See:

- `examples/bad-config-failure.log`

### Operational Lesson

A deployment pipeline should not only verify that files were copied. It should verify that the deployed configuration matches the approved release policy.

Successful deployment does not always mean safe deployment.
