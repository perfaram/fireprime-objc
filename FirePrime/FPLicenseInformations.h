//
//  FPCheckedLicense.h
//  FirePrime
//
//  Created by Perceval FARAMAZ on 07.06.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPLicenseState.h"

@interface FPLicenseInformations : NSObject
@property (          readonly, assign) FPLicenseState state;

@property (nonnull, readonly, strong) NSString* name;
@property (nonnull, readonly, strong) NSString* target;
@property (nonnull, readonly, strong) NSString* licenseId;
@property (nonnull, readonly, strong) NSDate* created;
//---- optionals
@property (nullable, readonly, strong) NSString* email;
@property (nullable, readonly, strong) NSString* company;
@property (          readonly, assign) SInt32 instances;
@property (nullable, readonly, strong) NSString* orderId;

-(BOOL) isValid;
@end
