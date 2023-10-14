//
//  Color.swift
//  UberClone
//
//  Created by Amali Krigger on 10/14/23.
//

import Foundation
import SwiftUI

extension Color {
  static let theme = ColorTheme()
}

struct ColorTheme {
  let backgroundColor = Color("BackgroundColor")
  let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
  let primaryTextColor = Color("PrimaryTextColor")
}
