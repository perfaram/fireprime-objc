//
//  FPLicenseGenerator.h
//  FirePrime
//
//  Created by Perceval FARAMAZ on 05.06.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPKey.h"

@interface FPLicenseGenerator : NSObject {
    FPKeySecret* secretKey;
    FPKeyPublic* publicKey;
}

@property (readwrite, strong, nonatomic) NSString* name;
@property (readwrite, strong, nonatomic) NSString* target;
@property (readwrite, strong, nonatomic) NSString* licenseId;
@property (readwrite, strong, nonatomic) NSDate* created;
@property (readwrite, strong, nonatomic) NSString* email;
@property (readwrite, strong, nonatomic) NSString* company;
@property (readwrite, assign, nonatomic) SInt32 instances;
@property (readwrite, strong, nonatomic) NSString* orderId;

- (nullable instancetype) initWithSecretKey:(nonnull FPKeySecret*)key;
- (nullable NSData*) signLicenseWithError:(out NSError**)error;

@end
