//
//  SwipeView.swift
//  Checkd
//
//  Created by Josh R on 6/6/22.
//

import SwiftUI

/// A type representing the style of a `SwipeView`.
enum SwipeViewType {
    case edit
    case delete
}

/// A  reusable`View`to use for `List` swipe actions.
struct SwipeView: View {

    /// The action of the button.
    var action: () -> Void

    /// The type of `SwipeView`to create.
    let swipeViewType: SwipeViewType

    var body: some View {
        Button { action() } label: { icon }.tint(tintColor)
    }

    /// The background color of a `SwipeView`.
    var tintColor: Color {
        switch swipeViewType {
        case .edit:
            return Color.orange
        case .delete:
            return Color.red
        }
    }

    /// The icon of a `SwipeView`.
    var icon: Image {
        switch swipeViewType {
        case .edit:
            return Image(systemName: "pencil")
        case .delete:
            return Image(systemName: "trash")
        }
    }
}
