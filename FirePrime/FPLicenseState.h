//
//  FPLicenseState.h
//  FirePrime
//
//  Created by Perceval FARAMAZ on 07.06.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#ifndef FPLicenseState_h
#define FPLicenseState_h
typedef NSError*__nullable __autoreleasing*__nullable ByRefError;
/**
 The state of a given license. Can be Valid, Invalid, Malformed, or Blacklisted.
 
 @discussion You ought to change the constants associated with each state, for (a little) more safety.
 */
typedef NS_ENUM(NSUInteger, FPLicenseState) {
    FPLicenseStateUnknown = 0,
    FPLicenseStateBlacklisted = 1,
    FPLicenseStateValid = 2,
    FPLicenseStateMalformed = 3,
    FPLicenseStateInvalid = 4
};

#endif /* FPLicenseState_h */
