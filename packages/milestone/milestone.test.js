/**
 * Unit test suite for milestone CLI
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');
const assert = require('assert');

const BIN = path.resolve(__dirname, '../bin/milestone');

function stripAnsi(str) {
  return str.replace(/\x1b\[[0-9;]*m/g, '');
}

function run(cmd, cwd) {
  const out = execSync(`node "${BIN}" ${cmd}`, { cwd, encoding: 'utf8' });
  return stripAnsi(out);
}

console.log('--- Running Milestone CLI Unit Tests ---');

// Setup temp workspace
const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'milestone-test-'));

try {
  // Test 1: Set milestone
  console.log('• Test 1: Set active milestone');
  const setOut = run('set "M1: Test Milestone"', tmpDir);
  assert(setOut.includes('Active milestone set to: M1: Test Milestone'), 'Set output missing title');
  const json1 = JSON.parse(fs.readFileSync(path.join(tmpDir, '.milestones.json'), 'utf8'));
  assert.strictEqual(json1.milestone, 'M1: Test Milestone');
  assert.strictEqual(json1.progress, '0/0');
  assert.strictEqual(json1.status, 'in_progress');

  // Test 2: Add task
  console.log('• Test 2: Add tasks and verify progress calculation');
  run('task add "First task"', tmpDir);
  run('task add "Second task"', tmpDir);
  const json2 = JSON.parse(fs.readFileSync(path.join(tmpDir, '.milestones.json'), 'utf8'));
  assert.strictEqual(json2.tasks.length, 2);
  assert.strictEqual(json2.progress, '0/2');
  assert.strictEqual(json2.tasks[0].status, 'pending');
  assert.strictEqual(json2.tasks[1].status, 'pending');

  // Test 3: Start task
  console.log('• Test 3: Start task and update focus');
  run('task start 1', tmpDir);
  const json3 = JSON.parse(fs.readFileSync(path.join(tmpDir, '.milestones.json'), 'utf8'));
  assert.strictEqual(json3.tasks[0].status, 'in_progress');
  assert.strictEqual(json3.current_focus, 'First task');

  // Test 4: Complete task
  console.log('• Test 4: Complete task and verify auto-advance focus');
  run('task done 1', tmpDir);
  const json4 = JSON.parse(fs.readFileSync(path.join(tmpDir, '.milestones.json'), 'utf8'));
  assert.strictEqual(json4.tasks[0].status, 'completed');
  assert.strictEqual(json4.progress, '1/2');
  assert.strictEqual(json4.current_focus, 'Second task'); // advanced to next pending task

  // Test 5: Manual focus override
  console.log('• Test 5: Manual focus override');
  run('focus "Custom focus topic"', tmpDir);
  const json5 = JSON.parse(fs.readFileSync(path.join(tmpDir, '.milestones.json'), 'utf8'));
  assert.strictEqual(json5.current_focus, 'Custom focus topic');

  // Test 6: Complete remaining task -> status completed
  console.log('• Test 6: Complete all tasks');
  run('task done 2', tmpDir);
  const json6 = JSON.parse(fs.readFileSync(path.join(tmpDir, '.milestones.json'), 'utf8'));
  assert.strictEqual(json6.progress, '2/2');
  assert.strictEqual(json6.status, 'completed');

  // Test 7: Task remove
  console.log('• Test 7: Task removal');
  run('task add "Temporary task"', tmpDir);
  run('task remove "Temporary"', tmpDir);
  const json7 = JSON.parse(fs.readFileSync(path.join(tmpDir, '.milestones.json'), 'utf8'));
  assert.strictEqual(json7.tasks.length, 2);

  // Test 8: Upward directory traversal
  console.log('• Test 8: Upward discovery from nested subdirectories');
  const subDir = path.join(tmpDir, 'deep', 'nested', 'sub');
  fs.mkdirSync(subDir, { recursive: true });
  const statusOut = run('status', subDir);
  assert(statusOut.includes('M1: Test Milestone'), 'Failed to discover .milestones.json from nested folder');

  // Test 9: Clear milestone
  console.log('• Test 9: Clear milestone');
  run('clear', tmpDir);
  assert(!fs.existsSync(path.join(tmpDir, '.milestones.json')), 'File should be removed on clear');

  // Test 10: Mode configuration
  console.log('• Test 10: Statusline mode switching');
  const modeOut1 = run('mode single', tmpDir);
  assert(modeOut1.includes('Single-Line'), 'Mode single output incorrect');
  const modeOut2 = run('mode stacked', tmpDir);
  assert(modeOut2.includes('Stacked'), 'Mode stacked output incorrect');
  const modeOut3 = run('mode toggle', tmpDir);
  assert(modeOut3.includes('Single-Line'), 'Mode toggle output incorrect');

  console.log('\n\x1b[32m✔ All 10 Milestone CLI Unit Tests Passed!\x1b[0m\n');
} finally {
  fs.rmSync(tmpDir, { recursive: true, force: true });
}
