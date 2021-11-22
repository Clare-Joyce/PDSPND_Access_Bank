### Staying in Sync wiht a Remote Repo

#### Create a PR
- A pull request is a request to the original or source repository's maintainer to include changes in their project that you made in your fork of their project.
- To create a pull request, a couple of things need to happen:
    - you must fork the source repository
    - clone your fork down to your machine
    - make some commits (ideally on a topic branch!)
    - push the commits back to your fork
    - create a new pull request and choose the branch that has your new commits

- starring the project
- watching the project
- includng upstream changes
- `git remote add upstream <url>` creates a link with the upstream/source/original project
- `git remote rename mine origin`
- `git remote rename source-repo upstream`
- `git fetch upstream master` retrieve upstream changes

#### Sqaush commits
- combining commit into 1
- `git rebase -i HEAD~3` combines the last 3 commits into 1. -i implies interactive mode.
- git sets `HEAD~3` as the new base commit for the combined (HEAD~, HEAD~1, HEAD~2) commit.
- rebasing creates a new commit.

#### Force pushing
After rebasing, git tries to stop you from pushing because you have deleted several commits
- `git push -f`

#### Good Practice
- create a backup branch prior to rebasing
- always use interactive rebasing
- **So you should not rebase if you have already pushed the commits you want to rebase**