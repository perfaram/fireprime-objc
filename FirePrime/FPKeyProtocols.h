//
//  FPKeyProtocols.h
//  FirePrime
//
//  Created by Perceval FARAMAZ on 28.06.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FPKey

/**
 Initializes & returns a new instance of FPKey, using the given hex string. Passing a string of an odd length, or containing non-hex chars will have this function return `nil`.
 */
-(nullable instancetype) initWithKey:(nonnull NSString*)string;

/**
 Initializes & returns a new instance of FPKey, using the `NSData` object's bytes.
 
 @discussion The bytes contained in the passed `data` NSData instance WILL be copied.
 */
-(nullable instancetype) initWithData:(nonnull NSData*)data;

/**
 Initializes & returns a new instance of FPKey, using the `buffer` char-array, of which length is `size`. This buffer may or may not be copied inside the instance, depending of the `copy` flag.
 
 @discussion If you pass YES for `copy`, you may safely free the buffer you passed (this method won't do it for you). HOWEVER, if you choose NOT to copy, it is YOUR responsibility to ensure that the `buffer` will not be freed for the newly created instance's lifetime ; and because the inner workings of FPKey make the assumption that the buffer exists, bad things will happen.
 */
-(nullable instancetype) initWithBuffer:(nonnull unsigned char *)buffer ofLength:(size_t)size copying:(BOOL)copy;

/**
 The expected length for the current type of key
 */
+(NSUInteger) keyLength;

/**
 The actual length of the inner buffer
 */
-(NSUInteger) length;

/**
 Creates and returns an hex representation of the key, wrapped in a NSString, of which length is -length * 2
 */
-(nonnull NSString*) asString;

/**
 Returns a pointer to the key's byte buffer (the actual key)
 
 @discussion The pointer is only guaranteed to be valid for the lifetime of this instance. If you need to retain it after this instance's deallocation, then use -copyToBuffer:.
 */
-(nonnull unsigned const char*) buffer NS_RETURNS_INNER_POINTER;

/**
 Copies the key bytes to the passed `buffer`.
 
 @discussion It's up to you to allocate memory first, and then to release it.
 */
-(void) copyToBuffer:(nonnull unsigned char *)buffer;

/**
 Initializes a NSData object wrapping this instance's inner byte buffer (the actual key), without copying it (that is, the NSData and this instance will both have a reference to the same array)
 
 @discussion However, the returned NSData only maintains a weak relationship with the array, thus, releasing the NSData object won't destroy the bytes kept inside this instance. CAREFUL however : the NSData MAY NOT outlive this instance, at it means that its inner pointer to the byte buffer would be stale.
 */
-(nonnull NSData*) data;

/**
 Initializes a NSData object from this instance's inner byte buffer, copying it.
 
 @discussion Safer than -data, because contrary to it, the returned NSData may outlive this instance. They are completely independent.
 */
-(nonnull NSData*) copyData;
@end

@protocol FPKeyPublic <FPKey>

@end

@protocol FPKeySecret <FPKey> //inherits from the public key protocol for it only contains general-purpose methods (serialization, un-serialization)
/**
 Compute the public key matching `self` secret key – except if already done, then return the previously computed key.
 */
-(nonnull id<FPKeyPublic>) publicKey;

/**
 Generate a secret key from the system's RNG.
 */
+(nullable instancetype) generateKey;
@end