
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
                   index, String(item.split(',').map((item) => parseFloat(item)))+"%");
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
CepsNbCoeff1,CepsNbCoeff2,CepsNbCoeff3,CepsNbCoeff4,CepsNbCoeff5,CepsNbCoeff6,CepsNbCoeff7,
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
      const stmt = db.prepare(`INSERT INTO SpectralDecrease
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
  "Chords": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO Chords
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber, chord)
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
  "PerceptualSpread": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO PerceptualSpread
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber, ps)
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
  "PerceptualSharpness": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO PerceptualSharpness
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber, psh)
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
  "ComplexDomainOnsetDetection": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO ComplexDomainOnsetDetection
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber, onset)
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
  "LPC": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO LPC
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber,
LPCNbCoeffs0, LPCNbCoeffs1,LPCNbCoeffs2)
 VALUES (?,?,?,?,?,?,?,?,?,?);`);
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
  "OBSI": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO OBSI
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber,
OBSI1,OBSI2,OBSI3,OBSI4,OBSI5,OBSI6,OBSI7,OBSI8,OBSI9)
 VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);`);
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
  "OBSIR": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO OBSIR
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber,
OBSIR1,OBSIR2,OBSIR3,OBSIR4,OBSIR5,OBSIR6,OBSIR7,OBSIR8)
 VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);`);
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
  "AmplitudeModulation": (meta, data, db) => {
    return new Promise((res, rej) => {
      const stmt = db.prepare(`INSERT INTO AmplitudeModulation
 (filename, normalize,resample,samplerate,blockSize, stepSize, rowNumber,
AM1,AM2,AM3,AM4,AM5,AM6,AM7,AM8)
 VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);`);
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
}
