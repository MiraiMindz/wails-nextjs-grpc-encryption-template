#!/usr/bin/env bash

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    printf "%s\n" "GitHub CLI (gh) not installed, please install it"
    exit 1
fi

# Move up one directory if the script is executed from a "scripts" folder
if [[ "$(basename "$(pwd)")" == "scripts" ]]; then
    cd ..
fi

shopt -s dotglob

# Configuration
USERNAME=$(gh api user --jq '.login')
REPOVISIBILITY=--private
BASEPROJECTNAME="{{.ProjectName}}"
PROJECTNAME="$(echo "$BASEPROJECTNAME" | sed 's/ /_/g')"
PROJECTREPO="${USERNAME}/${PROJECTNAME}"
BACKENDREPO="${USERNAME}/${PROJECTNAME}_Backend"
FRONTENDREPO="${USERNAME}/${PROJECTNAME}_Frontend"
SERVERREPO="${USERNAME}/${PROJECTNAME}_Server"

PROJECTFOLDER="$(pwd)"
BACKENDFOLDER="${PROJECTFOLDER}/backend"
FRONTFOLDER="${PROJECTFOLDER}/frontend"
SERVERFOLDER="${PROJECTFOLDER}/server"

printf "%s\n\n" "INITIALIZING GIT SUBMODULES"

# Determine if the project should be public
read -p "Is your project public [y/n]? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    REPOVISIBILITY=--public
fi
printf "\n"

# Create GitHub repositories
gh repo create "${PROJECTREPO}" $REPOVISIBILITY --confirm
gh repo create "${BACKENDREPO}" $REPOVISIBILITY --confirm
gh repo create "${FRONTENDREPO}" $REPOVISIBILITY --confirm
gh repo create "${SERVERREPO}" $REPOVISIBILITY --confirm

# Initialize and push submodule repositories
for repo in "$BACKENDFOLDER" "$FRONTFOLDER" "$SERVERFOLDER"; do
    cd "$repo"
    git init
    if [[ "$repo" == "$FRONTFOLDER" && ! -e .gitignore ]]; then
        # Add a default .gitignore for frontend
        touch .gitignore
        printf "# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.\n\n# dependencies\n/node_modules\n/.pnp\n.pnp.js\n.yarn/install-state.gz\n\n# testing\n/coverage\n\n# next.js\n/.next/\n/out/\n\n# production\n/build\n\n# misc\n.DS_Store\n*.pem\n\n# debug\nnpm-debug.log*\nyarn-debug.log*\nyarn-error.log*\n\n# local env files\n.env*.local\n\n# vercel\n.vercel\n\n# typescript\n*.tsbuildinfo\nnext-env.d.ts\n\n" >> .gitignore
    fi
    REPO_NAME=$(basename "$repo")
    git remote add origin "https://github.com/${USERNAME}/${PROJECTNAME}_${REPO_NAME}.git"
    git add .
    git commit -m "Initial commit for ${REPO_NAME}"
    git branch -M main
    git push -u origin main
done

# Move existing folders temporarily
cd "$PROJECTFOLDER"
mkdir -p tmp
mv backend tmp/Backend_temp
mv frontend tmp/Frontend_temp
mv server tmp/Server_temp
rm -rfv tmp/Backend_temp/.git
rm -rfv tmp/Frontend_temp/.git
rm -rfv tmp/Server_temp/.git

# Initialize main repository and add submodules
git init
git remote add origin "https://github.com/${PROJECTREPO}.git"
git submodule add "https://github.com/${BACKENDREPO}.git" backend
git submodule add "https://github.com/${FRONTENDREPO}.git" frontend
git submodule add "https://github.com/${SERVERREPO}.git" server

# Copy back content to submodule directories and commit changes
cp -r tmp/Backend_temp/* backend/
cp -r tmp/Frontend_temp/* frontend/
cp -r tmp/Server_temp/* server/
rm -rf tmp

for repo in "$BACKENDFOLDER" "$FRONTFOLDER" "$SERVERFOLDER"; do
    cd "$repo"
    git add .
    git commit -m "Adding existing code for $(basename "$repo")"
    git push origin main
done

# Commit and push changes to the main repository
cd "$PROJECTFOLDER"
git add .
git commit -m "Add Backend, Frontend, and Server as submodules"
git push -u origin main

printf "\n%s\n" "DONE"
