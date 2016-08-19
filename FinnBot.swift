//
//  FinnBot.swift
//  FinputTest
//
//  Created by Benjamin Lim on 26/07/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import Foundation
import UIKit


// Finn, your personal financial assistant

extension FinController {

    
    // BOT - START //
    func check () -> String {
        
        let message = messages?.last
        let sentence = message!.text!.lowercaseString.splitWords()
        
        
        func taxes() -> Bool {
            let tax = ["tax", "taxes", "taxs", "taxation", "taxations","income"]
            
            for taxes in tax {
                if sentence.contains(taxes) {
                    return true
                }
            }
            return false
        }
        
        // TaxReply start
        func taxReply() -> String {
            
            func reply() -> String  {
                if sentence.contains("income") {
                    return "Of course, what is your annual income?"
                } else if sentence.contains("help") {
                    return "What about your tax do you need help with?"
                }
                return "What about tax do you need help with?"
            }
            
            if isHello() == true {
                return helloReply()+" "+reply()
            }
            return reply()
        }
        
        
        // Retort to inputs we are not sure of
        func NotSure() -> String {
            let array1 = ["I'm not too sure what you're talking about, you're going to have to be a little more specific.", "Could you rephrase that in something I could understand?", "I'm struggling to comprehend what you're trying to say.", "Hmm.. I don't really understand what you're trying to say."]
            
            let somethingElse = ["Perhaps try asking me something else!", "Your question has to be related to  your finances ya know?", "Are you sure you're not speaking gibberish?", "Yep, I have no clue what you're saying!"]
            
            let random1 = Int(arc4random_uniform(3))
            let random2 = Int(arc4random_uniform(3))
            
            return array1[random1]+" "+somethingElse[random2]
        }
        
        // Checking for offensive words
        func swearWords() -> Bool {
            let swearWord = ["fuck", "cunt", "motherfucker", "motherfuck", "shit", "dick", "pussy", "fucker", "fucking", "cock", "cocksucker", "fuckface"]
            
            for word in swearWord {
                if sentence.contains(word){
                    return true
                }
            }
            return false
        }
        
        // Retort to offensive words
        func swearReply() -> String {
            let swearReply = ["Do kindly watch your language, there are kids around here.", "Please refrain from using that kind of language with me.", "I would prefer if you didn't use language like that.", "None of that kind of talk around here.", "I would appreciate if you spoke to me with a little more respect", "That's not very nice :/"]
            let random1 = Int(arc4random_uniform(5))
            return swearReply[random1]
        }
        
        // Checking for Hello!
        func isHello() -> Bool {
            let hello = ["hey", "hello", "hi", "heey", "heeey", "helo", "hellooo", "helloo", "heyy", "heyyy","eyyy", "ey", "eyy", "sup"]
            let whatsUp = ["whats", "up"]
            for word in hello {
                if sentence.contains(word) {
                    return true
                } else if Set(sentence).isSupersetOf(whatsUp) {
                    return true
                } else if howAreYou() == true{
                    return true
                }
            }
            return false
        }
        
        //Retorts to Hello
        func helloReply() -> String {
            let helloReply = ["Hey there!", "Hello there!", "Heyhey buddy!", "Hello, my human friend!"]
            
            let iAmWell = ["I'm very well, thanks!", "I'm doing splendid! Thanks for asking.", "I'm feeling great! Cheers for asking!", "I'm feeling quite well! Thanks for asking!"]
            
            let random1 = Int(arc4random_uniform(3))
            
            let random3 = Int(arc4random_uniform(3))
            
            if howAreYou() == true {
                return helloReply[random1]+" "+iAmWell[random3]
            }
            return helloReply[random1]
            
        }
        
        // How can I help you?
        func needHelp() -> String {
            let helpReply = ["How can I help you?", "What can I do for you today?", "How may I be of assistance to you today?", "What would you like me to help you with?"]
            
            let random2 = Int(arc4random_uniform(3))
            
            return helpReply[random2]
        }
        // Checks to see if user is asking how are you
        func howAreYou() -> Bool {
            
            let how = ["how", "howw"]
            let are = ["are", "r", "aree"]
            let you = ["you","u", "youu", "ya","doin", "doing", "going", "yaa"]
            
            for hows in how {
                if sentence.contains(hows) {
                    for ares in are  {
                        if sentence.contains(ares) {
                            for yous in you {
                                if sentence.contains(yous) {
                                    return true } } } } }
            }
            return false
        }
        
        func isSuper() -> Bool {
            let superKeys = ["superannuation", "super", "superfund"]
            
            for superKey in superKeys {
                if sentence.contains(superKey) {
                    return true
                }
            }
            return false
        }
        
        func superReply() -> String {
            return "So you need help with your superannuation?"
        }
        

        // conditions
        if swearWords() == true{
            return swearReply()
        } else if taxes() == true {
            return taxReply()
        } else if isHello() == true {
            return helloReply()+" "+needHelp()
        } else if isSuper() == true {
            return superReply()
        }
        return NotSure()
        
    }
    // BOT -- END //


}


    
    