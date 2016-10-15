//
//  CouponAlertView.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/12/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CouponAlertImageType) {
    CouponAlertImageTypeSend,
    CouponAlertImageTypeAccepted,
    CouponAlertImageTypeRejected
};

@class CouponAlertView;

@protocol CouponAlertViewDelegate <NSObject>

-(void)onPositiveButtonTapped:(CouponAlertView *)alertView;

@end

@interface CouponAlertView : UIViewController

@property (weak, nonatomic) id<CouponAlertViewDelegate> delegate;

- (void)showFrom:(UIViewController *)parentViewController withType:(CouponAlertImageType)imageType title:(NSString *)title description:(NSString *)description positiveButton:(NSString *)posTitle negativeButton:(NSString *)nevTitle delegate:(id<CouponAlertViewDelegate>)delegate;

@end
