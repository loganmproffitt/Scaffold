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
            completionTime: taskObject.completionTime,
            colorHex: taskObject.colorHex
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
            colorHex: blockObject.colorHex,
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
        taskObject.colorHex = task.colorHex
        return taskObject
    }


    static func mapToBlockObject(from block: Block) -> BlockObject {
        let blockObject = BlockObject()
        blockObject.id = block.id.uuidString  // Convert UUID to String for Realm
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
        print("Object blocks:")
        print(dayObject.blocks)
        let tasks = Array(dayObject.tasks.map { mapToTask(from: $0) })
        let blocks = Array(dayObject.blocks.map { mapToBlock(from: $0) })
        let id = UUID(uuidString: dayObject.id) ?? UUID()
        
        return Day(
            id: id,
            date: dayObject.date,
            tasks: tasks,
            blocks: blocks
        )
    }

    static func mapToDayObject(from day: Day) -> DayObject {
        let dayObject = DayObject()
        dayObject.id = day.id.uuidString
        dayObject.date = day.date
        
        // Convert TaskLike (structs) to TaskObject (Realm model) and append
        let taskObjects = day.tasks.compactMap { task -> TaskObject? in
            // Safely cast Task to TaskObject
            return mapToTaskObject(from: task)
        }
        dayObject.tasks.append(objectsIn: taskObjects)
        
        // Convert BlockLike (structs) to BlockObject (Realm model) and append
        let blockObjects = day.blocks.compactMap { block -> BlockObject? in
            // Safely cast Block to BlockObject
            return mapToBlockObject(from: block)
        }
        dayObject.blocks.append(objectsIn: blockObjects)
        
        return dayObject
    }

}
