WITH    RECURSIVE
        q (r, i, rx, ix, g) AS
        (
        SELECT  r::DOUBLE PRECISION * 0.0000005, i::DOUBLE PRECISION * 0.000001,
                r::DOUBLE PRECISION * 0.0000005, i::DOUBLE PRECISION * 0.000001,
                0
        FROM    generate_series(-80, 80) r, generate_series(-50, 50) i
        UNION ALL
        SELECT  r, i,
                CASE WHEN ABS(rx * rx + ix * ix) < 1E8 THEN rx * rx - ix * ix END + 0,
                CASE WHEN ABS(rx * rx + ix * ix) < 1E8 THEN 2 * rx * ix END + 1,
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
