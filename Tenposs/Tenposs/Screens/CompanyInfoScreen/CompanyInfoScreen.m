//
//  CompanyInfoScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/11/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "CompanyInfoScreen.h"
#import <InAppSettingsKit/IASKSpecifier.h>

@interface CompanyInfoScreen ()

@end

@implementation CompanyInfoScreen

- (id)initWithFile:(NSString*)file specifier:(IASKSpecifier*)specifier {
    if ((self = [super init])) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
