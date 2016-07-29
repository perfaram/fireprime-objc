//
//  FPCheckedLicense.m
//  FirePrime
//
//  Created by Perceval FARAMAZ on 07.06.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import "FPLicenseInformations.h"

@implementation FPLicenseInformations
-(instancetype) initWithName:(NSString*)aName target:(NSString*)aTarget licenseId:(NSString*)aLicenseId createdAt:(NSDate*)createdAt inState:(FPLicenseState)aState
{
    self = [super init];
    if (self) {
        _name = aName;
        _target = aTarget;
        _licenseId = aLicenseId;
        _created = createdAt;
        _state = aState;
    }
    return self;
}

-(instancetype) initWithState:(FPLicenseState)aState
{
    self = [super init];
    if (self) {
        _state = aState;
    }
    return self;
}

-(BOOL) isValid {
    return _state == FPLicenseStateValid ? true : false;
}

@end
