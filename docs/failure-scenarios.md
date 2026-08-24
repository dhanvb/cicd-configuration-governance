# Failure Scenarios

## Scenario 1: Unapproved Configuration Version

### Situation

A configuration file with version `7.3` was introduced into the deployment workflow while the approved version was `7.2`.

### Expected Behavior

The deployment workflow may copy the file, but the validation gate must fail before the deployment is accepted.

### Control

The Ansible validation playbook checks the deployed configuration version against the approved version.

### Evidence

See:

- `examples/day6-bad-config-failure.log`

### Operational Lesson

A deployment pipeline should not only verify that files were copied. It should verify that the deployed configuration matches the approved release policy.

Successful deployment does not always mean safe deployment.
