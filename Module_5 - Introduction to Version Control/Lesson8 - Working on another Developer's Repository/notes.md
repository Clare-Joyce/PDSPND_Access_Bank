### Working on another developer's repo.

- Forking is making an identical split, make an identical copy and become the owner of the copy.
- Forking is not a Git thing but it is a functionality provided by GitHub, the hosting service.

- You cannot make changes to someone's repo on GitHub
- Hence, you can fork, clone, make changes, commit and push.
- Note that the changes are pushed to your copy of the project.

- `git shortlog` can be used to view commits from different collaborators. It displays names on collaborators in alphabetical order and their commits.
- `git shortlog -s -n`: -s shows the number of commits, -n makes them appear in numerical order.
- `git log --author=Surma` filter commits by author
- `git log --grep "bug"` will find all commits with the word bug.