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

CREATE TABLE IF NOT EXISTS "FeatureData" (
"id" INTEGER PRIMARY KEY AUTOINCREMENT,
"runID" INTEGER,
"songIndex" INTEGER,
"segment" INTEGER,
"lx_barks" TEXT,
"chroma_output"	TEXT,
"chroma2_output" TEXT,
"LPC_NbCoeffs" TEXT,
"chord" REAL,
"MFCC_CepsNbCoeffs" TEXT,
"sf" REAL,
"sd" REAL,
"centroid" REAL,
"spread" REAL,
"skewness" REAL,
"kurtosis" REAL,
"ss" REAL,
"sv" REAL,
"ps" REAL,
"psh" REAL,
"onset" REAL,
"OBSI" TEXT,
"OBSIR" TEXT,
"AM" TEXT
);

CREATE TABLE IF NOT EXISTS "FrameData" (
"id" INTEGER PRIMARY KEY AUTOINCREMENT,
"runID" INTEGER,
"songIndex" INTEGER,
"segment" INTEGER,
"frame_data" BLOB,
UNIQUE("runID", "songIndex")
);
