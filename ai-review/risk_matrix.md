# Configuration Risk Matrix

## Low Risk

Examples:

- documentation-only metadata change
- owner label update
- non-runtime annotation update

Expected action:

- automated validation
- no manual approval required unless policy requires it

## Medium Risk

Examples:

- version change
- environment value change
- feature flag modification
- logging level change

Expected action:

- validation required
- human approval recommended

## High Risk

Examples:

- production endpoint change
- authentication setting change
- database connection change
- secret reference change
- rollback setting change
- security control disabled

Expected action:

- validation required
- human approval required
- rollback plan required
- evidence must be captured
