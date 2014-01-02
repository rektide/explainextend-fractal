WITH    RECURSIVE
        q (r, i, rx, ix, g) AS
        (
        SELECT  x + r::DOUBLE PRECISION * step / 2., y + i::DOUBLE PRECISION * step,
                x + r::DOUBLE PRECISION * step / 2., y + i::DOUBLE PRECISION * step,
                0
        FROM    (
                SELECT  0.25 x, -0.55 y, 0.002 step, r, i
                FROM    generate_series(-80, 80) r
                CROSS JOIN
                        generate_series(-40, 40) i
                ) q
        UNION ALL
        SELECT  r, i,
                CASE WHEN (rx * rx + ix * ix) < 1E8 THEN (rx * rx + ix * ix) ^ 0.75 * COS(1.5 * ATAN2(ix, rx)) END - 0.2,
                CASE WHEN (rx * rx + ix * ix) < 1E8 THEN (rx * rx + ix * ix) ^ 0.75 * SIN(1.5 * ATAN2(ix, rx)) END,
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
