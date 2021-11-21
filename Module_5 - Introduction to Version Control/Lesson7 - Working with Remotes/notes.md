### Working with Remotes 

- collaboration
- `git remote` to manage and control the remote repo
- `git push` to send local changes to the remote repo
- `git pull` to pull pull remote changes into the local repo

- `git remote -v`  returns full path to the remote repo.
- `git remote add origin <url>` links a local repo to a remote repo.

- `git pull origin master` pulls and automatically merge changes from the remote master branch into the active local branch.
- `git fetch` pulls the changes into the tracking branch but the changes are not automatically merged to the local branch.
- `git fecth` + `git merge` = `git pull`
- `git pull` will fail if both the local and remote repos/branches have different commits. In this case, you can `fatch` and `merge`.
- `git fetch origin master` 


- When git pull is run, the following things happen:
    - the commit(s) on the remote branch are copied to the local repository
    - the local tracking branch (origin/master) is moved to point to the most recent commit
    - the local tracking branch (origin/master) is merged into the local branch (master)

#### Good Practice
- Create branches with descriptive names.
- Work locally and push changes to the remote repo.
- Note that `origin` is a defacto name for the main remote repo.
- Note: `origin/master` is a `tracking branch`
