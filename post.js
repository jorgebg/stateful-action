const script = `
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

`;
const exec = require('child_process').exec;

process.env.INPUT_BRANCH = process.env.INPUT_BRANCH || 'state';
process.env.INPUT_BACKUP = process.env.INPUT_BACKUP || 'backup';

const run = exec(`bash -e <<'EOF'\n${script}\nEOF`, (error, stdout, stderr) => {
    if (error) {
        console.error(`exec error: ${error}`);
        process.exit(error.code);
    }
});
run.stdout.on('data', (data) => {
    console.log(data);
});
run.stderr.on('data', (data) => {
    console.error(data);
});
