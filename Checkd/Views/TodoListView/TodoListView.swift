//
//  TodoListView.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import CoreData
import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel: TodoListViewViewModel

    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.todos, id: \.id) { todo in
                    TodoRow(todo: todo)
                }.onDelete { indexSet in
                    viewModel.deleteTodo(at: indexSet)
                }
            }
            .listStyle(.insetGrouped)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
}

struct TodoRow: View {
    let todo: TodoEntity

    var body: some View {
        HStack {
            Label {
                Text(todo.name ?? "")
            } icon: {
                Image(systemName: "list.dash")
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodoListView(
                viewModel: TodoListViewViewModel(list: .sampleList())
            )
        }
    }
}
