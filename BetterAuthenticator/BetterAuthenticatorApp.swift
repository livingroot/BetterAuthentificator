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
