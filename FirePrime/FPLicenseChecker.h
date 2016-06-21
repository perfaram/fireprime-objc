//
//  FPLicenseChecker.h
//  FirePrime
//
//  Created by Perceval FARAMAZ on 29.05.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FPSignKeyPublic;
@class FPLicenseInformations;

/**
 A singleton object holding the license registered.
 */
@interface FPLicenseChecker : NSObject {
    FPSignKeyPublic* publicKey;
}
@property NSArray<NSString*>*__nullable blacklist;
- (nullable instancetype) initWithPublicKey:(nonnull FPSignKeyPublic*)key;
- (nonnull FPLicenseInformations*) validateLicenseAtPath:(nonnull NSString*)path;
- (nonnull FPLicenseInformations*) validateLicenseFromData:(nonnull NSData*)data;

@end
