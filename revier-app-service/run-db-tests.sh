#!/bin/bash

# Run Supabase pgTAP Tests
# This script executes the pgTAP tests defined in the database

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Running database tests using pgTAP with Supabase CLI..."

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
  echo -e "${RED}Error: Supabase CLI not found${NC}"
  echo "Please install the Supabase CLI: https://supabase.com/docs/guides/cli"
  exit 1
fi

# Define the database connection URL
DB_URL="postgresql://postgres.your-tenant-id:Overfull-Itinerary-Legwork-P3elt-NQkr@192.168.178.100:5432/postgres"

# Run the tests using Supabase CLI
echo "Running tests in supabase/tests/database..."
supabase test db "supabase/tests/database" --db-url="$DB_URL" --debug

# Check the exit status
exit_code=$?

if [ $exit_code -eq 0 ]; then
  echo -e "${GREEN}All tests completed successfully!${NC}"
else
  echo -e "${RED}Some tests failed. Please check the output above.${NC}"
  exit 1
fi 