//
//  BetterAuthenticatorApp.swift
//  BetterAuthenticator
//
//  Created by livingroot on 15.06.2021.
//
// otpauth://totp/online-garant.net?secret=3NCJNEL37VERLFTL
// otpauth://TYPE/LABEL?PARAMETERS

import SwiftUI

@main
struct BetterAuthenticatorApp: App {
	@AppStorage("firstrun") private var firstrun = true;
    var body: some Scene {
        WindowGroup {
			#if os(iOS)
			if(firstrun){
				info().navigationBarHidden(true);
            } else {
				ContentView()
			}
			#else
				ContentView();
			#endif
			
        }
    }
}

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
