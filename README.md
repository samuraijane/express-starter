# Express Starter

Express Starter is intended to be used in conjunction with React Starter where both the server directory (express) and the client directory (react) are siblings.
```
some-project/
|-- client-dir/
`-- server-dir/
```
The folder in which these two live is not under version control. However, its children each belong to a separate repository so that version control for both is achieved but independent of the other.

## It's all about the build
This structure aims to simplify the build process prior to deployment by executing it enitrely on your local machine. As such, this setup is not recommended for teams. It is ideal for developers working solo because it removes the complexity of debugging issues that come with running a build on an external server. Builds are initiated localy by the server and, when executed, build files are created on the client and then immediately moved to the server. From there, they are pushed to production. If client and server are not siblings, the builds will fail. Furthermore, you must specify the name of the client directory in the server's **package.json** where the scripts `build:dev` and `build:prod` are defined.

## Branching strategy (WIP)
There are two branches – `main` and `prod`.

### Branch main
- remote points to GitHub
- ignores everything in **build/**

### Branch prod
- remote points to Heroku
- includes everything in **build/** when pushed to Heroku
- never push `prod` to GitHub
- commits should be limited to the latest build files only; it would be highly unusual to make a commit to `prod` that you would not make to `main` first
- never merge code from `main` to `prod`; instead use `git rebase main` when on `prod`
