# Agent Guidelines

This repo is a cookiecutter template. The generated project lives in
`{{cookiecutter.project_slug}}/`; `hooks/` run at generation time.

## Testing

```bash
scripts/test_cookiecutter.sh  # generate project-alpha from the template, then make setup && make ci
```

Template changes should be exercised by this script (it is what CI runs).

## Pull request workflow

### Opening a PR
- Add or update an automated test that exercises the feature or fix.
- Fill in the PR template's "Post-merge verification" section with concrete
  steps someone could run on a fresh checkout of main: commands, URLs,
  locations to check, and what a pass looks like.
- After opening the PR, subscribe to its activity and fix CI failures.
- Never merge unless I explicitly say to.

### When I say "approved, merge and verify"
1. Merge the PR (enable auto-merge if checks are still running).
2. Wait for the CI run on main for the merge commit. If it fails, say so
   and open a fix PR.
3. Check out main fresh, follow the README setup exactly as written, and
   note any step that doesn't work as documented.
   For this repo that means `uvx cookiecutter --no-input .` followed by
   `make setup && make ci` in the generated project.
4. Run each step in the PR's "Post-merge verification" section.
   Take screenshots where a visual check is needed.
5. Comment the results on the merged PR: what you ran, pass or fail for
   each step, and anything that needs my judgment.
6. If something fails, open a fix PR or issue. Do not edit main directly.
