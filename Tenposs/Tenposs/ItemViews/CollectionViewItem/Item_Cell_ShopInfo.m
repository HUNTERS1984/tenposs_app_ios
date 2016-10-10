//
//  Item_Cell_ShopInfo.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "Item_Cell_ShopInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <GoogleMaps/GoogleMaps.h>

#define SHOP_MAPS_IMAGE_FORMAT  @"http://maps.google.com/maps/api/staticmap?center=%@,%@&zoom=15&size=%fx%f&sensor=false"

@interface Item_Cell_ShopInfo()

@property (weak, nonatomic) IBOutlet UIView *shop_map;
@property (weak, nonatomic) IBOutlet UIImageView *shopMapImage;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *shopAddressText;
@property (weak, nonatomic) IBOutlet UIImageView *shopAddressIcon;

@property (weak, nonatomic) IBOutlet UILabel *shopOpenText;
@property (weak, nonatomic) IBOutlet UIImageView *shopOpenIcon;

@property (weak, nonatomic) IBOutlet UIImageView *shopPhoneIcon;
@property (weak, nonatomic) IBOutlet UILabel *shopPhoneText;

@end

@implementation Item_Cell_ShopInfo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configureCellWithData:(NSObject *)data{
    ContactObject *shopInfo = (ContactObject *)data;
    if (!shopInfo) {
        return;
    }
    
    [_shopAddressText setText:shopInfo.title];
    [_shopOpenText setText:[NSString stringWithFormat:@"%@ - %@", [shopInfo getStartTimeString], [shopInfo getEndTimeString]]];
    [_shopPhoneText setText:shopInfo.tel];
    
//    NSString *mapImageURL = [NSString stringWithFormat:@"https://maps.google.com/maps/api/staticmap?zoom=15&size=500x200&sensor=false&markers=color:red|%@,%@&maptype=roadmap", shopInfo.latitude, shopInfo.longitude];
//    
//    [_shopMapImage sd_setImageWithURL:[NSURL URLWithString:mapImageURL]];
    
    GMSCameraPosition *fancy = [GMSCameraPosition cameraWithLatitude:[shopInfo.latitude doubleValue]
                                                           longitude:[shopInfo.longitude doubleValue]
                                                                zoom:15];
    [_mapView setCamera:fancy];
    
}

+ (CGFloat)getCellHeightWithWidth:(CGFloat)width{
    //TODO: need implementation
    //MapView ratio is 2.5:1 , 3 info view with 60 each, button is 44 with 15 padding both top and bottom
    CGFloat mapHeight = width / 1.8;
    CGFloat totalInfoViewHeight = 3*60;
    CGFloat buttonHeight = 44;
    CGFloat totalPadding = 15*2;
    
    return mapHeight + totalInfoViewHeight + buttonHeight + totalPadding;

}

+(CellSpanType)getCellSpanType{
    return CellSpanTypeFull;
}

@end
