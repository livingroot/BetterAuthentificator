//
//  ScannerView.swift
//  BetterAuthenticator
//
//  Created by livingroot on 15.06.2021.
//

import SwiftUI
import AVFoundation
import CodeScanner // maybe remove later

struct ScannerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	let tokensdb = storage.shared;
	
    var body: some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: { result in
                if case let .success(code) = result {
					tokensdb.addfromurl(url: URL(string: code)!)
					self.presentationMode.wrappedValue.dismiss()
                }
            }
        ).navigationBarTitleDisplayMode(.inline)
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
