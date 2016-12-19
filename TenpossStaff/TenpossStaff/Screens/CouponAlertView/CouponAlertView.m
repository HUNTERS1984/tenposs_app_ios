//
//  CouponAlertView.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "CouponAlertView.h"

@interface CouponAlertView ()

@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *alertTitle;
@property (weak, nonatomic) IBOutlet UILabel *alertDescription;
@property (weak, nonatomic) IBOutlet UIButton *positiveButton;
@property (weak, nonatomic) IBOutlet UIButton *negativeButton;

@end

@implementation CouponAlertView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.view layoutIfNeeded];
    
    _contentView.layer.cornerRadius = 5.0f;
    _contentView.clipsToBounds = YES;
    _positiveButton.layer.cornerRadius = 5.0f;
    _negativeButton.layer.cornerRadius = 5.0f;
    _topImage.layer.cornerRadius = _topImage.bounds.size.width/2;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFrom:(UIViewController *)parentViewController withType:(CouponAlertImageType)imageType title:(NSString *)title description:(NSString *)description positiveButton:(NSString *)posTitle negativeButton:(NSString *)nevTitle delegate:(id<CouponAlertViewDelegate>)delegate{
    
    if (delegate) {
        _delegate = delegate;
    }
    
    switch (imageType) {
        case CouponAlertImageTypeSend:
            [_topImage setBackgroundColor:[UIColor blueColor]];
            break;
        case CouponAlertImageTypeAccepted:
            [_topImage setBackgroundColor:[UIColor greenColor]];
            break;
        case CouponAlertImageTypeRejected:
            [_topImage setBackgroundColor:[UIColor redColor]];
            break;
        default:
            break;
    }
    
    [_alertTitle setText:title];
    
    [_alertDescription setText:description];
    
    if (!posTitle) {
        [_positiveButton removeFromSuperview];
    }else{
        [_positiveButton setTitle:posTitle forState:UIControlStateNormal];
        [_positiveButton addTarget:self action:@selector(positiveTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (!nevTitle) {
        [_negativeButton removeFromSuperview];
    }else{
        [_negativeButton setTitle:nevTitle forState:UIControlStateNormal];
        [_negativeButton addTarget:self action:@selector(negativeTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //Show alert
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [parentViewController presentViewController:self animated:YES completion:nil];
    
}

- (void)positiveTapped{
    [_background setBackgroundColor:[UIColor redColor]];
    if(_delegate && [_delegate respondsToSelector:@selector(onPositiveButtonTapped:)]){
        [_delegate onPositiveButtonTapped:self];
    }
}

- (void)negativeTapped{
    if(_delegate && [_delegate respondsToSelector:@selector(onNegativeButtonTapped:)]){
        [_delegate onNegativeButtonTapped:self];
    }
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
