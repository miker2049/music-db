
// require('dotenv').config()
const path = require('path')
const fs = require('fs')
const { spawn } = require('child_process')
const sqlite3 = require('sqlite3').verbose();
const inserters = require('./inserters')


const FEATURE_CONFIG_PATH = "featureConfig";
const AUDIO_FILE_CONFIG_PATH = "sounds/testcsus4.wav";
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
      console.log(`stdout: ${data}`);
      onsets += data;
    });

    aubio_process.stderr.on('data', (data) => {
      console.error(`stderr: ${data}`);
    });

    aubio_process.on('close', (code) => {
      console.log(`child process exited with code ${code}`);
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
      console.log(`stdout: ${data}`);
    });

    yaafe_process.stderr.on('data', (data) => {
      console.error(`stderr: ${data}`);
    });

    yaafe_process.on('close', (code) => {
      console.log(`child process exited with code ${code}`);
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

    // console.log(metaobj.blockSize)
    // console.log(metaobj.stepSize)
    // console.log(metaobj.samplerate)
    metaobj.filename = path.basename(file)
    if (table==='Loudness'){
      await inserters['Loudness'](metaobj,data,db)
    }
    if (table==='Frames'){
      await inserters['Frames'](metaobj,data,db)
    }
    if (table==='Chroma'){
      await inserters['Chroma'](metaobj,data,db)
    }
    // console.log(path.basename(file))
    // const json = JSON. stringify(Object.assign(data, { test: 'harm' }))
    // console.dir(json)
    // db.run(`INSERT INTO fileindex (filename, amplitudeModulation) VALUES("testyydasy", json('${json}'));`)
}
// run_yaafe().then(t=>console. log('done!'))

// db.serialize(function() {
//   db.run("CREATE TABLE lorem (info TEXT)");

//   const stmt = db.prepare("INSERT INTO lorem VALUES (?)");
//   for (var i = 0; i < 10; i++) {
//       stmt.run("Ipsum " + i);
//   }
//   stmt.finalize();

//   db.each("SELECT rowid AS id, info FROM lorem", function(err, row) {
//       console.log(row.id + ": " + row.info);
//   });
// });
(async function() {
  const db = new sqlite3.Database('./DB.db', sqlite3.OPEN_READWRITE);
  const files = await create_csv_files().catch((err) => { console.log(err) })
  const onsets = await getAubioOnsets()
  getFeatureKeys(files)
  for (let file of files) {
    await add_file_to_db(file,  db)
  }
  // console.log(files)
  // await add_file_to_db(files[0], db)
  db.close()
})()
// db.close();
