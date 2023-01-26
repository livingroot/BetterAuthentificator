//
//  misc.swift
//  BetterAuthenticator
//
//  Created by Alex Lanser on 19.12.2021.
//

import Foundation
import StoreKit

public func askReview(){
	print("Review ask")
	if let scene = UIApplication.shared.connectedScenes.first(where: { _ in true }) as? UIWindowScene {
		SKStoreReviewController.requestReview(in: scene)
	}
}
