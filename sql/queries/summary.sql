-- -- name: HiveSummary :one
-- WITH LastInspections AS (
--     SELECT i.hive_id,
--         i.overall_health,
--         ROW_NUMBER() OVER (
--             PARTITION BY i.hive_id
--             ORDER BY i.inspection_date DESC
--         ) AS rn
--     FROM inspections i
--         JOIN hives h ON i.hive_id = h.id
--     WHERE h.farm_id = ?
-- )
-- SELECT COUNT(*) AS total_hives,
--     COUNT(
--         CASE
--             WHEN li.overall_health = 'healthy' THEN 1
--         END
--     ) AS healthy_hives,
--     COUNT(
--         CASE
--             WHEN li.overall_health = 'weak' THEN 1
--         END
--     ) AS weak_hives,
--     COUNT(
--         CASE
--             WHEN li.overall_health = "swarming" THEN 1
--         END
--     ) AS swarming_hives
-- FROM hives h
--     LEFT JOIN LastInspections li ON h.id = li.hive_id
--     AND li.rn = 1
-- WHERE h.farm_id = ?



-- // TODO : check the implementation of this query and understand how to structure complex queries in the codebase 
-- name: HiveSummary :one
SELECT COUNT(*) AS hiveCount,
    SUM(
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM inspections i
                WHERE i.hive_id = h.id
                    AND i.overall_health = 'healthy'
            ) THEN 1
            ELSE 0
        END
    ) AS healthy_inspections_count
FROM hives h
WHERE h.farm_id = ?