import Foundation
import SwiftUI

class DayViewModel: ObservableObject {
    @Published var currentDay: Day
    
    private var dayService: DayService
    
    init(dayService: DayService = DayService(), date: Date = Date()) {
        self.dayService = dayService
        self.currentDay = dayService.loadOrCreateDay(for: date)
    }
    
    func addTask(_ task: Task) {
        currentDay.tasks.append(task)
        dayService.saveTask(task)  // Save the task to Realm
    }
    
    func addBlock(_ block: Block) {
        currentDay.blocks.append(block)
        dayService.saveBlock(block)  // Save the block to Realm
    }
    
    func saveDay() {
        dayService.saveDay(currentDay)  // Save the whole day (tasks + blocks)
    }
    
    func updateBlockTime(id: UUID, newStart: Date, newEnd: Date) {
        if let index = currentDay.blocks.firstIndex(where: { $0.id.uuidString == id.uuidString }) {
            currentDay.blocks[index].startTime = newStart
            currentDay.blocks[index].duration = newEnd.timeIntervalSince(newStart)
            dayService.saveBlock(currentDay.blocks[index])
        }
    }
    
    // Save or update a block
    func saveBlock(_ block: Block) {
        if let index = currentDay.blocks.firstIndex(where: { $0.id == block.id }) {
            currentDay.blocks[index] = block
        } else {
            currentDay.blocks.append(block)
        }
        dayService.saveBlock(block)
    }

    // Delete a block
    func removeBlock(_ block: Block) {
        currentDay.blocks.removeAll { $0.id == block.id }
        dayService.deleteBlock(withId: block.id.uuidString)
    }

    // Save or update a task
    func saveTask(_ task: Task) {
        if let index = currentDay.tasks.firstIndex(where: { $0.id == task.id }) {
            currentDay.tasks[index] = task
        } else {
            currentDay.tasks.append(task)
        }
        dayService.saveTask(task)
    }

    // Delete a task
    func removeTask(_ task: Task) {
        currentDay.tasks.removeAll { $0.id == task.id }
        dayService.deleteTask(withId: task.id.uuidString)
    }
}
