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
        VStack(spacing: 10) {
            EnterTodoView(enteredText: $viewModel.enteredText) {
                viewModel.addTodo()
            }
            List {
                ForEach(viewModel.todos, id: \.id) { todo in
                    TodoRow(todo: todo) {
                        viewModel.toggleTodoStatus(todo: todo)
                    }
                }.onDelete { indexSet in
                    viewModel.deleteTodo(at: indexSet)
                }
            }
            .listStyle(.insetGrouped)
        }.onAppear {
            viewModel.fetchTodos()
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
}

struct EnterTodoView: View {
    @Binding var enteredText: String

    var action: () -> Void

    var body: some View {
        HStack {
            TextField("Enter a todo", text: $enteredText)
                .textFieldStyle(.roundedBorder)
                .padding()
                .frame(maxWidth: .infinity)
            Button(action: {
                withAnimation { action() }
            }, label: {
                Text("Add")
                    .frame(width: 75, height: 50, alignment: .center)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .foregroundColor(.white)
                    .background(.pink)
                    .clipShape(Capsule())
            })
        }.padding(.trailing)
    }
}

struct TodoRow: View {
    let todo: TodoEntity

    var action: () -> Void

    var body: some View {
        HStack {
            Button { action() } label: {
                Label {
                    Text(todo.name ?? "")
                        .foregroundColor(.primary)
                        .strikethrough(todo.isCompleted, color: .red)
                } icon: {
                    Image(systemName: "circle")
                }
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodoListView(
                viewModel: TodoListViewViewModel(list: .sampleList())
            ).navigationTitle("Todo")
        }
    }
}
