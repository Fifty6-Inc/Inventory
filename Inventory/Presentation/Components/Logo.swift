//
//  Logo.swift
//  Inventory
//
//  Created by Mikael Weiss on 8/3/21.
//  Copyright © 2021 Fifty6 Incorporated. All rights reserved.
//

import SwiftUI

struct Logo: View {
    var body: some View {
        Circle()
            .fill(Color.appTintColor)
            .frame(width: 37, height: 37)
            .inverseMask {
                Text("I")
                    .font(Font(name: "CourierNewPS-BoldMT", size: 26))
                    .offset(y: 1)
            }
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}
