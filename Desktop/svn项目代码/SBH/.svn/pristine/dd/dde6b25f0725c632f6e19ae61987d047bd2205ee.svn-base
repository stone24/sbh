//
//  gongsilianxirenController.m
//  sbh
//
//  Created by musmile on 14-7-7.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "gongsilianxirenController.h"
#import "gongsilianxirenCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ColorConfigure.h"
#import "BeRegularExpressionUtil.h"

@interface gongsilianxirenController () <ABPeoplePickerNavigationControllerDelegate>
- (IBAction)getLianxirenBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation gongsilianxirenController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _contactModel = [[selectContact alloc]init];
        _sourceType = ContactSourceTypeEdit;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加联系人";
    self.itabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.itabview.scrollEnabled = NO;
    self.saveBtn.layer.cornerRadius = 4.0f;
    [self.saveBtn setBackgroundColor:[ColorConfigure loginButtonColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    gongsilianxirenCell *cell = [gongsilianxirenCell cellWithTableView:tableView];
    if (indexPath.row==0){
        cell.neirong.text = self.contactModel.iName;
        cell.neirong.placeholder = @"必填";
    }
    else if (indexPath.row==1) {
        cell.lianxiren.text = @"联系人电话";
        cell.neirong.text = self.contactModel.iMobile;
        cell.neirong.placeholder = @"必填";
        cell.neirong.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (indexPath.row==2){
        cell.lianxiren.text = @"联系人邮箱";
        cell.neirong.text = self.contactModel.iEmail;
    }
    return cell;
}

- (IBAction)save:(id)sender {
    //保存数据
    //联系人姓名
    {
        NSIndexPath * indexpath = [NSIndexPath indexPathForItem:0 inSection:0];
        gongsilianxirenCell *cell =(gongsilianxirenCell*)[self.itabview cellForRowAtIndexPath:indexpath];
        if([cell.neirong.text length]<=0)
        {
            [CommonMethod showMessage:@"姓名不能为空！"];
            return;
        }
        self.contactModel.iName = cell.neirong.text;
    }
    //联系人电话
    {
        NSIndexPath * indexpath = [NSIndexPath indexPathForItem:1 inSection:0];
        gongsilianxirenCell *cell =(gongsilianxirenCell*)[self.itabview cellForRowAtIndexPath:indexpath];
        if([cell.neirong.text length]<=0)
        {
            [CommonMethod showMessage:@"电话不能为空！"];
            return;
        }
        if (![BeRegularExpressionUtil validateMobile:cell.neirong.text]) {
            [CommonMethod showMessage:@"电话号码不正确"];
            return;
        }
        self.contactModel.iMobile = cell.neirong.text;
    }
    //联系人邮箱
    {
        NSIndexPath * indexpath = [NSIndexPath indexPathForItem:2 inSection:0];
        gongsilianxirenCell * cell =(gongsilianxirenCell*)[self.itabview cellForRowAtIndexPath:indexpath];
        self.contactModel.iEmail = cell.neirong.text;
    }
    
    if(self.block)
    {
        self.block(self.contactModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)getLianxirenBtnClick:(UIButton *)sender {
    
    // 1.获得通讯录的授权状态
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) {
        // 2.申请授权
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
            // 授权完毕后调用
            if (granted == YES) { // 允许
                ABPeoplePickerNavigationController *peoleVC = [[ABPeoplePickerNavigationController alloc] init];
                peoleVC.peoplePickerDelegate = self;
                [self.navigationController presentViewController:peoleVC animated:YES completion:nil];
            } else { // 不允许
                return;
            }
            // 释放对象
            CFRelease(book);
        });
    } else if (status == kABAuthorizationStatusAuthorized) {
        ABPeoplePickerNavigationController *peoleVC = [[ABPeoplePickerNavigationController alloc] init];
        peoleVC.peoplePickerDelegate = self;
        [self.navigationController presentViewController:peoleVC animated:YES completion:nil];
    } else {
        [MBProgressHUD showError:@"请在\"设置->隐私->通讯录\"中打开授权"];
    }

}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker

{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSString *name = (__bridge NSString *)ABRecordCopyCompositeName(person);
    self.contactModel.iName = name;
    if (property == kABPersonPhoneProperty)
    {
        ABMutableMultiValueRef phoneMulti =  ABRecordCopyValue(person,kABPersonPhoneProperty);
        int index =  (int)ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString *phone =  (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        self.contactModel.iMobile = phone;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.itabview reloadData];
    return NO;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0)
{
    NSString *name = (__bridge NSString *)ABRecordCopyCompositeName(person);
    self.contactModel.iName = name;
    if (property == kABPersonPhoneProperty)
    {
        ABMutableMultiValueRef phoneMulti =  ABRecordCopyValue(person,kABPersonPhoneProperty);
        int index = (int)ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString *phone =  (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        self.contactModel.iMobile = phone;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.itabview reloadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"gongsilianxirenController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"gongsilianxirenController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
