//
//  LogoEasterEgg.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/19/21.
//

import SwiftUI

struct LogoEasterEgg: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Text("Hi! You found me!")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
            
            StandardButton(title: "Nice!", action: dismiss)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal)
        }
    }
    
    // MARK: - Interacting
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct LogoEasterEgg_Previews: PreviewProvider {
    static var previews: some View {
        LogoEasterEgg()
    }
}
