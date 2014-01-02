WITH    RECURSIVE
        q (r, i, rx, ix, g) AS
        (
        SELECT  r::DOUBLE PRECISION * 0.0001, i::DOUBLE PRECISION * 0.0002,
                r::DOUBLE PRECISION * 0.0001, i::DOUBLE PRECISION * 0.0002,
                0
        FROM    generate_series(-400, -240) r, generate_series(0, 100) i
        UNION ALL
        SELECT  r, i,
                CASE WHEN ABS(rx * rx + ix * ix) < 1E8 THEN rx * rx - ix * ix END - 0.70176,
                CASE WHEN ABS(rx * rx + ix * ix) < 1E8 THEN 2 * rx * ix END + 0.3842,
                g + 1
        FROM    q
        WHERE   rx IS NOT NULL
                AND g < 99
        )
SELECT  ARRAY_TO_STRING(ARRAY_AGG(s ORDER BY r), '')
FROM    (
        SELECT  i, r, SUBSTRING(' .:-=+*#%@', MAX(g) / 10 + 1, 1) s
        FROM    q
        GROUP BY
                i, r
        ) q
GROUP BY
        i
ORDER BY
        i
