import Foundation

class DataMapper {

    static func mapToTask(from taskObject: TaskObject) -> Task {
        // Convert String id to UUID
        let taskUUID = UUID(uuidString: taskObject.id) ?? UUID()  // Fallback to a new UUID if conversion fails
        
        return Task(
            id: taskUUID,
            name: taskObject.name,
            descriptionText: taskObject.descriptionText,
            isComplete: taskObject.isComplete,
            isScheduled: taskObject.isScheduled,
            startTime: taskObject.startTime,
            completionTime: taskObject.completionTime
        )
    }

    static func mapToBlock(from blockObject: BlockObject) -> Block {
        // Convert String id to UUID
        let blockUUID = UUID(uuidString: blockObject.id) ?? UUID()  // Fallback to a new UUID if conversion fails
        
        return Block(
            id: blockUUID,
            name: blockObject.name,
            descriptionText: blockObject.descriptionText,
            isComplete: blockObject.isComplete,
            isScheduled: blockObject.isScheduled,
            startTime: blockObject.startTime,
            completionTime: blockObject.completionTime,
            isRigid: blockObject.isRigid,
            duration: blockObject.duration
        )
    }

    static func mapToTaskObject(from task: Task) -> TaskObject {
        let taskObject = TaskObject()
        taskObject.id = task.id.uuidString // Convert UUID to String for Realm
        taskObject.name = task.name
        taskObject.descriptionText = task.descriptionText
        taskObject.isComplete = task.isComplete
        taskObject.isScheduled = task.isScheduled
        taskObject.startTime = task.startTime
        taskObject.completionTime = task.completionTime
        return taskObject
    }


    static func mapToBlockObject(from block: Block) -> BlockObject {
        let blockObject = BlockObject()
        blockObject.id = block.id.uuidString // Convert UUID to String for Realm
        blockObject.name = block.name
        blockObject.descriptionText = block.descriptionText
        blockObject.isComplete = block.isComplete
        blockObject.isScheduled = block.isScheduled
        blockObject.startTime = block.startTime
        blockObject.completionTime = block.completionTime
        blockObject.isRigid = block.isRigid
        blockObject.duration = block.duration ?? 0
        return blockObject
    }


    
    static func mapToDay(from dayObject: DayObject) -> Day {
        // Convert the LazyMapSequence to a concrete array of TaskLike
        let tasks = Array(dayObject.tasks.map { mapToTask(from: $0) })
        let blocks = Array(dayObject.blocks.map { mapToBlock(from: $0) })
        
        return Day(
            id: dayObject.id,
            date: dayObject.date,
            tasks: tasks,
            blocks: blocks
        )
    }

    static func mapToDayObject(from day: Day) -> DayObject {
        let dayObject = DayObject()
        dayObject.id = day.id
        dayObject.date = day.date
        
        // Convert TaskLike (structs) to TaskObject (Realm model) and append
        let taskObjects = day.tasks.compactMap { task -> TaskObject? in
            if let task = task as? Task {
                return mapToTaskObject(from: task)
            }
            return nil
        }
        dayObject.tasks.append(objectsIn: taskObjects)
        
        // Convert BlockLike (structs) to BlockObject (Realm model) and append
        let blockObjects = day.blocks.compactMap { block -> BlockObject? in
            if let block = block as? Block {
                return mapToBlockObject(from: block)
            }
            return nil
        }
        dayObject.blocks.append(objectsIn: blockObjects)
        
        return dayObject
    }
}
