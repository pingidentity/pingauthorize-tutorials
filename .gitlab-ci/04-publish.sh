#!/bin/bash
set -euo pipefail

echo "Pushing to GitHub..."
git remote add github ssh://git@github.com/pingidentity/pdg-tutorial.git
git fetch github
git checkout github/"$CI_COMMIT_BRANCH" \
  || git checkout -b github/"$CI_COMMIT_BRANCH"
git pull --rebase "$CI_COMMIT_BRANCH" && git push
git push github "$CI_COMMIT_TAG"
exit 0
