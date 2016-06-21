//
//  FPLicenseGenerator.h
//  FirePrime
//
//  Created by Perceval FARAMAZ on 05.06.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPKey.h"
#import "FPLicenseState.h"

@interface FPLicenseGenerator : NSObject {
    FPSignKeySecret* secretKey;
    FPSignKeyPublic* publicKey;
}

@property (readwrite, strong, nonatomic, nonnull)  NSString* name;
@property (readwrite, strong, nonatomic, nonnull)  NSString* target;
@property (readwrite, strong, nonatomic, nonnull)  NSString* licenseId;
@property (readwrite, strong, nonatomic, nonnull)  NSDate* created;
@property (readwrite, strong, nonatomic, nullable) NSString* email;
@property (readwrite, strong, nonatomic, nullable) NSString* company;
@property (readwrite, assign, nonatomic          ) SInt32 instances;
@property (readwrite, strong, nonatomic, nullable) NSString* orderId;

- (nullable instancetype) initWithSecretKey:(nonnull FPSignKeySecret*)key;
- (nullable NSData*) signLicenseWithError:(ByRefError)error;

@end
