//
//  FavouriteView.swift
//  TummocShopping
//
//  Created by Rishabh Sharma(Personal) on 24/01/24.
//

import SwiftUI

struct FavouriteView: View {
    @StateObject var viewModel = FavouriteViewModel()
    
    var body: some View {
        VStack {
            FavouriteHeaderView()
            ScrollView {
                LazyVStack(spacing: 20,content: {
                    ForEach(viewModel.favList, id: \.self) { item in
                        FavouriteCellView(item: item, viewModel: viewModel)
                    }
                })
                .padding(.vertical)
            }
            Spacer()
        }
        .onAppear() {
            viewModel.getFavList()
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarHidden(true)
        .navigationTitle("")
        .toolbar(.hidden)
    }
}

#Preview {
    FavouriteView()
}

struct FavouriteHeaderView: View {
    @Environment(\.dismiss) var dismiss
    var title = "Favourite"
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 15,height: 25)
                })
                .buttonStyle(.plain)
                Spacer()
            }
            Text(title)
                .font(.system(size: 28))
                .bold()
        }
        .padding(20)
    }
}

struct FavouriteCellView: View {
    var item : ItemsEntity?
    @ObservedObject var viewModel: FavouriteViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: item?.icon ?? ""), scale: 1) { image in
                image
                    .resizable()
                    .frame(width: 80)
                    .padding(20)
                
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 80)
                    .padding(20)
            }
            VStack(alignment: .leading) {
                Text(item?.name ?? "")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                Spacer()
                Text("₹" + String(format: "%.2f", item?.price ?? 1.0))
                    .font(.system(size: 14))
            }
            .padding(.vertical,20)
            Spacer()
            VStack {
                Button(action: {
                    viewModel.updateItemMakeFavourite(item: item ?? ItemsEntity())
                }, label: {
                    Image(systemName: item?.isFavourite ?? false ? "heart.fill" : "heart")
                        .resizable()
                        .foregroundColor(item?.isFavourite ?? false ? .red : .black)
                        .frame(width: 15,height: 15)
                })
                .buttonStyle(.plain)
                Spacer()
                Button(action: {
                }, label: {
                    Image(systemName: "plus.app.fill")
                        .resizable()
                        .frame(width: 25,height: 25)
                        .foregroundColor(.orange)
                })
            }
            .buttonStyle(.plain)
            .padding(.vertical,20)
            .padding(.horizontal)
        }
        .background(.white)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: .gray.opacity(0.2), radius: 10,x: 5,y: 5)
        .frame(height: 100)
        .padding(.horizontal,20)
    }
}
