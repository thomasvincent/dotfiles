# Contributing to Dotfiles

Thank you for considering contributing to this dotfiles repository! This document outlines the guidelines for contributing to this project.

## Table of Contents

- [Contributing to Dotfiles](#contributing-to-dotfiles)
  - [Table of Contents](#table-of-contents)
  - [Code of Conduct](#code-of-conduct)
  - [How Can I Contribute?](#how-can-i-contribute)
    - [Reporting Bugs](#reporting-bugs)
    - [Suggesting Enhancements](#suggesting-enhancements)
    - [Pull Requests](#pull-requests)
  - [Style Guides](#style-guides)
    - [Git Commit Messages](#git-commit-messages)
    - [Shell Scripting Style Guide](#shell-scripting-style-guide)
    - [Markdown Style Guide](#markdown-style-guide)
  - [Additional Notes](#additional-notes)
    - [Issue and Pull Request Labels](#issue-and-pull-request-labels)

## Code of Conduct

This project and everyone participating in it is governed by the [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

**Before Submitting A Bug Report:**

- Check the [issues](https://github.com/thomasvincent/dotfiles/issues) for a list of current known issues.
- Perform a [search](https://github.com/thomasvincent/dotfiles/issues) to see if the problem has already been reported. If it has and the issue is still open, add a comment to the existing issue instead of opening a new one.

**How Do I Submit A (Good) Bug Report?**

Bugs are tracked as [GitHub issues](https://github.com/thomasvincent/dotfiles/issues). Create an issue and provide the following information:

- **Use a clear and descriptive title** for the issue to identify the problem.
- **Describe the exact steps which reproduce the problem** in as many details as possible.
- **Provide specific examples to demonstrate the steps**. Include links to files or GitHub projects, or copy/pasteable snippets, which you use in those examples.
- **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
- **Explain which behavior you expected to see instead and why.**
- **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem.
- **If the problem wasn't triggered by a specific action**, describe what you were doing before the problem happened and share more information using the guidelines below.

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion, including completely new features and minor improvements to existing functionality.

**Before Submitting An Enhancement Suggestion:**

- Check if the enhancement has already been suggested or implemented.
- Determine which repository the enhancement should be suggested in.
- Perform a [search](https://github.com/thomasvincent/dotfiles/issues) to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.

**How Do I Submit A (Good) Enhancement Suggestion?**

Enhancement suggestions are tracked as [GitHub issues](https://github.com/thomasvincent/dotfiles/issues). Create an issue and provide the following information:

- **Use a clear and descriptive title** for the issue to identify the suggestion.
- **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
- **Provide specific examples to demonstrate the steps**. Include copy/pasteable snippets which you use in those examples, as Markdown code blocks.
- **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
- **Include screenshots and animated GIFs** which help you demonstrate the steps or point out the part of the dotfiles which the suggestion is related to.
- **Explain why this enhancement would be useful** to most dotfiles users.
- **List some other dotfiles repositories or applications where this enhancement exists.**
- **Specify which version of the dotfiles you're using.**
- **Specify the name and version of the OS you're using.**

### Pull Requests

The process described here has several goals:

- Maintain the quality of the dotfiles
- Fix problems that are important to users
- Engage the community in working toward the best possible dotfiles
- Enable a sustainable system for the dotfiles' maintainers to review contributions

Please follow these steps to have your contribution considered by the maintainers:

1. Follow all instructions in [the template](PULL_REQUEST_TEMPLATE.md)
2. Follow the [style guides](#style-guides)
3. After you submit your pull request, verify that all [status checks](https://help.github.com/articles/about-status-checks/) are passing

While the prerequisites above must be satisfied prior to having your pull request reviewed, the reviewer(s) may ask you to complete additional design work, tests, or other changes before your pull request can be ultimately accepted.

## Style Guides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line
* Consider starting the commit message with an applicable emoji:
    * 🎨 `:art:` when improving the format/structure of the code
    * 🐎 `:racehorse:` when improving performance
    * 🚱 `:non-potable_water:` when plugging memory leaks
    * 📝 `:memo:` when writing docs
    * 🐧 `:penguin:` when fixing something on Linux
    * 🍎 `:apple:` when fixing something on macOS
    * 🏁 `:checkered_flag:` when fixing something on Windows
    * 🐛 `:bug:` when fixing a bug
    * 🔥 `:fire:` when removing code or files
    * 💚 `:green_heart:` when fixing the CI build
    * ✅ `:white_check_mark:` when adding tests
    * 🔒 `:lock:` when dealing with security
    * ⬆️ `:arrow_up:` when upgrading dependencies
    * ⬇️ `:arrow_down:` when downgrading dependencies
    * 👕 `:shirt:` when removing linter warnings

### Shell Scripting Style Guide

* Use 2 spaces for indentation
* Use `#!/usr/bin/env bash` for bash scripts
* Use `#!/usr/bin/env zsh` for zsh scripts
* Use `#!/usr/bin/env sh` for POSIX shell scripts
* Use `set -e` to exit on error
* Use `set -u` to exit on undefined variables
* Use `set -o pipefail` to exit on pipe failures
* Use `shellcheck` to lint your shell scripts
* Use double quotes for strings with variables
* Use single quotes for strings without variables
* Use `$()` instead of backticks
* Use `[[ ]]` instead of `[ ]` for conditionals
* Use `#!/usr/bin/env python3` for Python scripts
* Use `#!/usr/bin/env ruby` for Ruby scripts
* Use `#!/usr/bin/env node` for Node.js scripts
* Use `#!/usr/bin/env php` for PHP scripts

### Markdown Style Guide

* Use ATX-style headers (`# H1`, `## H2`, etc.)
* Use hyphens (`-`) for unordered lists
* Use numbers (`1.`, `2.`, etc.) for ordered lists
* Use backticks (`` ` ``) for inline code
* Use triple backticks (`` ``` ``) for code blocks
* Use language identifiers for code blocks (e.g., `` ```bash ``)
* Use reference-style links (`[link text][reference]`) for multiple occurrences of the same link
* Use inline links (`[link text](URL)`) for single occurrences of a link
* Use emphasis (`*italic*` or `_italic_`) and strong emphasis (`**bold**` or `__bold__`) sparingly
* Use tables for tabular data
* Use horizontal rules (`---`) to separate sections

## Additional Notes

### Issue and Pull Request Labels

This section lists the labels we use to help us track and manage issues and pull requests.

* `bug` - Issues that are bugs
* `documentation` - Issues that are related to documentation
* `duplicate` - Issues that are duplicates of other issues
* `enhancement` - Issues that are feature requests
* `good first issue` - Issues that are good for newcomers
* `help wanted` - Issues that need help from the community
* `invalid` - Issues that are invalid or not relevant
* `question` - Issues that are questions
* `wontfix` - Issues that won't be fixed

Thank you for contributing to the dotfiles repository!
