### Tagging, Branching and Merging
- `git tag` Adds tags to specific commits, extra labels that can indicate useful info about the commit.
- `git branch` Creates branches that allow you develop different features in parallel without confusion.
- `git checkout` Used to switch between different branches and different tags.
- `git merge` Combines changes and features from different branches.

#### Tagging
A tag stays locked to a commit even with the addition of more commits.
- `git tag -a v1.0`: The `-a` indicates an annotated tag. The command adds a tag called v1.0 to the most recent commit.
- `git tag v1.0`: This tag is not annotated. It is call a `lightweight tag`.

Annotated tags are recommended because they contain more info.
- the person who made the tag
- the date the tag was made
- a message for the tag

- `git tag` displays all tags in a repo.
- `git log --decorate` shows more details about commits. It produces the same output as `git log`  with an updated git.
- `git tag -d v1.0` or `git tag --delete v1.0` is used to delete the tag.
- `git tag -a v1.0 a87984` adds a tag to a past commit.

#### Branching
- Tags stay locked to a commit, a permanent pointer to a commit but a branch moves each time a commit is added.
- `git branch sidebar` creates a new branch all sidebar.
- `git checkout sidebar` switches from the currently active branch to the sidebar branch.
- `git branch sidebar af780cd` creates a new branch called sidebar from commit af780cd.
- `git branch -d sidebar` deletes a branch called sidebar. Note that you cannot delete an actice branch. Git will not also permit you to delete a branch with commits that not found in another branch.
- `git branch -b sidebar` will create a branch called sidebar and automatically switch to the sidebar branch.
- `git checkout -b footer master` creates a new branch called footer from the master branch and automatically switch to the footer branch.
- `git branch -D sidebar` is used to forcefully delete a branch.

-  `git checkout`
    - remove all files and directories from the Working Directory that Git is tracking
    - go into the repository and pull out all of the files and directories of the commit that the branch points to.
- `git log --oneline --decorate` to see info about branches in `git log`.
- `git log --oneline --decorate --graph --all` shows the branching process and the associated commits.

#### Merging
- Combining branches (features from different branches).
- There are two types of merging
    - regular merge: merge two divergent branches.
    - fast-forward merge: A Fast-forward merge will just move the currently checked out branch forward until it points to the same commit that the other branch
- when merge happens, it creates a commit.
- When a merge happens, Git will:
    - look at the branches that it's going to merge
    - look back along the branch's history to find a single commit that both branches have in their commit history
    - combine the lines of code that were changed on the separate branches together
    - makes a commit to record the merge
- In merging, you are merging changes from a different branch into the current/active branch.


#### Merge Conflicts
- a conflict occurs when merging two branches that have had the same lines of code changed in the separate branches.
- To resolve the conflict in a file:
    - locate and remove all lines with merge conflict indicators
    - determine what to keep
    - save the file(s)
    - stage the file(s)
    - make a commit