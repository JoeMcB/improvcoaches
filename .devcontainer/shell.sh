#!/bin/bash

# Launch a shell in the devcontainer as node in workspace
docker exec -it -u root "improvcoaches_devcontainer-web-1" zsh -l  -c "cd /workspace && zsh"
