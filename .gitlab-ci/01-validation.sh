#!/bin/bash
set -xeo pipefail

echo "Linting Markdown files..."
mdl --style .gitlab-ci/mdl.rb --git-recurse .
echo "Markdown linting successful."

echo "shellcheck shell scripts..."
find . -type f \( -path server-profiles \) \
  -prune -false -name "*.sh" -exec shellcheck {} \+
echo "shellcheck successful."

exit 0
