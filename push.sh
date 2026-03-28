#!/bin/bash
# push.sh — sends the code to GitHub without exposing the token in logs or URLs.
# The token is read from the GITHUB_PERSONAL_ACCESS_TOKEN secret (Replit Secrets).

set -e

REPO_URL="https://github.com/dtenorio921-pixel/Gamekt-pro.08.git"
BRANCH="main"

if [ -z "$GITHUB_PERSONAL_ACCESS_TOKEN" ]; then
    echo "ERROR: GITHUB_PERSONAL_ACCESS_TOKEN secret is not set."
    echo "Add it in: Replit > Secrets tab > New Secret"
    exit 1
fi

# Create a temporary GIT_ASKPASS script so the token is never in the URL or process list.
TMPASK=$(mktemp /tmp/askpass.XXXXXX)
chmod +x "$TMPASK"
printf '#!/bin/sh\necho "$GITHUB_PERSONAL_ACCESS_TOKEN"\n' > "$TMPASK"

echo "Pushing to $REPO_URL (branch: $BRANCH)..."

GIT_ASKPASS="$TMPASK" \
GIT_TERMINAL_PROMPT=0 \
git push "$REPO_URL" "HEAD:$BRANCH" --force

STATUS=$?

rm -f "$TMPASK"

if [ $STATUS -eq 0 ]; then
    echo ""
    echo "Push successful!"
    echo "GitHub Actions: https://github.com/dtenorio921-pixel/Gamekt-pro.08/actions"
else
    echo "Push failed. Check that your token has 'repo' permission and is still valid."
    exit $STATUS
fi
