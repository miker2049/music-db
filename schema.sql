CREATE TABLE IF NOT EXISTS "Loudness" (
"id" INTEGER,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"bark1" REAL,
"bark2" REAL,
"bark3" REAL,
"bark4" REAL,
"bark5" REAL,
"bark6" REAL,
"bark7" REAL,
"bark8" REAL,
"bark9" REAL,
"bark10" REAL,
"bark11" REAL,
"bark12" REAL,
"bark13" REAL,
"bark14" REAL,
"bark15" REAL,
"bark16" REAL,
"bark17" REAL,
"bark18" REAL,
"bark19" REAL,
"bark20" REAL,
"bark21" REAL,
"bark22" REAL,
"bark23" REAL,
"bark24" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "Frames" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"data"	BLOB,
PRIMARY KEY("id" AUTOINCREMENT)
);


CREATE TABLE IF NOT EXISTS "Chroma" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"c"	REAL,
"cs" REAL,
"d" REAL,
"ds" REAL,
"e" REAL,
"f" REAL,
"fs" REAL,
"g" REAL,
"gs" REAL,
"a" REAL,
"ass" REAL,
"b" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "Chroma2" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"c"	REAL,
"c#" REAL,
"d" REAL,
"d#" REAL,
"e" REAL,
"f" REAL,
"f#" REAL,
"g" REAL,
"g#" REAL,
"a" REAL,
"a#" REAL,
"b" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);


CREATE TABLE IF NOT EXISTS "LPC" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"LPCNbCoeffs0" REAL,
"LPCNbCoeffs1" REAL,
"LPCNbCoeffs2" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);


CREATE TABLE IF NOT EXISTS "MFCC" (
"id" INTEGER,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"CepsNbCoeff1" REAL,
"CepsNbCoeff2" REAL,
"CepsNbCoeff3" REAL,
"CepsNbCoeff4" REAL,
"CepsNbCoeff5" REAL,
"CepsNbCoeff6" REAL,
"CepsNbCoeff7" REAL,
"CepsNbCoeff8" REAL,
"CepsNbCoeff9" REAL,
"CepsNbCoeff10" REAL,
"CepsNbCoeff11" REAL,
"CepsNbCoeff12" REAL,
"CepsNbCoeff13" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);


CREATE TABLE IF NOT EXISTS "SpectralFlatness" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"sf" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "SpectralDecrease" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"sd" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);


CREATE TABLE IF NOT EXISTS "SpectralShapeStatistics" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"centroid" REAL,
"spread" REAL,
"skewness" REAL,
"kurtosis" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "SpectralSlope" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"ss" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "SpectralVariation" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"sv" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "PerceptualSpread" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"ps" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);


CREATE TABLE IF NOT EXISTS "PerceptualSharpness" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"psh" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "ComplexDomainOnsetDetection" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"onset" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);


CREATE TABLE IF NOT EXISTS "OBSI" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"OBSI1" REAL,
"OBSI2" REAL,
"OBSI3" REAL,
"OBSI4" REAL,
"OBSI5" REAL,
"OBSI6" REAL,
"OBSI7" REAL,
"OBSI8" REAL,
"OBSI9" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);


CREATE TABLE IF NOT EXISTS "OBSIR" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"OBSIR1" REAL,
"OBSIR2" REAL,
"OBSIR3" REAL,
"OBSIR4" REAL,
"OBSIR5" REAL,
"OBSIR6" REAL,
"OBSIR7" REAL,
"OBSIR8" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "AmplitudeModulation" (
"id"	INTEGER NOT NULL,
"filename"	TEXT,
"normalize"	INTEGER,
"resample"	INTEGER,
"samplerate"	INTEGER,
"blockSize"	INTEGER,
"stepSize"	INTEGER,
"rowNumber" INTEGER,
"AM1" REAL,
"AM2" REAL,
"AM3" REAL,
"AM4" REAL,
"AM5" REAL,
"AM6" REAL,
"AM7" REAL,
"AM8" REAL,
PRIMARY KEY("id" AUTOINCREMENT)
);
