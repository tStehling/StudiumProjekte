// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250330131421_up = [
  DropColumn('federal_state_id', onTable: 'HuntingGround'),
  DropColumn('species_id', onTable: 'AllowedCaliber'),
  DropColumn('caliber_id', onTable: 'AllowedCaliber'),
  DropColumn('federal_state_id', onTable: 'AllowedCaliber'),
  DropColumn('federal_state_id', onTable: 'HuntingSeason'),
  DropColumn('species_id', onTable: 'HuntingSeason'),
  DropColumn('country_id', onTable: 'FederalState'),
  DropColumn('upload_id', onTable: 'UploadUnprocessedMedia'),
  DropColumn('media_id', onTable: 'UploadUnprocessedMedia'),
  DropColumn('user', onTable: 'HuntingGroundUserRole'),
  DropColumn('hunting_ground_id', onTable: 'HuntingGroundUserRole'),
  DropColumn('camera_id', onTable: 'Upload'),
  DropColumn('created_by', onTable: 'Upload'),
  DropColumn('updated_by', onTable: 'Upload'),
  DropColumn('deleted_by', onTable: 'Upload'),
  DropColumn('sighting_id', onTable: 'SightingTag'),
  DropColumn('upload_id', onTable: 'UploadMedia'),
  DropColumn('media_id', onTable: 'UploadMedia')
];

const List<MigrationCommand> _migration_20250330131421_down = [
  
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250330131421',
  up: _migration_20250330131421_up,
  down: _migration_20250330131421_down,
)
class Migration20250330131421 extends Migration {
  const Migration20250330131421()
    : super(
        version: 20250330131421,
        up: _migration_20250330131421_up,
        down: _migration_20250330131421_down,
      );
}
