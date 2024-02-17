# Express Starter

WIP...

## File Structure
- The server files and its subdirectories must have a separate parent directory than the client files and its subdirectories
- However, each of these parent directories should be siblings to each other
- Furthermore, each must be configured with its own repository for version control
- For the build scripts to work as expected, you must specify the name of the client directory in **package.json** where the scripts `build:dev` and `build:prod` are defined

## Branches
- `main` is under version control but `prod` is not
- This is because `main` ignores **build/** while `prod` does not
- Never push `prod` to GitHub
- The only commits directly allowed on `prod` are ones to commit the files and subdirectories in **build/**
- Do not merge code from `main` to `prod`, instead use `git rebase main` when on `prod`
