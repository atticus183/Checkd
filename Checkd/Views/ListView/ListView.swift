//
//  ContentView.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import CoreData
import SwiftUI

struct ListView: View {
    @StateObject var viewModel = ListViewViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.lists, id: \.id) { list in
                        NavigationLink(destination: Text("Todo View")) {
                            ListRow(list: list)
                        }
                    }.onDelete { indexSet in
                        viewModel.deleteList(at: indexSet)
                    }.onMove { indexSet, destination in
                        viewModel.moveList(from: indexSet, to: destination)
                    }

                }
                .listStyle(.insetGrouped)

                VStack {
                    Spacer()
                    AddButtonView {
                        withAnimation {
                            viewModel.addList(name: "List# \(viewModel.lists.count)")
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .navigationTitle("Lists")
        }.navigationViewStyle(StackNavigationViewStyle())   //fixes console errors
    }
}

struct ListRow: View {
    let list: ListEntity

    var body: some View {
        HStack {
            Label {
                Text(list.name ?? "")
            } icon: {
                Image(systemName: "list.dash")
            }
            Spacer()
            Text("\(list.todoCount)")

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListEntity.createForPreview()
        return ListView()
    }
}
