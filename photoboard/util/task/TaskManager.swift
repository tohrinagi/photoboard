//
//  TaskManager.swift
//  photoboard
//
//  Created by tohrinagi on 2016/02/06.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation

/**
 *  Thread を使ったタスク管理クラス
 */
struct TaskManager {
    private struct Operation {
        static func main() -> NSOperationQueue {
            return NSOperationQueue.mainQueue()
        }
        static let backGroundQueue: NSOperationQueue = {
            var queue = NSOperationQueue()
            queue.maxConcurrentOperationCount = 1
            return queue
        }()
        static func background() -> NSOperationQueue {
            return backGroundQueue
        }
    }
    
    /**
     Mainスレッドでタスク実行
     
     - parameter task:       task
     - parameter completion: タスク実行完了後処理
     */
    static func startMain<T: Task >(task: T, completion:(task: T) -> Void) {
        let taskOperation = createTaskOperation(task, completion: completion)
        Operation.main().addOperation(taskOperation)
    }

    /**
     backgroundスレッドでタスク実行
     
     - parameter task:       task
     - parameter completion: タスク実行完了後処理
     */
    static func startBackground<T: Task >(task: T, completion:(task: T) -> Void) {
        let taskOperation = createTaskOperation(task, completion: completion)
        Operation.background().addOperation(taskOperation)
    }
 
    /**
     task を Operation に割り当てる処理
     
     - parameter task:       task
     - parameter completion: タスク実行完了後処理
     
     - returns: TaskOperation
     */
    private static func createTaskOperation<T: Task>(
        task: T, completion:(task: T) -> Void) -> NSOperation {
        let taskOperation = TaskOperation<T>(task: task, completion)
        return taskOperation
    }
}

private class TaskOperation<T:Task> : NSOperation {
    
    private let task: T
    private let completion : (task: T) -> Void
    init( task: T, _ completion:(task: T) -> Void ) {
        self.task = task
        self.completion = completion
    }
    override func main() {
        task.main()
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            () -> Void in
            self.completion(task: self.task)
        }
    }
    
}
