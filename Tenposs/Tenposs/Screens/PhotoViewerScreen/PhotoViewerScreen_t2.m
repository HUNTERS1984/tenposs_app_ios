//
//  PhotoViewerScreen_t2.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 11/15/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "PhotoViewerScreen_t2.h"
#import "UIFont+Themify.h"
#import "UIImageView+WebCache.h"
#import "HexColors.h"
#import "AppConfiguration.h"

@interface PhotoViewerScreen_t2 ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property(weak, nonatomic) IBOutlet UIImageView *photoView;
@property(weak, nonatomic) IBOutlet UILabel *photoTitle;
@property(weak, nonatomic) IBOutlet UILabel *photoDesc;
@property(weak, nonatomic) IBOutlet UIButton *closeButton;
@end

@implementation PhotoViewerScreen_t2

- (void)viewDidLoad {
    [super viewDidLoad];
    AppConfiguration *appConfig = [AppConfiguration sharedInstance];
    AppSettings *settings = [appConfig getAvailableAppSettings];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@", [UIFont stringForThemifyIdentifier:@"ti-close"]] attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                                                                                                 [UIFont themifyFontOfSize:20/*[UIUtils getTextSizeWithType:settings.font_size]*/], NSFontAttributeName,
                                                                                                                                                                                 [UIColor colorWithHexString:@"ffffff"], NSForegroundColorAttributeName,                                                                                       nil]]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithHexString:settings.title_color], NSForegroundColorAttributeName,nil]];
    [_closeButton setAttributedTitle:attString forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.loadingIndicator startAnimating];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _photoView.clipsToBounds = YES;
    
    if (_photo != nil) {
        [self presentPhoto:_photo];
    }
}

- (void) presentPhoto:(PhotoObject *)photo{
    [_photoView sd_setImageWithURL:[NSURL URLWithString:(photo.image_url)] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil) {
            [self.loadingIndicator stopAnimating];
            self.loadingIndicator.hidden = YES;
        }
    }];
    [_photoTitle setText:@""];
    [_photoDesc setText:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPhoto:(PhotoObject *)photo{
    if (photo) {
        _photo = photo;
    }
}

- (IBAction)closeButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
