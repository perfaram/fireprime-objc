//
//  FPLicenseChecker.h
//  FirePrime
//
//  Created by Perceval FARAMAZ on 29.05.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FPKeyPublic;
@class FPLicenseInformations;

/**
 A singleton object holding the license registered.
 */
@interface FPLicenseChecker : NSObject {
    FPKeyPublic* publicKey;
}
@property NSArray<NSString*>*__nullable blacklist;
- (nullable instancetype) initWithPublicKey:(nonnull FPKeyPublic*)key;
- (FPLicenseInformations*) validateLicenseAtPath:(NSString*)path;
- (FPLicenseInformations*) validateLicenseFromData:(NSData*)data;

@end
