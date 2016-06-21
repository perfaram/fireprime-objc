//
//  FPKey.h
//  FirePrime
//
//  Created by Perceval FARAMAZ on 29.05.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPKeyPublic : NSObject
/**
 Initializes & returns a new instance of FPKey, using the given hex string, whose length must be either XX or XX (denoting whether FPKey is a private or a public key). Passing a string of any other length, or containing non-hex chars will have this function return `nil`.
 */
-(nullable instancetype) initWithKey:(nonnull NSString*)string;

/**
 Initializes & returns a new instance of FPKey, using the `buffer` char-array, of which length is `size`. This buffer may or may not be copied inside the instance, depending of the `copy` flag.
 
 @discussion If you pass YES for `copy`, you may safely free the buffer you passed (this method won't do it for you). HOWEVER, if you choose NOT to copy, it is YOUR responsibility to ensure that the `buffer` will not be freed for the newly created instance's lifetime ; and because the inner workings of FPKey make the assumption that the buffer exists, bad things will happen.
 */
-(nullable instancetype) initWithBuffer:(unsigned char *)buffer ofLength:(size_t)size copying:(BOOL)copy;

-(NSUInteger) length;
-(nonnull NSString*) asString;
-(nonnull unsigned const char*) buffer;
-(void) copyToBuffer:(nonnull unsigned char *)buffer;
-(NSData*) data;
-(NSData*) copyData;
@end

@interface FPKeySecret : FPKeyPublic
-(nonnull FPKeyPublic*) publicKey;
+(nullable instancetype) generateKey;
@end