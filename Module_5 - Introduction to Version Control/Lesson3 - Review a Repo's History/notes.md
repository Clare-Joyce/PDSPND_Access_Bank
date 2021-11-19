### Review a Repo's History

- `git log` - display info about existing commits
- `git show` - displays info about a given commit.

*Note:* You should always run the git status command. Especially when returning to a project after a period of time.

- to scroll down by a line, use j or ↓
- to scroll up by a line, use k or ↑
- to scroll down by a page, use the spacebar or the Page Down button
- to scroll up by a page, use b or the Page Up button
- to quit, use q


### Changing How Git Log Displays Information
- `git log --oneline` displays the short SHA and the commit message.
    - lists one commit per line
    - shows the first 7 characters of the commit's SHA
    - shows the commit's message

### Viewing Modified Files
- `git log --stat` displays the files that chnaged in a commit and the numbre of lines that were added or deleted.
    - displays the file(s) that have been modified
    - displays the number of lines that have been added/removed
    - displays a summary line with the total number of modified files and lines that have been added/removed

### Viewing File Changes
- `git log -p` shows the difference between the original version of the file and the changed version of the file.
    - displays the files that have been modified
    - displays the location of the lines that have been added/removed
    - displays the actual changes that have been made

*Note* A diff and a patch(p) refer to the same thing.
`git log -p --stat` or `git log --stat -p` displays the stat info above the patch info
`-p` is equivqlent to `--patch`.

### Viewing A Specific Commit
- `git log fdf5493`
- `git show` displays the most recent commit.
- `git show fdf5493` displays only one commit, fdf5493.
    - the commit
    - the author
    - the date
    - the commit message
    - the patch information

By supplying a SHA, the `git log -p fdf5493` command will start at that commit. It also shows commits prior to fdf5493

- `git show --stat fdf5493`
- `git show -p fdf5493`
- `git show -p --stat fdf5493`