#!/bin/bash

# PM Vibe Installer
# Run this script to install PM Vibe on your machine
# Usage: bash install.sh

echo ""
echo "Installing PM Vibe..."
echo ""

# Create skills directory
mkdir -p ~/.claude/skills/pm-vibe

# Download SKILL.md
curl -s -o ~/.claude/skills/pm-vibe/SKILL.md \
  https://raw.githubusercontent.com/christinezhang5/pm-vibe/main/SKILL.md

# Confirm
if [ -f ~/.claude/skills/pm-vibe/SKILL.md ]; then
  echo "✓ PM Vibe installed at ~/.claude/skills/pm-vibe/SKILL.md"
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
  echo "mkdir -p ~/.claude/skills/pm-vibe"
  echo "Download SKILL.md from github.com/christinezhang5/pm-vibe"
  echo "Move it to ~/.claude/skills/pm-vibe/SKILL.md"
fi
