//
//  IntentHandler.swift
//  TimePieceWidgetIntent
//
//  Created by Alexey Primechaev on 2/13/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {

    


    
    func provideTimeItemOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<IntentTimeItem>?, Error?) -> Void) {
            
        
            print("here now")
            let context = PersistenceController.shared.container.viewContext
            let request = TimeItem.getAllTimeItems()

            var results = [TimeItem]()

            do { results = try context.fetch(request) }
            catch let error as NSError {print("error")}

            let items: [IntentTimeItem] = results.map { result in
                        let intentTimeItem = IntentTimeItem(
                            identifier: result.notificationIdentifier.uuidString,
                            display: result.title
                        )
                        intentTimeItem.name = result.title
                        intentTimeItem.totalTime = result.totalTimeString
                        return intentTimeItem
            }





            // Create a collection with the array of characters.
            let collection = INObjectCollection(items: items)

            // Call the completion handler, passing the collection.
            completion(collection, nil)


        }
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
