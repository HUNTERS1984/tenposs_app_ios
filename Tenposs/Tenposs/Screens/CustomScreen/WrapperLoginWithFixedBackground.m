//
//  WrapperLoginWithFixedBackground.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/2/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "WrapperLoginWithFixedBackground.h"
#import "UIImageView+WebCache.h"

@interface WrapperLoginWithFixedBackground ()

@property (strong, nonatomic) NSString *imageUrl;

@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;

@end

@implementation WrapperLoginWithFixedBackground

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_imageUrl) {
        [_imageBackground sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self performSegueWithIdentifier:@"wrapper_to_navigation" sender:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"DESTINATION %@", segue.destinationViewController);
    UINavigationController *navi = (UINavigationController *)segue.destinationViewController;
    if(navi){
        NSLog(@"DESTINATION ARRAY %@", navi.viewControllers);
    }
}


@end
