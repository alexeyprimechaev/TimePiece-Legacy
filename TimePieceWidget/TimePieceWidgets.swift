//
//  TimePieceWidgets.swift
//  TimePieceWidgetExtension
//
//  Created by Alexey Primechaev on 2/18/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct TimePieceWidgets: WidgetBundle {
    
    @WidgetBundleBuilder
    var body: some Widget {
        SingleTimeItemWidget()
        TimeItemGridWidget()
    }
    
}
