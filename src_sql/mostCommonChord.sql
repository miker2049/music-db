SELECT chord,
             COUNT(chord) AS `value_occurrence` 
    FROM     Chords
	WHERE filename like "%julien%"
    GROUP BY chord
    ORDER BY `value_occurrence` DESC
    LIMIT    2;