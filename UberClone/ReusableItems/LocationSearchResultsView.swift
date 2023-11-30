//
//  LocationSearchResultsView.swift
//  UberClone
//
//  Created by Amali Krigger on 11/22/23.
//

import SwiftUI

struct LocationSearchResultsView: View {
    @StateObject var viewModel: HomeViewModel
    let config: LocationResultsViewConfig
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.results, id: \.self) { result in
                    LocationSearchResultsCell(title: result.title, subTitle: result.subtitle).onTapGesture {
                        withAnimation(.spring()) {
                            viewModel.selectLocation(result, config: config)
                        }
                    }
                }
            }
        }
    }
}


