// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250330133526_up = [
  InsertColumn('hunting_ground_id', Column.varchar, onTable: 'Camera'),
  InsertColumn('hunting_ground_id', Column.varchar, onTable: 'HuntingGroundUserRole'),
  InsertColumn('hunting_ground_id', Column.varchar, onTable: 'Sighting')
];

const List<MigrationCommand> _migration_20250330133526_down = [
  DropColumn('hunting_ground_id', onTable: 'Camera'),
  DropColumn('hunting_ground_id', onTable: 'HuntingGroundUserRole'),
  DropColumn('hunting_ground_id', onTable: 'Sighting')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250330133526',
  up: _migration_20250330133526_up,
  down: _migration_20250330133526_down,
)
class Migration20250330133526 extends Migration {
  const Migration20250330133526()
    : super(
        version: 20250330133526,
        up: _migration_20250330133526_up,
        down: _migration_20250330133526_down,
      );
}
