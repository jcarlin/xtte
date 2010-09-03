CREATE FUNCTION createtecustrate() RETURNS INTEGER AS $$
DECLARE
  _statement TEXT := '';
  _version   TEXT := '';
BEGIN
  IF (EXISTS(SELECT relname
               FROM pg_class, pg_namespace
              WHERE relname='tecustrate'
                AND relnamespace=pg_namespace.oid
                AND nspname='te')) THEN
    IF (EXISTS(SELECT attname
                 FROM pg_attribute
                WHERE attrelid=(SELECT oid FROM pg_class WHERE relname='tehead')
                  AND attname='tehead_status')) THEN
      -- do nothing (this ensures that the table is created as needed.  Revisions should go here
    END IF;
  ELSE  
    _statement = 'CREATE TABLE te.tecustrate ' ||
			'(tecustrate_cust_name text NOT NULL, ' ||
			'tecustrate_rate numeric(16,4) NOT NULL, ' ||
			'CONSTRAINT tecustrate_pkey PRIMARY KEY (tecustrate_cust_name) )  ' ||
			'WITH (OIDS=FALSE); ' ||
			'ALTER TABLE te.tecustrate OWNER TO "admin"; ' ||
			'GRANT ALL ON TABLE te.tecustrate TO "admin"; ' ||
			'GRANT ALL ON TABLE te.tecustrate TO xtrole; ' ||
			'COMMENT ON TABLE te.tecustrate IS ''Default Customer Billing rate for Time/Expense''; ';

  END IF;

  EXECUTE _statement;

  RETURN 0;
END;
$$ LANGUAGE 'plpgsql';

SELECT createtecustrate();
DROP FUNCTION createtecustrate();
