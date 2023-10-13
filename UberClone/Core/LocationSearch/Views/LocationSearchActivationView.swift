//
//  LocationSearchActivationView.swift
//  UberClone
//
//  Created by Amali Krigger on 10/12/23.
//

import SwiftUI

struct LocationSearchActivationView: View {
  var body: some View {
    HStack {
      Rectangle().fill(Color.black).frame(width: 8, height: 8).padding(.horizontal)

      Text("Where to?").foregroundColor(Color(.darkGray))

      Spacer()
    }
    .frame(width: UIScreen.main.bounds.width - 64, height: 50)
    .background(
      Rectangle()
        .fill(.white)
        .shadow(color: .black, radius: 6))
  }
}

#Preview {
  LocationSearchActivationView()
}
