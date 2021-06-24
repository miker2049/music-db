
// require('dotenv').config()
const path = require('path')
const fs = require('fs')
const { spawn } = require('child_process')
const sqlite3 = require('sqlite3').verbose();
const inserters = require('./inserters')


const FEATURE_CONFIG_PATH = "featureConfig";
const AUDIO_FILE_CONFIG_PATH = process.argv[2]
const FEATURE_ARGS = ['run',
  '--rm=true',
  `--volume=${__dirname}:/wd`,
  '--workdir=/wd',
  'yaafe',
  '-r', '16000',
  '--verbose',
  '--resample',
  '-c', FEATURE_CONFIG_PATH,
  AUDIO_FILE_CONFIG_PATH];
const FRAMES_ARGS = ['run',
  '--rm=true',
  `--volume=${__dirname}:/wd`,
  '--workdir=/wd',
  'yaafe',
  '-r', '44100',
  '--verbose',
  '--resample',
  "-f", "frames: Frames blockSize=1024 stepSize=1024",
  AUDIO_FILE_CONFIG_PATH];


function getAubioOnsets() {
  let onsets = ''
  return new Promise((res, rej) => {
    const aubio_process = spawn('aubioonset', [AUDIO_FILE_CONFIG_PATH]);

    aubio_process.stdout.on('data', (data) => {
      onsets += data;
    });

    aubio_process.stderr.on('data', (data) => {
      console.error(`stderr: ${data}`);
    });

    aubio_process.on('close', (code) => {
      console.log(`the aubio child process exited with code ${code}`);
      if (code > 0) {
        rej()
      } else {
        res(
          onsets.split('\n')
            .filter(e => e ? true : false)
            .map(i => parseFloat(i))
        )
      }
    });

  })
}

function get_expected_csv_names(path, sound) {
  let arr = [];
  const text = fs.readFileSync(path).toString()
  for (let line of text.split('\n')) {
    const name = line.match(/^(\w+)\:/)
    // console.log(name)
    if (name) {
      arr.push(`${sound}.${name[1]}.csv`)

    }
  }
      arr.push(`${sound}.frames.csv`)
  return arr
}
function run_yaafe(args) {
  return new Promise((res, rej) => {
    const yaafe_process = spawn('docker', args);

    yaafe_process.stdout.on('data', (data) => {
    });

    yaafe_process.stderr.on('data', (data) => {
      console.error(`stderr: ${data}`);
    });

    yaafe_process.on('close', (code) => {
      console.log(`the yaafe child process exited with code ${code}`);
      if (code > 0) {
        rej()
      } else {
        res()
      }
    });

  })
}

function getFeatureKeys(files) {
  let keys = []
  files.forEach(item => {

    const match = item.match(/wav\.(.+)\.csv/)
    keys.push(match[1])
  });
  return keys
}

// https://stackoverflow.com/a/47764403
function checkExistsWithTimeout(filePath, timeout) {
  return new Promise(function(resolve, reject) {

    var timer = setTimeout(function() {
      watcher.close();
      reject(new Error('File did not exists and was not created during the timeout.'));
    }, timeout);

    fs.access(filePath, fs.constants.R_OK, function(err) {
      if (!err) {
        clearTimeout(timer);
        watcher.close();
        resolve(filePath);
      }
    });

    var dir = path.dirname(filePath);
    var basename = path.basename(filePath);
    var watcher = fs.watch(dir, function(eventType, filename) {
      if (eventType === 'rename' && filename === basename) {
        clearTimeout(timer);
        watcher.close();
        resolve(filePath);
      }
    });
  });
}

async function rm_if_exists(filepath) {
  try {
    await fs.promises.stat(filepath)
  } catch (err) {
    return true
  }
  await fs.promises.rm(filepath)
  return true
}
async function cleanCSV(files) {
  await Promise.all(files.map((item, i, arr) => rm_if_exists(item)))
}

async function create_csv_files() {
  //clean
  const files = get_expected_csv_names(FEATURE_CONFIG_PATH, AUDIO_FILE_CONFIG_PATH)
  await cleanCSV(files)
  await run_yaafe(FEATURE_ARGS)
  await run_yaafe(FRAMES_ARGS)
  const assuredfiles = await Promise.all(files.map((item, i, arr) => checkExistsWithTimeout(item, 100)))
  return assuredfiles
}


async function parse_csv_file(file) {
  const lines = (await fs.promises.readFile(file)).toString().split('\n')
  let meta = [], data = []
  lines.forEach(line => {
    if (line[0] === '%') {
      line.substring(2).split(' ').forEach(item => {
        meta.push(
          item.split('=')
        )
      });
    } else {
      data.push(line)
    }
  })
  return [meta, data]
}


async function add_file_to_db(file, db) {
  const [meta, data] = await parse_csv_file(file)
    let metaobj = {}
    meta.forEach(v => metaobj[v[0]] = v[1])
    // const table=meta.find((v)=>v[0]==='yaafedefinition')[1].split(' ')[0]
    const table = metaobj.yaafedefinition
    metaobj.filename = path.basename(AUDIO_FILE_CONFIG_PATH);

    if (inserters[table]){
      await inserters[table](metaobj,data,db)
    } else {
      console.log('no table for ' + table)
    }
}
// run_yaafe().then(t=>console. log('done!'))
//sald

(async function() {
  const db = new sqlite3.Database('./DB.db', sqlite3.OPEN_READWRITE);
  const files = await create_csv_files().catch((err) => { console.log(err) })
db.run('PRAGMA synchronous=OFF')
db.run('PRAGMA count_changes=OFF')
db.run('PRAGMA journal_mode=MEMORY')
db.run('PRAGMA temp_store=MEMORY')
  // const onsets = await getAubioOnsets()
  getFeatureKeys(files)
  await Promise.all(files.map((item, i, arr) => add_file_to_db(item,db)))
  db.close()
  cleanCSV(files)
  console.log('done!')
})()
// db.close();
