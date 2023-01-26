//
//  codeView.swift
//  BetterAuthenticator
//
//  Created by Alex Lanser on 18.12.2021.
//

import SwiftUI


struct codeView: View{
	var code:String;
	var progress:Double;
	
	var body: some View{
		if(progress > 0.1){
			Text(code.group(3))
				.font(.system(size: 42))
				.gradientForeground([Color.green,Color.blue], progress - 0.2)
				.padding(.vertical, 1)
		} else {
			Text(code.group(3))
				.font(.system(size: 42))
				.foregroundColor(.red)
				.padding(.vertical, 1)
		}
	}
}
