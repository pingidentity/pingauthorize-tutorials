# CI pipeline

## Overview

This document describes the CI pipeline and highlights some controls that developers may wish to modify.

## Pipeline stages

During development, the CI pipeline has 4 stages. During a production release, it adds an additional stage. The stages
are outlined below.

1. Initialization - Checks that the runner has the available tools to execute the pipeline.
2. Validation - Validates the source code. At the moment, this is linting the Markdown files
   (<https://github.com/markdownlint/markdownlint>) and shell scripts (<https://github.com/koalaman/shellcheck>).
3. Test initial state - Brings up the docker-compose environment and runs smoke tests on it.
4. Cleanup - Performs any necessary cleanup. Right now this does nothing.
5. (Production release only) Publish - pushes the content to GitHub.

Each stage has a corresponding shell script. In addition, the "Test initial state" stage has a directory of drop-in bash
scripts that are sourced into `02-test-initial-state.sh` upon execution.

## Usage

### Running stages locally

To run the stages locally, you must have the necessary tools installed. Those tools are listed in
`00-initialization.sh`.

All of the scripts should be run from the root of the repository.

```bash
pdg-tutorials $ bash .gitlab-ci/00-initialization.sh
```

Be aware that the `02-test-initial-state.sh` script currently modifies the `.env` file at the root of the repository,
which can affect local development/testing. There is likely a way to avoid this, and MRs are welcome.

### Adding unit tests

To add unit tests, the easiest thing to do is to copy an existing unit test into `test-initial-state.d` and modify it
for your purposes. The entrypoint for each test is the bash function `run_test` which takes no parameters and returns
  `0` for success and non-zero for failure. The tests are executed in sorted filename order, and a single test failure
  will prevent further tests from executing.

### Changing linting rules

You may find over time that the Markdown linting rules are too strict. See
<https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md> on the Markdown rules. Some rules have
configurable parameters that are declared in a "style" file. The style file has already been created for this project,
and can be found in `.gitlab-ci/mdl.rb`.

