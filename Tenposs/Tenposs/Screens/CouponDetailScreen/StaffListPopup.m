//
//  StaffListPopup.m
//  Tenposs
//
//  Created by Phúc Nguyễn on 10/27/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import "StaffListPopup.h"
#import "StaffCommunicator.h"
#import "Const.h"
#import "Utils.h"
#import "CouponAlertView.h"
#import "UIUtils.h"

@interface StaffListPopup () <TenpossCommunicatorDelegate>

@property (strong, nonatomic) StaffCategory *staffCate;

@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation StaffListPopup

static NSString *ident = @"cell_ident";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_staffCate) {
        _staffCate = [StaffCategory new];
    }
    
    [_navTitle setText:@"Staff"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ident];
    
    [self getStaffList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelTapped:(id)sender {
    //TODO: Dismiss popup
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getStaffList{
    StaffCommunicator *request = [StaffCommunicator new];
    Bundle *params = [Bundle new];
    [params put:KeyAPI_APP_ID value:APP_ID];
    NSString *currentTime =[@([Utils currentTimeInMillis]) stringValue];
    [params put:KeyAPI_TIME value:currentTime];
    NSArray *strings = [NSArray arrayWithObjects:APP_ID,currentTime,@"0",APP_SECRET,nil];
    [params put:KeyAPI_SIG value:[Utils getSigWithStrings:strings]];
    [params put:KeyAPI_CATEGORY_ID value:@"0"];
    [params put:KeyAPI_PAGE_INDEX value:[@(_staffCate.pageindex) stringValue]];
    [params put:KeyAPI_PAGE_SIZE value:@"20"];
    [request execute:params withDelegate:self];
}


#pragma mark - UITableViewDataSource

-(StaffObject *)staffForIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    return [_staffCate.staffs objectAtIndex:index];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_staffCate.staffs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    
    StaffObject *staff = [self staffForIndexPath:indexPath];
    
    if(staff){
        [cell.textLabel setText:staff.name];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StaffObject *staff = [self staffForIndexPath:indexPath];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(staffChose:)]){
        [self.delegate staffChose:staff];
    }
}

#pragma mark - TenpossCommunicatorDelegate

- (void)completed:(TenpossCommunicator *)request data:(Bundle *)responseParams{
    NSInteger errorCode =[responseParams getInt:KeyResponseResult];
    NSError *error = nil;
    if (errorCode != ERROR_OK) {
        NSString *errorDomain = [CommunicatorConst getErrorMessage:errorCode];
        error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
    }else{
        StaffResponse *data = (StaffResponse *)[responseParams get:KeyResponseObject];
        if (data.staffs && [data.staffs count] > 0) {
            _staffCate.total_staffs = data.total_staffs;
            for (StaffObject *staff in data.staffs) {
                [_staffCate addStaff:staff];
            }
        }else{
            if ([_staffCate.staffs count] > 0) {
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_CONTENT_FULLY_LOADED] code:ERROR_CONTENT_FULLY_LOADED userInfo:nil];
                
            }else{
                error = [NSError errorWithDomain:[CommunicatorConst getErrorMessage:ERROR_DETAIL_DATASOURCE_NO_CONTENT] code:ERROR_DETAIL_DATASOURCE_NO_CONTENT userInfo:nil];
            }
        }
        [self.tableView reloadData];
    }
}

@end
