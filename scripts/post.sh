#/bin/bash -e
# Commit changes on $INPUT_BRANCH branch and squash old commits

cd .$INPUT_BRANCH/

git add .

if ! git commit -m "$INPUT_BRANCH update"
then
  echo "$INPUT_BRANCH didn't change"
else
  # Push new commit
  git push origin $INPUT_BRANCH

  # Squash all the commits except last $INPUT_BACKUP
  export N=$(($(git rev-list --count $INPUT_BRANCH --) - $INPUT_BACKUP))
  if (( $N > 0 ))
  then
    echo "Squashing $N commits"
    EDITOR="sed -i '2,$N s/^pick/fixup/'" git rebase -i --root $INPUT_BRANCH
    git push -f origin $INPUT_BRANCH
  fi
fi

# Cleanup
cd ..
git worktree remove .$INPUT_BRANCH
git branch -D $INPUT_BRANCH

