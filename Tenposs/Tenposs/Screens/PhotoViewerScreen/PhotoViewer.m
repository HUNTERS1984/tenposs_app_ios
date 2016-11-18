//
//  PhotoViewer.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 8/31/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "PhotoViewer.h"
#import "UIImageView+WebCache.h"

@interface PhotoViewer ()

@property(strong, nonatomic)PhotoObject *photo;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation PhotoViewer

-(IBAction)buttonClick:(id)sender{
    if (sender == _closeButton) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _closeButton.hidden = YES;
}

- (void)setPhoto:(PhotoObject *)photo{
    if (photo) {
        _photo = photo;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.loadingIndicator startAnimating];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _closeButton.layer.cornerRadius = _closeButton.frame.size.width/2;
    _closeButton.clipsToBounds = YES;
    _closeButton.hidden = NO;
    
    _imageView.clipsToBounds = YES;
    
    if (_photo != nil) {
        [self presentPhoto:_photo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) presentPhoto:(PhotoObject *)photo{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:(photo.image_url)] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image != nil) {
            [self.loadingIndicator stopAnimating];
            self.loadingIndicator.hidden = YES;
        }
    }];
}

@end
