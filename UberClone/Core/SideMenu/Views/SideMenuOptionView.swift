//
//  SideMenuOptionView.swift
//  UberClone
//
//  Created by Amali Krigger on 11/15/23.
//

import SwiftUI

struct SideMenuOptionView: View {
    let viewModel: SideMenuOptionViewModel
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: viewModel.imageName)
                .font(.title2)
                .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
            
            Text(viewModel.title)
                .font(.system(size: 16, weight: .semibold))
            
            Spacer()
        }
        .foregroundColor(Color.theme.primaryTextColor)
    }
}

#Preview {
    SideMenuOptionView(viewModel: .trips)
}
