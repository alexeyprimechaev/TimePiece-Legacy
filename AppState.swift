//
//  AppState.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 12/21/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import Foundation

public class AppState: ObservableObject {
    
    @Published var isInEditing: Bool = false
    @Published var selectedValues: [TimeItem] = []
    @Published var selectedTimeItem = TimeItem()
    @Published var newTimeItem = TimeItem()
    @Published var showingSheet = false
    @Published var showingSidebar = false
    @Published var activeSheet = 2
    
}
