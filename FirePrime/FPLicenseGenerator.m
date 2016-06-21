//
//  FPLicenseGenerator.m
//  FirePrime
//
//  Created by Perceval FARAMAZ on 05.06.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import "FPLicenseGenerator.h"
#import "License.pb.h"
#include "sodium.h"
#import <ProtocolBuffers/ProtocolBuffers.h>

@interface FPLicenseGenerator() {
    FPLicenseMetadataBuilder* licenseBuilder;
}
@end

@implementation FPLicenseGenerator
-(nullable instancetype) initWithSecretKey:(nonnull FPSignKeySecret*)key {
    self = [super init];
    if (self) {
        if (sodium_init() == -1)
            return nil;
        secretKey = key;
        
        unsigned char seed[crypto_sign_SEEDBYTES];
        unsigned char ed25519_sk[crypto_sign_SECRETKEYBYTES];
        unsigned char ed25519_pk[crypto_sign_PUBLICKEYBYTES];
        [secretKey copyToBuffer:ed25519_sk];
        
        // COMPUTE ED25519 PUBLIC KEY, REQUIRES ESTABLISHING A SEED
        crypto_sign_ed25519_sk_to_seed(seed, ed25519_sk);
        crypto_sign_seed_keypair(ed25519_pk, ed25519_sk, seed);
        publicKey = [FPSignKeyPublic.alloc initWithBuffer:ed25519_pk ofLength:crypto_sign_PUBLICKEYBYTES copying:true];
        
        licenseBuilder = [FPLicenseMetadata builder];
        if (!licenseBuilder)
            return nil;
    }
    return self;
}

-(void) setName:(NSString *)name {
    licenseBuilder = [licenseBuilder setName:name];
}

-(void) setTarget:(NSString *)target {
    licenseBuilder = [licenseBuilder setTarget:target];
}

-(void) setEmail:(NSString *)email {
    licenseBuilder = [licenseBuilder setEmail:email];
}

-(void) setCompany:(NSString *)company {
    licenseBuilder = [licenseBuilder setCompany:company];
}

-(void) setCreated:(NSDate *)created {
    time_t unixTime = (time_t) [created timeIntervalSince1970];
    licenseBuilder = [licenseBuilder setCreated:unixTime];
}

-(void) setOrderId:(NSString *)orderId {
    licenseBuilder = [licenseBuilder setOrderId:orderId];
}

-(void) setLicenseId:(NSString *)licenseId {
    licenseBuilder = [licenseBuilder setLicenseId:licenseId];
}

-(void) setInstances:(SInt32)instances {
    licenseBuilder = [licenseBuilder setInstances:instances];
}

-(NSData*) signLicenseWithError:(out NSError**)error {
    unsigned char sig[crypto_sign_BYTES];
    NSOutputStream* rawMetadataStream = [NSOutputStream outputStreamToMemory];
    NSOutputStream* rawLicenseStream = [NSOutputStream outputStreamToMemory];
    FPLicenseMetadata* metadata = [licenseBuilder build];
    
    [rawMetadataStream open];
    PBCodedOutputStream* outMetadataStream = [PBCodedOutputStream streamWithOutputStream:rawMetadataStream];
    [metadata writeToCodedOutputStream:outMetadataStream];
    [outMetadataStream flush];
    
    NSData* rawMetadata = [rawMetadataStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    
    crypto_sign_detached(sig, NULL, rawMetadata.bytes, rawMetadata.length, secretKey.buffer);
    NSData* signature = [NSData.alloc initWithBytes:sig length:crypto_sign_BYTES];
    
    FPLicenseBuilder* signedLicenseBuilder = [FPLicense builder];
    [signedLicenseBuilder setLicense:metadata];
    [signedLicenseBuilder setSignature:signature];
    FPLicense* signedLicense = [signedLicenseBuilder build];
    
    [rawLicenseStream open];
    PBCodedOutputStream* outLicenseStream = [PBCodedOutputStream streamWithOutputStream:rawLicenseStream];
    [signedLicense writeToCodedOutputStream:outLicenseStream];
    [outLicenseStream flush];
    
    NSData* rawSignedLicense = [rawLicenseStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    
    return rawSignedLicense;
}
@end
