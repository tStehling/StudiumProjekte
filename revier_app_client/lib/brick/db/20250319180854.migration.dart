// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250319180854_up = [
  DropColumn('shot_by', onTable: 'Shooting'),
  InsertColumn('shot_by_id', Column.varchar, onTable: 'Shooting')
];

const List<MigrationCommand> _migration_20250319180854_down = [
  DropColumn('shot_by_id', onTable: 'Shooting')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250319180854',
  up: _migration_20250319180854_up,
  down: _migration_20250319180854_down,
)
class Migration20250319180854 extends Migration {
  const Migration20250319180854()
    : super(
        version: 20250319180854,
        up: _migration_20250319180854_up,
        down: _migration_20250319180854_down,
      );
}
