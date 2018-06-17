//
//  Question.swift
//  FSEPractice
//
//  Created by Duminica Octavian on 16/06/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import Foundation

private struct QuestionKey {
    static let question = "question"
    static let firstAnswer = "0"
    static let secondAnswer = "1"
    static let thirdAnswer = "2"
    static let answer = "answer"
}

class Question: NSObject {
    
    var question: String?
    var firstAnswer: String?
    var secondAnswer: String?
    var thirdAnswer: String?
    var answer: Int?
    
    init?(dictionary: [String: AnyObject]) {
        guard let question = dictionary[QuestionKey.question] as? String, let firstAnswer = dictionary[QuestionKey.firstAnswer] as? String, let secondAnswer = dictionary[QuestionKey.secondAnswer] as? String, let thirdAnswer = dictionary[QuestionKey.thirdAnswer] as? String, let answer = dictionary[QuestionKey.answer] as? Int else { return nil }
        
        self.question = question
        self.firstAnswer = firstAnswer
        self.secondAnswer = secondAnswer
        self.thirdAnswer = thirdAnswer
        self.answer = answer
    }
}
