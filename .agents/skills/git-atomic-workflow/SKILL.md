---
name: git-atomic-workflow
description: Use when staging files, creating git commits, or managing development feature branches.
---

# Git Atomic Workflow Skill

Follow this workflow for Git management within `nixos-dotfiles`.

## Rules & Protocol

1. **Stage Untracked Files Immediately**:
   - Nix Flakes evaluate strictly tracked files. When creating new `.nix` or dotfile assets in `config/`, immediately run:
     ```bash
     git add <newfile> # or git add .
     ```

2. **Atomic Conventional Commits**:
   - Write clear, concise commit messages using standard prefixes:
     - `feat:` (New module or feature)
     - `fix:` (Bug resolution or syntax fix)
     - `refactor:` (Code structure optimization without behavior change)
     - `style:` (Formatting or dotfile tweaks)

3. **Branching Guideline**:
   - Perform edits affecting >2 files on a feature branch (`git checkout -b feature/<name>`).
