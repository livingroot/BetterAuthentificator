//
//  totp.swift
//  BetterAuthenticator
//
//  Created by livingroot on 19.06.2021.
//

import Foundation
import Base32
import CommonCrypto

class otp {
	
	func gen(_ token:String) -> String{
		
		let timeSlice = UInt64(bigEndian: UInt64(Date().timeIntervalSince1970) / 30);
		
		var secretKey:[UInt8]? = Base32.base32Decode(token);
		if(secretKey == nil) {
			secretKey = [UInt8(0)];
			//return "";
		}
		
		let time:Data = withUnsafeBytes(of: timeSlice) { Data($0) };
		
		let hash = self.hmac(hashName: "SHA1", message: time, key: Data(secretKey!))
		
		let offset = hash[hash.count - 1] & 0x0F;
		
		let hashpart = hash[offset...offset+3]
		
		//print("offset:\(offset) timeslice: \((Date().timeIntervalSince1970/30))\nhashpart: \(hashpart.hexEncodedString())");
		
		let value = UInt32(bigEndian: hashpart.withUnsafeBytes {
			$0.pointee
		})
		let code = value & 0x7FFFFFFF;
		
		let out = code % 1000000;
		
		return String(out).padLeft(length: 6, pad: "0");
	}
	func hmac(hashName:String, message:Data, key:Data) -> Data {
		let algos = ["SHA1":   (kCCHmacAlgSHA1,   CC_SHA1_DIGEST_LENGTH),
					 "MD5":    (kCCHmacAlgMD5,    CC_MD5_DIGEST_LENGTH),
					 "SHA224": (kCCHmacAlgSHA224, CC_SHA224_DIGEST_LENGTH),
					 "SHA256": (kCCHmacAlgSHA256, CC_SHA256_DIGEST_LENGTH),
					 "SHA384": (kCCHmacAlgSHA384, CC_SHA384_DIGEST_LENGTH),
					 "SHA512": (kCCHmacAlgSHA512, CC_SHA512_DIGEST_LENGTH)]
		guard let (hashAlgorithm, length) = algos[hashName]  else { return Data(count: 0); }
		var macData = Data(count: Int(length))

		macData.withUnsafeMutableBytes { macBytes in
			message.withUnsafeBytes { messageBytes in
				key.withUnsafeBytes { keyBytes in
					CCHmac(CCHmacAlgorithm(hashAlgorithm),
						   keyBytes,     key.count,
						   messageBytes, message.count,
						   macBytes)
				}
			}
		}
		return macData
	}
}
extension String{
	func padLeft(length:Int, pad:String) -> String{
		var out:String = self;
		while(out.count < length){
			out = pad+out;
		}
		return out;
	}
}
/*
extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}
*/
