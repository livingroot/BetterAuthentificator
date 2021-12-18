//
//  extensions.swift
//  BetterAuthenticator
//
//  Created by Alex Lanser on 18.12.2021.
//

import SwiftUI


extension View {
    public func gradientForeground(_ colors: [Color], _ progress:Double = 0.5) -> some View {
		
        self.overlay(LinearGradient(gradient: .init(colors: colors),
									startPoint: UnitPoint(x: CGFloat(progress), y: 1),
                                    endPoint: UnitPoint(x: 1, y: 1)))
            .mask(self)
    }
}

extension String {
    func group(_ groupSize : Int, divider: String = " ") -> String {
        let groups = self.reduce([]) { (acc, c) -> [String] in
            if let last = acc.last, last.count < groupSize {
                var result = acc.dropLast()
                result.append(last.appending(String(c)))
                return Array(result)
            } else {
                var result = acc
                result.append(String(c))
                return result
            }
        }
        return groups.joined(separator: divider)
    }
}
