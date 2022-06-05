//
//  AddButtonView.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import SwiftUI

struct AddButtonView: View {
    @Environment(\.colorScheme) var colorScheme

    var buttonSize: CGSize = .init(width: 56, height: 56)

    var imageName: String = "plus"

    var handler: () -> Void

    var body: some View {
        Button(action: {
            handler()
        }) {
            Image(systemName: imageName)
                .resizable()
                .font(.system(size: 17, weight: .bold, design: .default))
                .padding(EdgeInsets(top: 18, leading: 18, bottom: 18, trailing: 18))
                .foregroundColor(.white)
                .background(.pink)
                .frame(width: buttonSize.width, height: buttonSize.height, alignment: .center)
                .clipShape(Circle())
                .shadow(color: colorScheme == .dark ? .clear : Color.gray, radius: 2, y: 2)
        }
    }
}

struct AddButtonView_Previews: PreviewProvider {
    static var previews: some View {
        return AddButtonView(handler: {})
    }
}
