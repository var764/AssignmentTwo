//
//  OnboardingSurvey.swift
//  CardinalKit_Example
//
//  Created by Varun on 1/31/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import ResearchKit

struct OnboardingSurvey {
    static let onboardingSurvey: ORKNavigableOrderedTask = {
        var steps = [ORKStep]()
    
        let instruction = ORKInstructionStep(identifier: "Patient Onboarding Intro")
        instruction.title = "Patient Onboarding Survey"
        instruction.text = "Patient Onboarding"
    
        steps += [instruction]
    
        //1: DOB
    
        let dobAnswerFormat = ORKDateAnswerFormat.dateAnswerFormat()
        let dob = ORKFormItem(identifier: "DOB", text: "What is your date of birth?", answerFormat: dobAnswerFormat)
    
        //2: Gender
    
        let genderChoices = [
            ORKTextChoice(text: "Male", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Female", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Other", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let genderChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: genderChoices)
        
        let gender = ORKFormItem(identifier: "Gender", text: "What is your gender?", answerFormat: genderChoiceAnswerFormat)
        
        //3: Smoking Status
        
        let smokingStatusChoices = [
            ORKTextChoice(text: "Current Smoker", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Prior Smoker", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Never Smoked", value: 2 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        
        let smokingStatusAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: smokingStatusChoices)
        
        let smokingStatus = ORKFormItem(identifier: "SmokingStatus", text: "What is your smoking status?", answerFormat: smokingStatusAnswerFormat)
        
        //Form Aggregation
        
        let form = ORKFormStep(identifier: "Form", title: "Patient Onboarding", text: "Patient Onboarding")
        form.formItems = [dob, gender, smokingStatus]
        steps += [form]
        
        //4: Planned Surgery Status
        
        let plannedSurgery = ORKQuestionStep(identifier:"PlannedSurgery", title:nil, question: "Do you have a planned surgery?", answer: ORKBooleanAnswerFormat(yesString: "Yes", noString: "No"))
            //ORKFormItem(identifier:"PlannedSurgery", text: "Do you have a planned surgery?", answerFormat: ORKAnswerFormat.booleanAnswerFormat())

        steps += [plannedSurgery]
        
        //5: Upcoming Procedure
        
        let procedureChoices = [
            ORKTextChoice(text: "Open / Hybrid Vascular Procedure", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Endovascular Procedure", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Open Colorectal Surgery", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Laparoscopic Colorectal Surgery", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Hepatectomy", value: 4 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pancreatectomy", value: 5 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Pancreatoduodenectomy", value: 6 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoiceOther.choice(withText: "Other", detailText: "Additional Info", value: 7 as NSCoding & NSCopying & NSObjectProtocol, exclusive: false, textViewPlaceholderText: "")
        ]
        
        let upcomingProcedureAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: procedureChoices)
        
        let upcomingProcedure = ORKQuestionStep(identifier: "UpcomingProcedure", title: nil, question: "What type of procedure is being planned?", answer: upcomingProcedureAnswerFormat)
        
        steps += [upcomingProcedure]
        
        //6: Completion
        
        let summary = ORKCompletionStep(identifier:"Summary")
        summary.title = "Thank you for completing the survey."
        summary.text = "We appreciate your input."
    
        steps += [summary]
        
        
        //Configure conditional for Questions 4 & 5
        var task = ORKNavigableOrderedTask(identifier: "OnboardingTask", steps: steps)
        
        let resultSelector: ORKResultSelector = ORKResultSelector(resultIdentifier: plannedSurgery.identifier)
        let predicate = ORKResultPredicate.predicateForBooleanQuestionResult(with: resultSelector, expectedAnswer: false)
        let navRule = ORKPredicateSkipStepNavigationRule(resultPredicate: predicate)
        
        task.setSkip(navRule, forStepIdentifier: upcomingProcedure.identifier)
        
        return task
    
    }()
}
