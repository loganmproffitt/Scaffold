import RealmSwift

class RealmMigrationManager {
    static func configureMigration() {
        let config = Realm.Configuration(
            schemaVersion: 1, // 🔄 Increment this whenever your schema changes
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // 🆕 Example: Add default colorHex to existing objects
                    migration.enumerateObjects(ofType: "TaskObject") { oldObject, newObject in
                        newObject?["colorHex"] = "#FFBF69"
                    }
                    
                    migration.enumerateObjects(ofType: "BlockObject") { oldObject, newObject in
                        newObject?["colorHex"] = "#2EC4B6"
                    }
                }
                // Add more migrations here if schemaVersion increases again
            }
        )

        Realm.Configuration.defaultConfiguration = config
    }
}
