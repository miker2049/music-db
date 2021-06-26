#!/usr/bin/env python3

qs={
    "meta":"INSERT INTO ProcessingRunsMeta (filename, lx_settings, chr_settings, chr2_settings, \
chords_settings, psp_settings, psh_settings, ss_settings, sv_settings, \
sd_settings, sf_settings, sss_settings, mfcc_settings, lpc_settings, \
obsi_settings, obsir_settings, am_settings, onset_settings, frame_settings, dateAdded) \
VALUES (?,?,?,? ,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?, ?,?);",

"lx":"INSERT INTO Loudness \
 (runID, segment, rowNumber, \
bark1,bark2,bark3,bark4,bark5,bark6,bark7,bark8,bark9,bark10,bark11,bark12, \
bark13,bark14,bark15,bark16,bark17,bark18,bark19,bark20,bark21,bark22,bark23,bark24 \
) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",

    "frame":"INSERT INTO Frames (runID, segment, rowNumber, data) VALUES (?,?,?,?);",

"chr":"INSERT INTO Chroma (runID, segment, rowNumber, c, cs, d, ds, e, f, fs,g,gs,a,ass,b \
) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",

"chr2":"INSERT INTO Chroma2 (runID, segment, rowNumber, c, cs, d, ds, e, f, fs,g,gs,a,ass,b \
) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",

"mfcc":"INSERT INTO MFCC (runID, segment, rowNumber, \
CepsNbCoeff1,CepsNbCoeff2,CepsNbCoeff3,CepsNbCoeff4,CepsNbCoeff5,CepsNbCoeff6,CepsNbCoeff7, \
CepsNbCoeff8,CepsNbCoeff9,CepsNbCoeff10,CepsNbCoeff11,CepsNbCoeff12,CepsNbCoeff13 \
) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",

    "sd":"INSERT INTO SpectralDecrease (runID, segment, rowNumber, sd) VALUES (?,?,?,?);",
    "ss":"INSERT INTO SpectralSlope (runID, segment, rowNumber, ss) VALUES (?,?,?,?);",
    "sf":"INSERT INTO SpectralFlatness (runID, segment, rowNumber, sf) VALUES (?,?,?,?);",
    "sv":"INSERT INTO SpectralVariation (runID, segment, rowNumber, sv) VALUES (?,?,?,?);",

"sss":"INSERT INTO SpectralShapeStatistics \
 (runID, segment, rowNumber, centroid,spread,skewness,kurtosis) VALUES (?,?,?,?,?,?,?);",


    "chord":"INSERT INTO Chords (runID, segment, rowNumber, chord) VALUES (?,?,?,?);",


    "psp":"INSERT INTO PerceptualSpread (runID, segment, rowNumber, ps) VALUES (?,?,?,?);",
    "psh":"INSERT INTO PerceptualSharpness (runID, segment, rowNumber, psh) VALUES (?,?,?,?);",
    "onset":"INSERT INTO ComplexDomainOnsetDetection (runID, segment, rowNumber, onset) VALUES (?,?,?,?);",

"lpc":"INSERT INTO LPC (runID, segment, rowNumber, LPCNbCoeffs0, LPCNbCoeffs1,LPCNbCoeffs2) \
 VALUES (?,?,?,?,?,?);",

"obsi":"INSERT INTO OBSI (runID, segment, rowNumber, \
OBSI1,OBSI2,OBSI3,OBSI4,OBSI5,OBSI6,OBSI7,OBSI8,OBSI9) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);",

"obsir":"INSERT INTO OBSIR (runID, segment, rowNumber, \
OBSIR1,OBSIR2,OBSIR3,OBSIR4,OBSIR5,OBSIR6,OBSIR7,OBSIR8) VALUES (?,?,?,?,?,?,?,?,?,?,?);",

"am":"INSERT INTO AmplitudeModulation (runID, segment, rowNumber, \
AM1,AM2,AM3,AM4,AM5,AM6,AM7,AM8) VALUES (?,?,?,?,?,?,?,?,?,?,?);"

     }
