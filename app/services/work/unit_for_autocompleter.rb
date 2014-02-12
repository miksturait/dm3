class Work::UnitForAutocompleter
  def self.find(query)
    Work::Unit.find_by_sql([%Q{SELECT id, (repeat( '> ', ancestry_depth-1) || COALESCE(name, wuid)) as name FROM (

 SELECT id, name, wuid, type, ancestry_depth,
      (
        ARRAY_TO_STRING(
	        ARRAY_APPEND(
		        REGEXP_SPLIT_TO_ARRAY(ancestry, '/'),
		        id::TEXT
		      ), '/'
        )
      ) as position
      FROM (

        WITH work_units_matched AS (
          SELECT * FROM work_units
                WHERE work_units.name ~* ?
                        OR
                        work_units.wuid ~* ?
                      AND
                      work_units.ancestry_depth IN #{ancestry_depth}
        )

        SELECT * FROM work_units WHERE ancestry ~ (
          SELECT '(' || ARRAY_TO_STRING(
            ARRAY_AGG(
              ARRAY_TO_STRING(
                ARRAY_APPEND(
                  REGEXP_SPLIT_TO_ARRAY(ancestry, '/'),
                  id::TEXT
                ), '/'
              ) || '.*'
            ), '|') || ')' AS position
              FROM work_units_matched
        )

        UNION

        SELECT * FROM work_units WHERE id IN (
                SELECT UNNEST(
                  ARRAY_APPEND(
                    REGEXP_SPLIT_TO_ARRAY(ancestry, '/')::INTEGER[],
                    id
                  )
                ) FROM work_units_matched
                WHERE ancestry_depth > 0)

        ) AS work_units_position
      WHERE ancestry_depth IN #{ancestry_depth}
      ORDER BY position

  ) AS work_units_filtered

}, query, query])
  end

  def self.ancestry_depth
    '(1,2,3)'
  end
end