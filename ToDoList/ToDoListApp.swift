//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Vipin Saini on 27/04/22.
//

import SwiftUI
import RealmSwift

@main
struct ToDoListApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.realmConfiguration, Realm.Configuration( /* ... */ ))
        }
    }
}
