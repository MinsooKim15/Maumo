//
//  ChattingModel.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct ChattingModel{
    var messages: Array<Message> = []
    

    mutating func snapshotsToMessages(snapshots:[QueryDocumentSnapshot]){
        self.messages = snapshots.compactMap{(querySnapshot) -> Message? in
//            return try? querySnapshot.data(as:Message.self)
            do{
                return try querySnapshot.data(as:Message.self)
            } catch{

                var message_:Message? = nil
                return message_
            }

        }
        self.messages = self.messages.sorted(by: {$0.sentTime < $1.sentTime})
        
    }
    func getUnusedTimer()->Message?{
        for message in self.messages{
            if let replyType_ = message.replyType, replyType_ == .timer{
                if let timerTemp = message.data.timer{
                    if !message.used{
                        return message
                    }
                }
            }
        }
        return nil
    }

    
    mutating func getLastContexts()->[Context]?{
        return self.messages.last?.contexts
    }
}
