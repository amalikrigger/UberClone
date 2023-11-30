//
//  LocationSearchView.swift
//  UberClone
//
//  Created by Amali Krigger on 10/12/23.
//

import SwiftUI

struct LocationSearchView: View {
  @State private var startLocationText = ""
  @EnvironmentObject var viewModel: HomeViewModel
    
  var body: some View {
    VStack {
      HStack {
        VStack {
          Circle()
            .fill(Color(.systemGray3))
            .frame(width: 6, height: 6)
          Rectangle()
            .fill(Color(.systemGray3))
            .frame(width: 1, height: 24)
          Rectangle()
            .fill(Color(.black))
            .frame(width: 6, height: 6)
        }

        VStack {
          TextField("Current Location", text: $startLocationText).frame(height: 32).background(
            Color(.systemGroupedBackground)
          )
          .padding(.trailing)

          TextField("Where to", text: $viewModel.queryFragment).frame(height: 32).background(
            Color(.systemGray4)
          )
          .padding(.trailing)
        }
      }.padding(.horizontal).padding(.top, 64)
      Divider().padding(.vertical)
        LocationSearchResultsView(viewModel: viewModel, config: .ride)
    }
    .background(Color.theme.backgroundColor)
    .background(.white)
  }
}

#Preview {
  LocationSearchView()
}
