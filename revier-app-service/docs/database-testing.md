# Database Testing with pgTAP

This project uses [pgTAP](https://pgtap.org/) for database testing, which allows us to write unit tests directly against the PostgreSQL database. The tests verify:

1. Row-Level Security (RLS) policies are correctly implemented
2. Data integrity constraints are enforced
3. Permissions and roles function correctly
4. Sighting data distribution meets requirements
5. Entity relationships are valid

## Test Organization

The tests are organized in the following migration files:

- `202505140000_pgtap_tests.sql`: Base tests for RLS policies and data integrity
- `202505140001_pgtap_data_tests.sql`: Tests for sighting data distribution
- `202505140002_pgtap_policy_tests.sql`: Tests for upload and tag policies

## Running Tests

### Option 1: Via Shell Script (Recommended)

We provide a shell script that handles the database connection and runs all tests:

```bash
./run-db-tests.sh
```

This script requires a valid `.env` file with a `DB_URL` variable pointing to your Supabase database.

### Option 2: Via Supabase CLI

If you have the Supabase CLI installed, you can run:

```bash
supabase db reset  # Apply all migrations including test migrations
psql -h localhost -p 54322 -U postgres -d postgres -c "SELECT * FROM run_all_tests();"
```

### Option 3: Directly in Supabase Studio

You can run tests directly in the Supabase Studio SQL Editor:

```sql
SELECT * FROM run_all_tests();
```

## Test Coverage

The tests verify:

### Policy Tests
- Hunting ground owner permissions
- Hunting ground user role permissions
- Sighting access controls
- Camera access controls
- Upload permissions
- Tag permissions
- Admin override permissions

### Data Integrity Tests
- Foreign key relationships
- Required fields validation
- Valid data ranges
- Distribution of sightings across hunting grounds and species

### Permission System Tests
- Role-based permissions
- Permission inheritance
- Owner auto-permissions

## Adding New Tests

Add new tests by:

1. Create a new PL/pgSQL function that returns `SETOF TEXT`
2. Use pgTAP assertion functions like `ok()`, `cmp_ok()`, etc.
3. Add your test function to the `run_tests()` function

Example test function:

```sql
CREATE OR REPLACE FUNCTION test_my_feature()
RETURNS SETOF TEXT AS $$
BEGIN
    RETURN NEXT ok(
        EXISTS (SELECT 1 FROM my_table WHERE condition),
        'Test description'
    );
END;
$$ LANGUAGE plpgsql;
```

Then add it to the test runner:

```sql
CREATE OR REPLACE FUNCTION run_tests()
RETURNS SETOF TEXT AS $$
BEGIN
    -- Existing tests
    ...
    
    -- New test
    RETURN QUERY SELECT * FROM test_my_feature();
END;
$$ LANGUAGE plpgsql;
``` 