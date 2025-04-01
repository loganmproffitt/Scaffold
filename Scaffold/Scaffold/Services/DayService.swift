import Foundation
import RealmSwift

class DayService {

    private let realm: Realm

    init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }

    /// Loads an existing Day for a given date or creates a new one.
    func loadOrCreateDay(for date: Date) -> Day {
        if let dayObject = realm.objects(DayObject.self).filter("date == %@", date).first {
            return DataMapper.mapToDay(from: dayObject)
        } else {
            let newDay = Day(id: UUID().uuidString, date: date, tasks: [], blocks: [])
            saveDay(newDay)
            return newDay
        }
    }

    /// Saves or updates a Day and its associated tasks and blocks.
    func saveDay(_ day: Day) {
        let dayObject = DataMapper.mapToDayObject(from: day)
        print("Saved day called.")
        do {
            try realm.write {
                realm.add(dayObject, update: .modified)
            }
        } catch {
            print("Error saving Day: \(error.localizedDescription)")
        }
    }

    /// Saves or updates a Task individually.
    func saveTask(_ task: Task) {
        let taskObject = DataMapper.mapToTaskObject(from: task)

        do {
            try realm.write {
                realm.add(taskObject, update: .modified)
            }
        } catch {
            print("Error saving Task: \(error.localizedDescription)")
        }
    }

    /// Saves or updates a Block individually.
    func saveBlock(_ block: Block) {
        let blockObject = DataMapper.mapToBlockObject(from: block)

        do {
            try realm.write {
                realm.add(blockObject, update: .modified)
            }
        } catch {
            print("Error saving Block: \(error.localizedDescription)")
        }
    }

    /// Deletes a specific Block
    func deleteBlock(withId id: String) {
        if let block = realm.objects(BlockObject.self).filter("id == %@", id).first {
            try? realm.write {
                realm.delete(block)
            }
        }
    }

    /// Deletes a specific Task
    func deleteTask(withId id: String) {
        if let task = realm.objects(TaskObject.self).filter("id == %@", id).first {
            try? realm.write {
                realm.delete(task)
            }
        }
    }
}
