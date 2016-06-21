//
//  FPKey.m
//  FirePrime
//
//  Created by Perceval FARAMAZ on 29.05.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import "FPKey.h"
#include "sodium.h"

@interface FPKeyPublic () {
    unsigned char* key;
    NSUInteger length;
}
@end


@implementation FPKeyPublic
+(NSUInteger) keyLength {
    return crypto_sign_PUBLICKEYBYTES;
}

-(instancetype) initWithKey:(NSString *)string {
    self = [super init];
    if (self) {
        if (sodium_init() == -1)
            return nil;
        if ((string.length != [self.class keyLength]*2))
            return nil;
        NSCharacterSet *chars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"] invertedSet];
        BOOL isValid = (NSNotFound == [string rangeOfCharacterFromSet:chars].location);
        if (!isValid)
            return nil;
        
        length = string.length/2;
        sodium_hex2bin(key, length, string.UTF8String, length * 2, NULL, NULL, NULL);
    }
    return self;
}

-(instancetype) initWithData:(NSData*)data {//will copy NSData
    self = [super init];
    if (self) {
        if (sodium_init() == -1)
            return nil;
        length = data.length;
        key = malloc(length);
        memcpy(key, data.bytes, length);
    }
    return self;
}

-(instancetype) initWithBuffer:(unsigned char *)buffer ofLength:(size_t)size copying:(BOOL)copy {
    self = [super init];
    if (self) {
        if (sodium_init() == -1)
            return nil;
        if (copy) {
            length = size;
            key = malloc(size);
            memcpy(key, buffer, size);
        } else {
            length = size;
            key = buffer;
        }
    }
    return self;
}

-(NSString*) asString {
    char hex[length*2];
    sodium_bin2hex(hex, length*2, key, length);
    return [NSString.alloc initWithUTF8String:hex];
}

-(NSUInteger) length {
    return length;
}

-(unsigned const char*) buffer {
    return key;
}

-(void) copyToBuffer:(unsigned char *)buffer {
    memcpy(buffer, key, length);
}

-(NSData*) data {
    return [NSData dataWithBytesNoCopy:key length:length];
}

-(NSData*) copyData {
    return [NSData dataWithBytes:key length:length];
}

-(void) dealloc {
    sodium_memzero(key, length);
    free(key);
}
@end



@interface FPKeySecret() {
    FPKeyPublic* publicKey;
}
-(void) setPublicKey:(FPKeyPublic*)aKey;
@end

@implementation FPKeySecret
+(NSUInteger) keyLength {
    return crypto_sign_SECRETKEYBYTES;
}

-(FPKeyPublic*) publicKey {
    if (publicKey)
        return publicKey;
    
    unsigned char seed[crypto_sign_SEEDBYTES];
    unsigned char ed25519_pk[crypto_sign_PUBLICKEYBYTES];
    
    // COMPUTE ED25519 PUBLIC KEY, REQUIRES ESTABLISHING A SEED
    crypto_sign_ed25519_sk_to_seed(seed, self.buffer);
    crypto_sign_seed_keypair(ed25519_pk, (unsigned char*)self.buffer, seed);
    publicKey = [FPKeyPublic.alloc initWithBuffer:ed25519_pk ofLength:crypto_sign_PUBLICKEYBYTES copying:true];
    return publicKey;
}

-(void) setPublicKey:(FPKeyPublic *)aKey {
    publicKey = aKey;
}

+(instancetype) generateKey {
    if (sodium_init() == -1)
        return nil;
    unsigned char pk[crypto_sign_PUBLICKEYBYTES];
    unsigned char sk[crypto_sign_SECRETKEYBYTES];
    int res = crypto_sign_keypair(pk, sk);
    FPKeySecret* secret = [FPKeySecret.alloc initWithBuffer:sk ofLength:crypto_sign_SECRETKEYBYTES copying:true];
    FPKeyPublic* public = [FPKeyPublic.alloc initWithBuffer:pk ofLength:crypto_sign_PUBLICKEYBYTES copying:true];
    secret.publicKey = public;
    return secret;
}

@end
