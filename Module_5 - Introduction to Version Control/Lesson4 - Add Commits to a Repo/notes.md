### Add commits to a Repo

- `git add` adds (takes) files in the working directory to the staging index.
- `git commit` takes files from the staging index and save them in the repository.
- `git diff` is equivalent to `git log -p` and displays the difference between two versions of a file. It used to see changes that
have been made but have not been committed.

- we have some new files that we want Git to start tracking
- for Git to track a file, it needs to be committed to the repository
- for a file to be committed, it needs to be in the Staging Index

*NOTE:* `git rm --cached` will not destroy any of your work; it just removes it from the Staging Index.

- `git add .` the period is used as a shortcut to refer to all files and folders in the working directory.
- `git commit -m "Initial commit"`

The goal is that each commit has a single focus. Each commit should record a single-unit change. Each commit should make a change to just one aspect of the project. Work on one change first, commit that, and then change the second one.

- `git log -p` uses `git diff` under the hood.

#### What makes a good commit message?
Do

- do keep the message short (less than 60-ish characters)
- do explain what the commit does (not how or why!)
- be consistent in how you write your commit messages

#### Having Git Ignore Files
- globbing
- The git ignore file prevents files from being accidentally staged or committed.
- tells git what files it should not track.