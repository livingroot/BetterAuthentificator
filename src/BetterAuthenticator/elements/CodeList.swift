//
//  CodeView.swift
//  BetterAuthenticator
//
//  Created by Alex Lanser on 18.12.2021.
//

import SwiftUI
struct codeList: View{
	var tokens:[tokenst];
	var expire:Double;
	var editmode:Bool;
	@Binding var copymsgshow:Bool;
	
	var body: some View{
		List{
			ForEach(tokens){ token in
				codeRow(token: token, editmode: editmode, expired: expire)
				//.listRowSeparator(.hidden)
				.onTapGesture {
					//self.action(false)
					if(editmode) { return; }
					UIPasteboard.general.string = token.code;
					if(!copymsgshow){
						copymsgshow = true;
						Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { ttt in
							copymsgshow = false;
							ttt.invalidate();
						}
					}
				}
			} //onMove
		}.listStyle(PlainListStyle())
	}
}

struct codeRow: View{
	var token:tokenst;
	var editmode:Bool;
	var expired:Double;
	
	var body: some View{
		VStack {
			if(!editmode){
				codeView(code: token.code, progress: expired)
			} else {
				HStack{
					NavigationLink(
						destination: EditView(tokenid: token.id, label: token.name)
					){
						Text(token.code.group(3))
					}.font(.system(size: 42))
					Spacer()
				}
			}
			if(token.name.count > 0){
				Text(token.name)
					.font(.footnote)
					.foregroundColor(Color.gray)
			}
		}.frame(maxWidth: .infinity)
	}
}
