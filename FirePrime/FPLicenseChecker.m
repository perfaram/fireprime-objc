//
//  FPLicenseChecker.m
//  FirePrime
//
//  Created by Perceval FARAMAZ on 29.05.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import "FPLicenseChecker.h"
#import "FPLicenseState.h"
#import "FPLicenseInformations.h"
#import "FPKey.h"
#import "License.pb.h"
#include "sodium.h"

@interface FPLicenseInformations()
-(nonnull instancetype) initWithName:(NSString*)aName target:(NSString*)aTarget licenseId:(NSString*)aLicenseId email:(NSString*)anEmail company:(NSString*)aCompany orderId:(NSString*)anOrderId createdAt:(NSDate*)createdAt forInstances:(SInt32)forInstances inState:(FPLicenseState)aState;

-(nonnull instancetype) initWithState:(FPLicenseState)aState;
@end

@implementation FPLicenseChecker
-(nullable instancetype) initWithPublicKey:(nonnull FPSignKeyPublic*)key {
    self = [super init];
    if (self) {
        if (sodium_init() == -1)
            return nil;
        publicKey = key;
    }
    return self;
}

- (FPLicenseInformations*) validateLicenseAtPath:(NSString *)path {
    NSData* rawSignedLicense = [NSData dataWithContentsOfFile:path];
    return [self validateLicenseFromData:rawSignedLicense];
}

- (FPLicenseInformations*) validateLicenseFromData:(NSData*)rawSignedLicense {
    FPLicense* signedLicense = [FPLicense parseFromData:rawSignedLicense];
    FPLicenseMetadata* licenseMetadata = signedLicense.license;
    
    if (signedLicense.signature.length!=crypto_sign_BYTES) {
        return [FPLicenseInformations.alloc initWithState:FPLicenseStateMalformed];
    }
    const unsigned char* sig = signedLicense.signature.bytes;
    NSOutputStream* rawMetadataStream = [NSOutputStream outputStreamToMemory];
    [rawMetadataStream open];
    
    PBCodedOutputStream* outMetadataStream = [PBCodedOutputStream streamWithOutputStream:rawMetadataStream];
    [licenseMetadata writeToCodedOutputStream:outMetadataStream];
    [outMetadataStream flush];
    
    NSData* rawMetadata = [rawMetadataStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    
    
    if (crypto_sign_verify_detached(sig, rawMetadata.bytes, rawMetadata.length, publicKey.buffer) != 0) {
        return [FPLicenseInformations.alloc initWithState:FPLicenseStateInvalid];
    }
    if (0/*blacklisted*/) {
        return [FPLicenseInformations.alloc initWithState:FPLicenseStateBlacklisted];
    }
    NSDate* crDate = [NSDate dateWithTimeIntervalSince1970:licenseMetadata.created];
    return [FPLicenseInformations.alloc initWithName:licenseMetadata.name
                                              target:licenseMetadata.target
                                           licenseId:licenseMetadata.licenseId
                                               email:(licenseMetadata.hasEmail) ? licenseMetadata.email : nil
                                             company:(licenseMetadata.hasCompany) ? licenseMetadata.company : nil
                                             orderId:(licenseMetadata.hasOrderId) ? licenseMetadata.orderId : nil
                                           createdAt:crDate
                                        forInstances:(licenseMetadata.hasInstances) ? licenseMetadata.instances : -1
                                             inState:FPLicenseStateValid];
}

@end
