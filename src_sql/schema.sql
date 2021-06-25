CREATE TABLE IF NOT EXISTS "Loudness" (
"id" INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
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
UNIQUE("runID", "rowNumber")
);

CREATE TABLE IF NOT EXISTS "Frames" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
"rowNumber" INTEGER,
"data"	BLOB,
UNIQUE("runID", "rowNumber")
);


CREATE TABLE IF NOT EXISTS "Chroma" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
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
UNIQUE("runID", "rowNumber")
);

CREATE TABLE IF NOT EXISTS "Chroma2" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
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
UNIQUE("runID", "rowNumber")
);


CREATE TABLE IF NOT EXISTS "LPC" (
"id"	INTEGER PRIMARY KEY,
"filename"	TEXT,
"segment" INTEGER,
"runID" INTEGER,
"rowNumber" INTEGER,
"LPCNbCoeffs0" REAL,
"LPCNbCoeffs1" REAL,
"LPCNbCoeffs2" REAL,
UNIQUE("runID", "rowNumber")
);

CREATE TABLE IF NOT EXISTS "Chords" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
"rowNumber" INTEGER,
"chord" REAL,
UNIQUE("runID", "rowNumber")
);


CREATE TABLE IF NOT EXISTS "MFCC" (
"id" INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
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
UNIQUE("runID", "rowNumber")
);


CREATE TABLE IF NOT EXISTS "SpectralFlatness" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
"rowNumber" INTEGER,
"sf" REAL,
UNIQUE("runID", "rowNumber")
);

CREATE TABLE IF NOT EXISTS "SpectralDecrease" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
"rowNumber" INTEGER,
"sd" REAL,
UNIQUE("runID", "rowNumber")
);


CREATE TABLE IF NOT EXISTS "SpectralShapeStatistics" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
"rowNumber" INTEGER,
"centroid" REAL,
"spread" REAL,
"skewness" REAL,
"kurtosis" REAL,
UNIQUE("runID", "rowNumber")
);

CREATE TABLE IF NOT EXISTS "SpectralSlope" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
"rowNumber" INTEGER,
"ss" REAL,
UNIQUE("runID", "rowNumber")
);

CREATE TABLE IF NOT EXISTS "SpectralVariation" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
"rowNumber" INTEGER,
"sv" REAL,
UNIQUE("runID", "rowNumber")
);

CREATE TABLE IF NOT EXISTS "PerceptualSpread" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"rowNumber" INTEGER,
"segment" INTEGER,
"ps" REAL,
UNIQUE("runID", "rowNumber")
);


CREATE TABLE IF NOT EXISTS "PerceptualSharpness" (
"id"	INTEGER PRIMARY KEY,
"segment" INTEGER,
"runID" INTEGER,
"rowNumber" INTEGER,
"psh" REAL,
UNIQUE("runID", "rowNumber")
);

CREATE TABLE IF NOT EXISTS "ComplexDomainOnsetDetection" (
"id"	INTEGER PRIMARY KEY,
"segment" INTEGER,
"runID" INTEGER,
"rowNumber" INTEGER,
"onset" REAL,
UNIQUE("runID", "rowNumber")
);


CREATE TABLE IF NOT EXISTS "OBSI" (
"id"	INTEGER PRIMARY KEY,
"segment" INTEGER,
"runID" INTEGER,
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
UNIQUE("runID", "rowNumber")
);


CREATE TABLE IF NOT EXISTS "OBSIR" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
"rowNumber" INTEGER,
"OBSIR1" REAL,
"OBSIR2" REAL,
"OBSIR3" REAL,
"OBSIR4" REAL,
"OBSIR5" REAL,
"OBSIR6" REAL,
"OBSIR7" REAL,
"OBSIR8" REAL,
UNIQUE("runID", "rowNumber")
);

CREATE TABLE IF NOT EXISTS "AmplitudeModulation" (
"id"	INTEGER PRIMARY KEY,
"runID" INTEGER,
"segment" INTEGER,
"rowNumber" INTEGER,
"AM1" REAL,
"AM2" REAL,
"AM3" REAL,
"AM4" REAL,
"AM5" REAL,
"AM6" REAL,
"AM7" REAL,
"AM8" REAL,
UNIQUE("runID", "rowNumber")
);

CREATE TABLE IF NOT EXISTS "ProcessingRunsMeta" (
"id" INTEGER PRIMARY KEY AUTOINCREMENT,
"filename"	TEXT,
"dateAdded"	CURRENT_DATE,
"lx_settings"	TEXT,
"chr_settings"	TEXT,
"chr2_settings"	TEXT,
"chords_settings"	TEXT,
"psp_settings"	TEXT,
"psh_settings"	TEXT,
"ss_settings"	TEXT,
"sv_settings"	TEXT,
"sd_settings"	TEXT,
"sf_settings"	TEXT,
"sss_settings"	TEXT,
"mfcc_settings"	TEXT,
"lpc_settings"	TEXT,
"obsi_settings"	TEXT,
"obsir_settings"	TEXT,
"am_settings"	TEXT,
"onset_settings"	TEXT,
"frame_settings"	TEXT
);
