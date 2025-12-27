# Getting Things Done (GTD) Integration

> Workflow automation for GTD methodology across multiple platforms.

---

## Overview

These dotfiles support GTD workflows with:
- **macOS Native Apps** (Reminders, Notes, Calendar)
- **Google Workspace** (Keep, Tasks, Calendar, Gmail)
- **Microsoft 365** (To Do, OneNote, Outlook)
- **OmniFocus** (Premium GTD app)

---

## Core GTD Functions

### Capture

```bash
gtd-capture "Call John about project"    # Quick capture to inbox
```

### Weekly Review

```bash
gtd-review                                # Start weekly review template
```

### Next Actions

```bash
gtd-next                                  # List next actions
gtd-next @phone                           # Filter by context
```

### Projects

```bash
gtd-new-project "Website Redesign"        # Create project template
```

---

## macOS Native Integration

### Reminders

```bash
reminders-add "Buy milk" "Shopping"       # Add to Shopping list
reminders-list                            # Show all tasks
reminders-complete 1                      # Complete task #1
reminders-lists                           # Show all lists
```

### Notes

```bash
notes-new "Meeting Notes" "Work"          # Create note in Work folder
notes-list                                # List all notes
notes-open "Meeting Notes"                # Open specific note
```

### Calendar

```bash
calendar-create "Team Standup" "2025-01-02 10:00"
calendar-today                            # Show today's events
```

---

## Google Workspace

### Quick Access

```bash
gkeep-open                                # Open Google Keep
gtasks-open                               # Open Google Tasks
gcal-open                                 # Open Google Calendar
gmail-open                                # Open Gmail
```

### GTD Workflow

```bash
ggoog-gtd-capture "Review proposal"       # Capture to Keep
ggoog-gtd-project "Q1 Planning"           # Create project in Docs
ggoog-gtd-review                          # Weekly review template
ggoog-gtd-dashboard                       # Open all GTD components
```

---

## Microsoft 365

### Quick Access

```bash
mstodo-open                               # Open Microsoft To Do
mstodo-myday                              # Open My Day view
msonenote-open                            # Open OneNote
msoutlook-open                            # Open Outlook
```

### GTD Workflow

```bash
ms-gtd-capture "Prepare presentation"     # Capture to To Do
ms-gtd-project "Product Launch"           # Create in OneNote
ms-gtd-review                             # Weekly review
ms-gtd-dashboard                          # Open all components
```

---

## OmniFocus Integration

### Tasks

```bash
of-add "Call accountant" "Tax prep" "2025-04-15"
of-add-to-project "Tax Prep" "Gather receipts"
of-complete "Call accountant"
```

### Projects

```bash
of-projects                               # List projects
of-tasks "Home Renovation"                # List tasks in project
of-new-project "Vacation Planning"        # Create project
```

### Views

```bash
of-today                                  # Tasks due today
of-search "meeting"                       # Search tasks
of-folders                                # List folders
```

### Templates

```bash
of-templates                              # List templates
of-template "Weekly Review"               # Create template
of-apply-template "Weekly Review" "Week 1 Review"
```

### Weekly Review

```bash
of-weekly-review                          # Start GTD weekly review
of-process-inbox                          # Process inbox items
```

---

## Configuration

Customize GTD integration in `~/.config/chezmoi/chezmoi.toml`:

```toml
[data.preferences]
    # macOS integration
    notes_folder = "GTD"              # Default Notes folder
    meeting_folder = "Meetings"       # Meeting notes folder
    reminders_list = "Next Actions"   # Default Reminders list

    # GTD folders
    gtd_inbox_folder = "GTD/Inbox"
    gtd_projects_folder = "GTD/Projects"
```

---

## Tips

### Quick Capture Habit

Bind `gtd-capture` to a keyboard shortcut for instant capture:

```bash
# In your terminal, press a key combo to run:
gtd-capture "$(pbpaste)"    # Capture clipboard contents
```

### Morning Routine

```bash
gtd-next                    # Review next actions
calendar-today              # Check today's schedule
```

### End of Day

```bash
gtd-capture "Tomorrow: Review project status"
```
