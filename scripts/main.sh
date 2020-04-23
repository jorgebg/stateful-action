#/bin/bash -e
# Checkout $INPUT_BRANCH branch under .$INPUT_BRANCH

if ! git config --get-regexp user.
then
  git config user.email "$INPUT_GIT_AUTHOR_EMAIL"
  git config user.name "$INPUT_GIT_AUTHOR_NAME"
fi

if ! grep -Fxq ".$INPUT_BRANCH/" .gitignore
then
  echo "Please make sure .$INPUT_BRANCH/ is present in .gitignore"
  exit 1
fi


if git fetch origin $INPUT_BRANCH
then
  # $INPUT_BRANCH branch already exists
  git worktree add -b $INPUT_BRANCH ./.$INPUT_BRANCH origin/$INPUT_BRANCH
else
  # $INPUT_BRANCH branch doesn't exist yet
  echo "Creating $INPUT_BRANCH branch..."
  git worktree add --detach .$INPUT_BRANCH/
  cd .$INPUT_BRANCH/
  git checkout --orphan $INPUT_BRANCH
  git reset --hard
  cd ..
fi
