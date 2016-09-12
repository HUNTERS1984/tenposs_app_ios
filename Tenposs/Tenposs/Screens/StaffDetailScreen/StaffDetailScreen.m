//
//  StaffDetailScreen.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 9/7/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "StaffDetailScreen.h"
#import "TenpossSegmentedControl.h"
#import "UIViewController+LoadingView.h"

#define COLLAPESED_HEIGHT 120

@interface StaffDetailScreen (){
    bool isCollapsed;
    CGFloat collapseContentViewHeight;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *staffTitle;
@property (weak, nonatomic) IBOutlet UIButton *goToButton;
@property (weak, nonatomic) IBOutlet TenpossSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UIButton *showMoreButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@end

@implementation StaffDetailScreen

-(IBAction)buttonClick:(id)sender{
    if(sender == _goToButton){
        
    }else if (sender == _showMoreButton) {
        isCollapsed = NO;
        [self recalculateContentSize];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_staffTitle setText:_staff.name];
    [_desc setText:_staff.introduction];
    [_segmentedControl setItems:[[NSArray arrayWithObjects:@"Introduction",@"Profile", nil] mutableCopy]];
    [_segmentedControl setSelectedIndex:0];
    isCollapsed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(collapseContentViewHeight <= 0){
        collapseContentViewHeight = _contentViewHeightConstraint.constant;
    }
    
    CGFloat neededHeight = [self.desc sizeThatFits:CGSizeMake(self.desc.frame.size.width, CGFLOAT_MAX)].height;
    if (neededHeight <= COLLAPESED_HEIGHT) {
        [_showMoreButton setHidden:YES];
    }
    
    [self recalculateContentSize];
}

- (void)recalculateContentSize{
    if (!isCollapsed) {
        CGFloat contentBottom = self.desc.frame.origin.y;
        CGFloat allHeight = [self.desc sizeThatFits:CGSizeMake(self.desc.frame.size.width, CGFLOAT_MAX)].height;
        CGFloat neededHeight = allHeight ;
        self.descHeightConstraint.constant = allHeight;
        self.contentViewHeightConstraint.constant = neededHeight + contentBottom + 8 + 40 + 8 + COLLAPESED_HEIGHT;
        [self.view needsUpdateConstraints];
        [self removeLoadingView];
    }else{
        self.descHeightConstraint.constant = COLLAPESED_HEIGHT;
        self.contentViewHeightConstraint.constant = collapseContentViewHeight;
    }
    [self updateViewConstraints];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
