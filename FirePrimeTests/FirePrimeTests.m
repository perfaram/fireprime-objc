//
//  FirePrimeTests.m
//  FirePrimeTests
//
//  Created by Perceval FARAMAZ on 21.06.16.
//  Copyright © 2016 Faramaz. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FirePrime/FirePrime.h>
#import <FirePrime/FPLicenseGenerator.h>

@interface FirePrimeTests : XCTestCase

@end

@implementation FirePrimeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWithRequiredFields {
    FPSignKeySecret* secretKey = [FPSignKeySecret generateKey];
    XCTAssert(secretKey != nil);
    
    if (secretKey) {
        FPLicenseGenerator* generator = [FPLicenseGenerator.alloc initWithSecretKey:secretKey];
        
        generator.name = @"Jon Snow";
        generator.target = @"com.valyriansteel.longclaw";
        NSDate* nowDate = [NSDate date];
        generator.created = nowDate;
        generator.licenseId = @"ASOIAF96";
        
        NSData* license = [generator signLicenseWithError:nil];
        
        
        FPLicenseChecker* checker = [FPLicenseChecker.alloc initWithPublicKey:secretKey.publicKey];
        FPLicenseInformations* info = [checker validateLicenseFromData:license];
        
        XCTAssert([info.name isEqualToString:@"Jon Snow"]);
        XCTAssert([info.target isEqualToString:@"com.valyriansteel.longclaw"]);
        XCTAssert(fabs([info.created timeIntervalSinceDate:nowDate]) < 1);
        XCTAssert([info.licenseId isEqualToString:@"ASOIAF96"]);
        XCTAssert(info.state == FPLicenseStateValid);
        XCTAssertFalse(info.orderId);
        XCTAssertFalse(info.email);
        XCTAssertFalse(info.company);
        XCTAssert(info.instances == -1);
        
        
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

