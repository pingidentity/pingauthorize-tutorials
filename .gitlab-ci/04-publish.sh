#!/bin/bash
set -euo pipefail

# Push the tag, version branch and main to GitHub.
echo "Pushing to GitHub..."
git remote add github \
  "https://${PDG_CI_GITHUB_USER}:${PDG_CI_GITHUB_ACCESS_TOKEN}@github.com/${PDG_CI_GITHUB_REPO}.git" \
  >/dev/null 2>&1 || echo "github remote already exists. Skipping add."

# First determine the branch from the tag name (by convention, this is the segment of the tag before the first hyphen).
_branch=$(echo "$CI_COMMIT_TAG" | cut -d'-' -f1)

# Fetch the branches from GitLab (CI only fetches the tag). Complain if the version branch does not exist.
if ! git fetch origin "$_branch"; then
  echo "Attempting to publish tag '$CI_COMMIT_TAG' without branch '$_branch'. Please create '$_branch' before publishing tags."
  exit 1
fi
git fetch origin main

# Push the tag and each branch
git push github "$CI_COMMIT_TAG"

git checkout "$_branch" && \
  git push github "$_branch" && \
  echo "Pushed branch $_branch to $PDG_CI_GITHUB_REPO."

git checkout main && \
  git push github main && \
  echo "Pushed main to $PDG_CI_GITHUB_REPO."

exit 0
