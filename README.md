# 💽 Stateful Action

This action is an utility for managing the state of your application on a branch reserved for this purpose.

## How it works

It wraps the run like this:

1. `state` branch is checked out as a [worktree](https://git-scm.com/docs/git-worktree) under a folder named `.state` (which must be ignored by `.gitignore`). Please check [`scripts/main.sh`](scripts/main.sh).
2. Your application writes its state into the `.state` folder.
3. Changes in `state` branch are commited and pushed to origin. Please check [`scripts/post.sh`](scripts/post.sh):
    * Changes are commited and pushed.
    * Old commits on `state` branch are squashed and force-pushed.
    * `.state` worktree is removed.



Your application might also commit or push changes at step 2 if needed.


## Requirements

- The repository must reserve a branch for keeping the state. By default its name is `state`. It can be set by the [`branch` input](action.yml).
- A folder with the same name as the state branch prefixed by a dot must be ignored in `.gitignore` ([example](.gitignore)). As the default branch is `state`, the folder ignored by default would be `.state`.
- Repository must be checked out first ([`actions/checkout@v2`](github.com/actions/checkout)).

## Usage

### Example workflow

```
name: Example workflow
on:
  push:
    branches: [master]
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - uses: jorgebg/stateful-action@v0.1
    - name: Test Run
      run: echo $(date)\n >> .state/data.txt
```
Please take a look at the **[example workflow](.github/workflows/example.yml)** running on this repository.


### Inputs

- `branch`: the name of the branch that will store the state. Default: `state`.
- `backup`: number of last commits to keep as a backup. Default: `100`.

- `git_author_name`: author name used for the commits. Default: `Stateful Action Bot`.
- `git_author_email`: author email used for the commits. Default: `stateful-action@example.com`.


## Real-life examples

- [RSS Reader](https://github.com/jorgebg/reader)
- [Air Quality Monitoring Station](https://github.com/jorgebg/airquality)
- Twitter Bot (WIP)


## Testing

### Simple testing

```
node main.js && echo $(date)\n >> .state/data.txt
node post.js
```

### Testing with `act`

The action can be tested locally with [`act`](https://github.com/nektos/act). It requires `git` and `sed`, so use the image `node:12.6-buster` instead of the _slim_ version:

```
act -P ubuntu-latest=node:12.6-buster
```

You'll also need to setup GitHub credentials.

#### Known issues

Here is a workaround I'm using for https://github.com/nektos/act/issues/185:

```
rm -rf action
mkdir action
cp -R action.yml *.js scripts action
sed -i -E 's/uses: .\/$/uses: .\/action/g' .github/workflows/example.yml
```

It copies the local action into `action` folder.
