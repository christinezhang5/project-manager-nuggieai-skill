#!/bin/bash

# PM Installer
# Run this script to install PM on your machine
# Usage: bash install.sh

echo ""
echo "Installing PM..."
echo ""

# Create skills directory
mkdir -p ~/.claude/skills/pm

# Download SKILL.md
curl -s -o ~/.claude/skills/pm/SKILL.md \
  https://raw.githubusercontent.com/christinezhang5/project-manager-nuggieai-skill/main/skills/pm/SKILL.md

# Confirm
if [ -f ~/.claude/skills/pm/SKILL.md ]; then
  echo "✓ PM installed at ~/.claude/skills/pm/SKILL.md"
  echo ""
  echo "Next steps:"
  echo ""
  echo "1. Get your free token at nuggieai.com/dashboard"
  echo ""
  echo "2. Add this line to your project CLAUDE.md:"
  echo "   skill_token: nvsk_free_xxxxxxxxxxxxxxxxxxxx"
  echo ""
  echo "3. In Claude Code say:"
  echo "   pm on"
  echo ""
else
  echo "✗ Installation failed — check your internet connection and try again"
  echo ""
  echo "Manual install:"
  echo "mkdir -p ~/.claude/skills/pm"
  echo "Download SKILL.md from github.com/christinezhang5/project-manager-nuggieai-skill"
  echo "Move it to ~/.claude/skills/pm/SKILL.md"
fi
