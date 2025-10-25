// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250319180222_up = [
  DropColumn('created_by', onTable: 'Caliber'),
  DropColumn('updated_by', onTable: 'Caliber'),
  InsertColumn('created_by_id', Column.varchar, onTable: 'Caliber'),
  InsertColumn('updated_by_id', Column.varchar, onTable: 'Caliber')
];

const List<MigrationCommand> _migration_20250319180222_down = [
  DropColumn('created_by_id', onTable: 'Caliber'),
  DropColumn('updated_by_id', onTable: 'Caliber')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250319180222',
  up: _migration_20250319180222_up,
  down: _migration_20250319180222_down,
)
class Migration20250319180222 extends Migration {
  const Migration20250319180222()
    : super(
        version: 20250319180222,
        up: _migration_20250319180222_up,
        down: _migration_20250319180222_down,
      );
}
