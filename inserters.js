
module.exports = {
  "Loudness": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO Loudness
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber,
bark1,bark2,bark3,bark4,bark5,bark6,bark7,bark8,bark9,bark10,bark11,bark12,
bark13,bark14,bark15,bark16,bark17,bark18,bark19,bark20,bark21,bark22,bark23,bark24
) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);`);
      data.forEach((item, index) => {
        stmt.bind( meta.filename,
                    meta.normalize,
                    meta.resample,
                    meta.samplerate,
                    meta.blockSize,
                    meta.stepSize,
                   index, ...item.split(','));
      stmt.run();
      });
      stmt.finalize(res)
    })
  },
  "Frames": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO Frames
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber,
data
) VALUES (?,?,?,?,?,?,?,?);`);
      data.forEach((item, index) => {
        stmt.bind( meta.filename,
                    meta.normalize,
                    meta.resample,
                    meta.samplerate,
                    meta.blockSize,
                    meta.stepSize,
                   index, JSON.stringify(item.split(',')));
      stmt.run();
      });
      stmt.finalize(res)
    })
  },


  "Chroma": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO Chroma
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber,
c, cs, d, ds, e, f, fs,g,gs,a,ass,b
) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);`);
      data.forEach((item, index) => {
        stmt.bind( meta.filename,
                    meta.normalize,
                    meta.resample,
                    meta.samplerate,
                    meta.blockSize,
                    meta.stepSize,
                   index, ...item.split(','));
      stmt.run();
      });
      stmt.finalize(res)
    })
  },
  "Chroma2": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO Chroma2
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber,
c, cs, d, ds, e, f, fs,g,gs,a,ass,b
) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);`);
      data.forEach((item, index) => {
        stmt.bind( meta.filename,
                    meta.normalize,
                    meta.resample,
                    meta.samplerate,
                    meta.blockSize,
                    meta.stepSize,
                   index, ...item.split(','));
      stmt.run();
      });
      stmt.finalize(res)
    })
  },
  "MFCC": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO MFCC
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber,
CepsNbCoeff1,CepsNbCoeff2,CepsNbCoeff3,CepsNbCoeff4,CepsNbCoeff5,CepsNbCoeff6,CwepsNbCoeff7,
CepsNbCoeff8,CepsNbCoeff9,CepsNbCoeff10,CepsNbCoeff11,CepsNbCoeff12,CepsNbCoeff13
) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);`);
      data.forEach((item, index) => {
        stmt.bind( meta.filename,
                    meta.normalize,
                    meta.resample,
                    meta.samplerate,
                    meta.blockSize,
                    meta.stepSize,
                   index, ...item.split(','));
      stmt.run();
      });
      stmt.finalize(res)
    })
  },
  "MFCC": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO MFCC
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber,
CepsNbCoeff1,CepsNbCoeff2,CepsNbCoeff3,CepsNbCoeff4,CepsNbCoeff5,CepsNbCoeff6,CwepsNbCoeff7,
CepsNbCoeff8,CepsNbCoeff9,CepsNbCoeff10,CepsNbCoeff11,CepsNbCoeff12,CepsNbCoeff13
) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);`);
      data.forEach((item, index) => {
        stmt.bind( meta.filename,
                    meta.normalize,
                    meta.resample,
                    meta.samplerate,
                    meta.blockSize,
                    meta.stepSize,
                   index, ...item.split(','));
      stmt.run();
      });
      stmt.finalize(res)
    })
  },
  "SpectralFlatness": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO SpectralFlatness
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber, sf)
 VALUES (?,?,?,?,?,?,?,?);`);
      data.forEach((item, index) => {
        stmt.bind( meta.filename,
                    meta.normalize,
                    meta.resample,
                    meta.samplerate,
                    meta.blockSize,
                    meta.stepSize,
                   index, item);
      stmt.run();
      });
      stmt.finalize(res)
    })
  },
  "SpectralDecrease": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO SpectralFlatness
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber, sd)
 VALUES (?,?,?,?,?,?,?,?);`);
      data.forEach((item, index) => {
        stmt.bind( meta.filename,
                    meta.normalize,
                    meta.resample,
                    meta.samplerate,
                    meta.blockSize,
                    meta.stepSize,
                   index, item);
      stmt.run();
      });
      stmt.finalize(res)
    })
  },
"SpectralShapeStatistics": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO SpectralShapeStatistics
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber,
centroid,spread,skewness,kurtosis
) VALUES (?,?,?,?,?,?,?,?,?,?,?);`);
      data.forEach((item, index) => {
        stmt.bind( meta.filename,
                    meta.normalize,
                    meta.resample,
                    meta.samplerate,
                    meta.blockSize,
                    meta.stepSize,
                   index, ...item.split(','));
      stmt.run();
      });
      stmt.finalize(res)
    })
  },
  "SpectralSlope": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO SpectralSlope
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber, ss)
 VALUES (?,?,?,?,?,?,?,?);`);
      data.forEach((item, index) => {
        stmt.bind( meta.filename,
                    meta.normalize,
                    meta.resample,
                    meta.samplerate,
                    meta.blockSize,
                    meta.stepSize,
                   index, item);
      stmt.run();
      });
      stmt.finalize(res)
    })
  },
  "SpectralVariation": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO SpectralVariation
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber, sv)
 VALUES (?,?,?,?,?,?,?,?);`);
      data.forEach((item, index) => {
        stmt.bind( meta.filename,
                    meta.normalize,
                    meta.resample,
                    meta.samplerate,
                    meta.blockSize,
                    meta.stepSize,
                   index, item);
      stmt.run();
      });
      stmt.finalize(res)
    })
  },
}
