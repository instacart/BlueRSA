//
//  CryptorRSADigest.swift
//  CryptorRSA
//
//  Created by Bill Abt on 1/18/17.
//
//
// 	Licensed under the Apache License, Version 2.0 (the "License");
// 	you may not use this file except in compliance with the License.
// 	You may obtain a copy of the License at
//
// 	http://www.apache.org/licenses/LICENSE-2.0
//
// 	Unless required by applicable law or agreed to in writing, software
// 	distributed under the License is distributed on an "AS IS" BASIS,
// 	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 	See the License for the specific language governing permissions and
// 	limitations under the License.
//

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
	import CommonCrypto
#elseif os(Linux)
	import OpenSSL
	typealias CC_LONG = size_t
#endif

import Foundation

public extension Data {
	
	///
	/// Enumerates available Digest algorithms
	///
	public enum Algorithm {
		
		/// Message Digest 2 See: http://en.wikipedia.org/wiki/MD2_(cryptography)
		case md2
		
		/// Message Digest 4
		case md4
		
		/// Message Digest 5
		case md5
		
		/// Secure Hash Algorithm 1
		case sha1
		
		/// Secure Hash Algorithm 2 224-bit
		case sha224
		
		/// Secure Hash Algorithm 2 256-bit
		case sha256
		
		/// Secure Hash Algorithm 2 384-bit
		case sha384
		
		/// Secure Hash Algorithm 2 512-bit
		case sha512
		
		/// Digest Length
		public var length: CC_LONG {
			
			#if os(Linux)
				
				switch self {
					
				case .md2:
					fatalError("MD2 digest not supported by OpenSSL")
					
				case .md4:
					return CC_LONG(MD4_DIGEST_LENGTH)
					
				case .md5:
					return CC_LONG(MD5_DIGEST_LENGTH)
					
				case .sha1:
					return CC_LONG(SHA_DIGEST_LENGTH)
					
				case .sha224:
					return CC_LONG(SHA224_DIGEST_LENGTH)
					
				case .sha356:
					return CC_LONG(SHA256_DIGEST_LENGTH)
					
				case .sha384:
					return CC_LONG(SHA384_DIGEST_LENGTH)
					
				case .sha512:
					return CC_LONG(SHA512_DIGEST_LENGTH)
					
				}
				
			#else

				switch self {
				
				case .md2:
					return CC_LONG(CC_MD2_DIGEST_LENGTH)
					
				case .md4:
					return CC_LONG(CC_MD4_DIGEST_LENGTH)
					
				case .md5:
					return CC_LONG(CC_MD5_DIGEST_LENGTH)
					
				case .sha1:
					return CC_LONG(CC_SHA1_DIGEST_LENGTH)
					
				case .sha224:
					return CC_LONG(CC_SHA224_DIGEST_LENGTH)
					
				case .sha256:
					return CC_LONG(CC_SHA256_DIGEST_LENGTH)
					
				case .sha384:
					return CC_LONG(CC_SHA384_DIGEST_LENGTH)
					
				case .sha512:
					return CC_LONG(CC_SHA512_DIGEST_LENGTH)
					
				}

			#endif
		}
		
		public var engine: (_ data: UnsafeRawPointer, _ len: CC_LONG, _ md: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>! {
			
			#if os(Linux)
				
				switch self {
					
				case .md2:
					fatalError("MD2 digest not supported by OpenSSL")
					
				case .md4:
					return MD4
					
				case .md5:
					return MD5
					
				case .sha1:
					return SHA1
					
				case .sha224:
					return SHA224
					
				case .sha356:
					return SHA256
					
				case .sha384:
					return SHA384
					
				case .sha512:
					return SHA512
					
				}
				
			#else
				
				switch self {
					
				case .md2:
					return CC_MD2
					
				case .md4:
					return CC_MD4
					
				case .md5:
					return CC_MD5
					
				case .sha1:
					return CC_SHA1
					
				case .sha224:
					return CC_SHA224
					
				case .sha256:
					return CC_SHA256
					
				case .sha384:
					return CC_SHA384
					
				case .sha512:
					return CC_SHA512
					
				}
				
			#endif
		}
	}
	
	///
	/// Return a digest of the data based on the alogorithm selected.
	///
	/// - Parameters:
	///		- alogorithm:		The digest `Alogorithm` to use.
	///
	/// - Returns:				`Data` containing the data in digest form.
	///
	public func digest(using alogorithm: Algorithm) throws -> Data {

		var hash = [UInt8](repeating: 0, count: Int(alogorithm.length))
		
		self.withUnsafeBytes {
			
			_ = alogorithm.engine($0, CC_LONG(self.count), &hash)
		}
		
		return Data(bytes: hash)
	}
}