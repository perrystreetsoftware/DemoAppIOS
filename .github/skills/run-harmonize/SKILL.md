---
name: run-harmonize
description: Runs Harmonize architectural lint rules and guides fixing violations. Use after implementing code to verify it follows the project's architectural conventions.
---

You are running Harmonize, a set of architectural lint rules that enforce coding conventions across the codebase. These rules are implemented as Quick spec tests in `Packages/LintRules/Tests/LintRulesTests/`.

## How to Run

Use the helper script to run rules and get filtered output (only failures are shown). The script builds the LintRules test bundle and runs it **from the repository root** — this matters because Harmonize resolves the `.harmonize.yaml` excludes against the process working directory:

```bash
# Run ALL lint rules
bash .github/skills/run-harmonize/run-harmonize.sh

# Run a specific rule
bash .github/skills/run-harmonize/run-harmonize.sh DoNotUseCancellablesInLogic

# Run multiple specific rules
bash .github/skills/run-harmonize/run-harmonize.sh DoNotUseCancellablesInLogic DoNotImportSwiftUIInViewModels
```

The rule name matches the Swift class name of the test (e.g., `DoNotUseCancellablesInLogic`).

**Important:** Always use the helper script instead of calling `xcodebuild` or `swift test` directly. It filters thousands of lines of build logs down to only actionable failure information, and it guarantees the correct working directory. Running `swift test` from inside `Packages/LintRules` silently breaks the source scan (every file appears to be under `LintRules` and gets excluded).

## Long-Running Reliability

For long-running commands, use consistent execution behavior.

1. Run the helper script in a blocking terminal call and wait until it exits.
2. Use terminal `sync` mode with `timeout=0` for end-to-end execution.
3. Do not use repeated `ps` checks to track progress.
4. Use the final script summary and exit code as the source of truth.
5. Do not append trailing shell probes like `; echo $?` or `; echo EXIT_CODE:$?` when running `run-harmonize.sh`.
6. Do not rerun Harmonize if the previous invocation already has a known terminal exit code.
7. If output looks truncated but the terminal reports an exit code, trust that exit code and report it instead of running the command again.

## Interpreting Results

- **All rules pass:** The script prints a summary and "HARMONIZE LINT RULES PASSED"
- **Rules fail:** The script prints each failing rule name and its violation message.
- **Build failure:** If the code doesn't compile, the script prints build errors instead of test results. Fix compilation errors first, then re-run.
- **Stale baseline:** A failure containing "Stale baseline" means a baselined element no longer violates the rule (or no longer exists). Remove that entry from the rule's `baseline` array — do not touch production code.

## Fixing Violations

For each failing rule:

1. **Read the rule's test file** to understand what it enforces. All rules are located at:
   ```
   Packages/LintRules/Tests/LintRulesTests/<category>/<RuleName>.swift
   ```

2. **Read the rule's message carefully** — it explains the architectural reasoning and how to fix the violation. Rules use `LintRuleMessage` (a struct with structured fields: `rule`, `why`, `howToFix`, `badExample`, `goodExample`). The violation output shows all these fields formatted with `RULE:`, `WHY:`, `HOW TO FIX:`, `❌ BAD:`, and `✅ GOOD:` sections. Read and follow the `howToFix` guidance and use the `goodExample` as the target pattern. The message contains the architectural reasoning for WHY the rule exists — understanding this reasoning is essential to applying a correct fix.

3. **Fix the violation in production code**, not in the test file. The error output references which file or class is violating the rule.

4. **Re-run just that rule** to verify the fix:
   ```bash
   bash .github/skills/run-harmonize/run-harmonize.sh <RuleName>
   ```
