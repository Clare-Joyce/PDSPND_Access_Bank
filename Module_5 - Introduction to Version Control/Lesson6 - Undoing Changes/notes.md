### Undoing changes

- `git commit --amend` modifies the most recent commit. Useful when you forget to add a file in a commit or want to fix typo in the most recent commit message.
- `git revert h3a456` reverses the commit with h3a456 as SHA. Meaning the changes that were made in h3a456 commit are reverted, deleted, undone.
- `git reset` erases commits from the current branch. Commits are erased in order and using this command means deleting items from the repo and hence dangerous.

#### Modifying The Last Commit
- changing the commit message
- adding files you forgot to add in the commit
- `git commit --amend` modifies the last/most recent commit.

#### Reverting a commit
- Undoing what was done in a particular commit
- Find the specified commit, undo the changes that were done in the commit, create a new commit without the changes.

#### Resetting/Erasing Commits
- resetting here is equivalent to erasing.
- resetting is dangerous
- git keeps track of the erased commits for 30 before permanent delete
- to get hold of the erased files within the 30 days, use `git reflog`

- `git reset <reference>` can be used to
    - move the HEAD and current branch pointer to the referenced commit
    - erase commits
    - move committed changes to the staging index
    - unstage committed changes

- git reset has three main flags
- `git reset --mixed SHA` == `git reset SHA`: Moves committed changes to the working directory.
- `git reset --soft SHA`: moves committed changes into the staging area.
- `git reset --hard SHA`: completely erase the committed changes.

#### Good Practice
- Always create a backup branch prior to a reset to merge in case you realize you needed to unstaged, or erased changes.
