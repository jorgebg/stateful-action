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
