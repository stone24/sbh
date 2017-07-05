//
//  tianjiaxinchengjirenViewController.m
//  sbh
//
//  Created by musmile on 14-7-7.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//  益普索 酒店 入住人  手机号必填， 其他选填
//  除了益普索之外，只填姓名就行了

#import "BePassengerViewController.h"
#import "BePassengerDetailTableViewCell.h"
#import "BeFlightOrderWriteViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "BeAlteRetView.h"
#import "ColorConfigure.h"
#import "BeTrainBookingController.h"
#import "BeRegularExpressionUtil.h"
#import "BePassengerDatePickerView.h"
#import "UIActionSheet+Block.h"
#import "BeOrderWriteController.h"

#define kTitleName      @"titleName"
#define kIsRequired     @"isRequired"

#define kTitle1 @"证件类型" 
#define kTitle2 @"证件号码"
#define kTitle3 @"乘客手机"
#define kTitle4 @"出生日期"

@interface BePassengerViewController () <ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate>
{
    BOOL isPopView;
    selectPerson * iSeleperson;
}
@end

@implementation BePassengerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isPopView = NO;
        _canEdit = YES;
        _sourceType = AddPassengerSourceTypeAirTicket;
    } 
    return self;
}
-(id)init:(selectPerson*)aSelePerson
{
    self = [super init];
    if (self)
    {
        iSeleperson = aSelePerson;
        if ([iSeleperson.iCredtype isEqualToString:@"1"]||[ iSeleperson.iCredtype isEqualToString:@"身份证"]) {
            iSeleperson.iCredtype = @"身份证";
        }
        else if ([iSeleperson.iCredtype isEqualToString:@"2"]||[iSeleperson.iCredtype isEqualToString:@"护照"]){
            iSeleperson.iCredtype= @"护照";
        }
        else if ([iSeleperson.iCredtype isEqualToString:@"3"]||[iSeleperson.iCredtype isEqualToString:@"回乡证"]){
            iSeleperson.iCredtype = @"回乡证";
        }
        else if ([iSeleperson.iCredtype isEqualToString:@"4"]||[iSeleperson.iCredtype isEqualToString:@"台胞证"]){
            iSeleperson.iCredtype = @"台胞证";
        }
        else if ([iSeleperson.iCredtype isEqualToString:@"5"]||[iSeleperson.iCredtype isEqualToString:@"军人证"]){
            iSeleperson.iCredtype = @"军人证";
        }
        else if ([iSeleperson.iCredtype isEqualToString:@"6"]||[iSeleperson.iCredtype isEqualToString:@"警官证"]){
            iSeleperson.iCredtype = @"警官证";
        }
        else if ([iSeleperson.iCredtype isEqualToString:@"7"]||[iSeleperson.iCredtype isEqualToString:@"港澳通行证"]){
            iSeleperson.iCredtype = @"港澳通行证";
        }
        else if ([iSeleperson.iCredtype isEqualToString:@"8"]||[iSeleperson.iCredtype isEqualToString:@"其他证件"]){
            iSeleperson.iCredtype = @"其他证件";
        }
        else
        {
            iSeleperson.iCredtype = @"身份证";
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    NSString *titleName1 = [[NSString alloc]init];
    if (self.sourceType == AddPassengerSourceTypeTrain)
    {
        titleName1 = @"乘车人姓名";
    }
    else if(self.sourceType == AddPassengerSourceTypeHotel)
    {
        titleName1 = @"入住人姓名";
    }
    else
    {
        titleName1 = @"乘机人姓名";
    }
    [self.dataArray addObject:@{kTitleName:titleName1,kIsRequired:[NSNumber numberWithBool:YES]}];
    BOOL boolDataHotel = self.sourceType == AddPassengerSourceTypeHotel?NO:YES;
    [self.dataArray addObject:@{kTitleName:kTitle1,kIsRequired:[NSNumber numberWithBool:boolDataHotel]}];
    [self.dataArray addObject:@{kTitleName:kTitle2,kIsRequired:[NSNumber numberWithBool:boolDataHotel]}];
    BOOL boolData4 = [GlobalData getSharedInstance].userModel.isYPS;
    if(self.sourceType == AddPassengerSourceTypeHotel)
    {
        [self.dataArray addObject:@{kTitleName:kTitle3,kIsRequired:[NSNumber numberWithBool:boolData4]}];
    }
    else
    {
        [self.dataArray addObject:@{kTitleName:kTitle4,kIsRequired:[NSNumber numberWithBool:NO]}];
        [self.dataArray addObject:@{kTitleName:kTitle3,kIsRequired:[NSNumber numberWithBool:boolData4]}];
    }
    if(self.canEdit)
    {
        [self setFooterView];
    }
    if ([iSeleperson.iName isEqualToString:@""]) {
        iSeleperson.iGender = @"男";
        iSeleperson.iCredtype = @"身份证";
        iSeleperson.iInsquantity =[NSString stringWithFormat:@"%d",[GlobalData getSharedInstance].insquantity];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"BePassengerViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"BePassengerViewController"];
    [self.view endEditing:YES];
    if(isPopView == YES)
    {
        for(int i = 0;i < self.dataArray.count;i++)
        {
            BePassengerDetailTableViewCell *cell = (BePassengerDetailTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.textfield.delegate =nil;
            [cell.textfield removeFromSuperview];
        }
    }
}
- (void)setFooterView
{
    UIView *tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    UIButton *inquireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    inquireButton.frame = CGRectMake(15, 30, SBHScreenW - 30, 40);
    inquireButton.layer.cornerRadius = 4.0f;
    [inquireButton addTarget:self action:@selector(finishWriteAction) forControlEvents:UIControlEventTouchUpInside];
    [inquireButton setBackgroundColor:[ColorConfigure loginButtonColor]];
    [inquireButton setTitle:@"完成填写" forState:UIControlStateNormal];
    [tableFooterView addSubview:inquireButton];
    self.tableView.tableFooterView = tableFooterView;
}
#pragma mark - tableView Delegate&Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BePassengerDetailTableViewCell *cell = [BePassengerDetailTableViewCell cellWithTableView:tableView];
    if(!self.canEdit)
    {
        cell.assistIcon.hidden  = YES;
        cell.textfield.textColor = [UIColor darkGrayColor];
        cell.textfield.enabled = NO;
    }
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    cell.lab.text = [dict objectForKey:kTitleName];
    cell.textfield.placeholder = [dict boolValueForKey:kIsRequired]?@"必填":@"";
    cell.textfield.delegate = self;
    if (indexPath.row==0)
    {
        cell.textfield.tag=1000;
        cell.textfield.text = iSeleperson.iName;
        [cell.assistIcon addTarget:self action:@selector(showNameRule) forControlEvents:UIControlEventTouchUpInside];
        [cell.assistIcon setImage:[UIImage imageNamed:@"tjcjr_wenhaoIcon"] forState:UIControlStateNormal];
        return cell;
    }
    else if ([cell.lab.text isEqualToString:kTitle1])
    {
        cell.textfield.text = iSeleperson.iCredtype;
        cell.textfield.enabled = NO;
        return cell;
    }
    else if ([cell.lab.text isEqualToString:kTitle2])
    {
        cell.textfield.tag = 1001;
        cell.textfield.text = iSeleperson.iCredNumber;
        cell.textfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [cell.assistIcon setImage:[UIImage imageNamed:@"common_icon_arrow"] forState:UIControlStateNormal];
        return cell;
    }
    else if ([cell.lab.text isEqualToString:kTitle3])
    {
        cell.textfield.tag = 2002;
        cell.textfield.text = iSeleperson.iMobile;
        [cell.assistIcon setImage:[UIImage imageNamed:@"addTx"] forState:UIControlStateNormal];
        [cell.assistIcon addTarget:self action:@selector(addTxBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if ([cell.lab.text isEqualToString:kTitle4])
    {
        cell.textfield.enabled = NO;
        cell.textfield.text = iSeleperson.iBirthday;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.canEdit)
    {
        return;
    }
    BePassengerDetailTableViewCell *cell = (BePassengerDetailTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.lab.text isEqualToString:kTitle1])
    {
        if(self.sourceType != AddPassengerSourceTypeTrain)
        {
            [self showCardActionSheetWithRow:indexPath.row];
        }
        else
        {
            [self showTrainCardActionSheetWithRow:indexPath.row];
        }
    }
    else if ([cell.lab.text isEqualToString:kTitle4])
    {
        [self showDatepickerWithRow:indexPath.row];
    }
}
#pragma mark - showDatePicker
- (void)showDatepickerWithRow:(NSInteger)row
{
    [self.view endEditing:YES];
    BePassengerDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [[BePassengerDatePickerView sharedInstance]showPickerViewWithSelectDate:cell.textfield.text andBlock:^(NSDate *selectdate)
     {
         NSString *date = [CommonMethod stringFromDate:selectdate WithParseStr:kFormatYYYYMMDD];
         iSeleperson.iBirthday = date;
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
     }];
}
#pragma mark - showTrainCardActionSheet

- (void)showTrainCardActionSheetWithRow:(NSInteger)row
{
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:kTitle1 delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"身份证",@"护照",@"台胞证",@"港澳通行证",@"取消", nil];
    [sheet showActionSheetWithClickBlock:^(NSInteger buttonIndex)
     {
         if (buttonIndex!= 4) {
             iSeleperson.iCredtype = [sheet buttonTitleAtIndex:buttonIndex];
             [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
         }
     }];
}
#pragma mark - showCardActionSheet
- (void)showCardActionSheetWithRow:(NSInteger)row
{
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:kTitle1 delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"身份证",@"护照",@"回乡证",@"台胞证",@"军人证",@"警官证",@"港澳通行证",@"其他证件",@"取消", nil];
    [sheet showActionSheetWithClickBlock:^(NSInteger buttonIndex)
     {
         if (buttonIndex!= 8) {
             iSeleperson.iCredtype = [sheet buttonTitleAtIndex:buttonIndex];
             [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
         }
     }];
}
#pragma mark - FinishWrite
- (void)finishWriteAction
{
    [self.view endEditing:YES];
    for(NSDictionary *member in self.dataArray)
    {
        if([self.dataArray indexOfObject:member] == 0)
        {
            if([member boolValueForKey:kIsRequired])
            {
                if (iSeleperson.iName.length == 0 || iSeleperson.iName == nil)
                {
                    [MBProgressHUD showError:@"姓名不能为空"];
                    return;
                }
            }
        }
        if([member boolValueForKey:kTitle2])//证件号码
        {
            if([member boolValueForKey:kIsRequired])
            {
                if (iSeleperson.iCredNumber.length == 0)
                {
                    [MBProgressHUD showError:@"证件号码不能为空"];
                    return;
                }
            }
            if (iSeleperson.iCredNumber.length > 0 && [iSeleperson.iCredtype isEqualToString:@"身份证"])
            {
                if (![BeRegularExpressionUtil validateIdentityCard:iSeleperson.iCredNumber])
                {
                    [MBProgressHUD showError:@"输入身份证格式不正确"];
                    return;
                }
            }
            else if (iSeleperson.iCredNumber.length > 0 &&[iSeleperson.iCredtype isEqualToString:@"其他证件"])
            {
                if(iSeleperson.iCredNumber.length == 18 && ![BeRegularExpressionUtil validateIdentityCard:iSeleperson.iCredNumber])
                {
                    [MBProgressHUD showError:@"乘机人证件号码有误，请核对"];
                    return;
                }
            }
        }
        if([member boolValueForKey:kTitle3])//乘客手机
        {
            if([member boolValueForKey:kIsRequired] && (iSeleperson.iMobile.length == 0 || iSeleperson.iMobile == nil))
            {
                [MBProgressHUD showError:@"手机号码不能为空"];
                return;
            }
            if(![BeRegularExpressionUtil validateMobile:iSeleperson.iMobile]&&iSeleperson.iMobile.length>0)
            {
                [MBProgressHUD showError:@"请输入正确的手机号码"];
                return;
            }
        }
        if([member boolValueForKey:kTitle4])//出生日期
        {
            if([member boolValueForKey:kIsRequired])
            {
                if (iSeleperson.iBirthday.length == 0 || iSeleperson.iBirthday == nil)
                {
                    [MBProgressHUD showError:@"出生日期不能为空"];
                    return;
                }
            }
        }
    }
    UIViewController *viewController;
    if(self.sourceType == AddPassengerSourceTypeAirTicket)
    {
        viewController = [self getNavigationHistoryVC:[BeFlightOrderWriteViewController class]];
    }
    else if(self.sourceType == AddPassengerSourceTypeTrain)
    {
        viewController = [self getNavigationHistoryVC:[BeTrainBookingController class]];

    }else if(self.sourceType == AddPassengerSourceTypeHotel)
    {
        viewController = [self getNavigationHistoryVC:[BeOrderWriteController class]];
    }
    if(self.block)
    {
        self.block(iSeleperson);
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAddHotelPerson object:nil userInfo:[iSeleperson mj_keyValues]];
    }
    isPopView = YES;
    if(viewController !=nil)
    {
        [self.navigationController popToViewController:viewController animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - showNameRule
- (void)showNameRule
{
    BeAlteRetView *altRetView = [[BeAlteRetView alloc] initWithTitle:@"1.乘客姓名必须与登机时所使用证件上的名字一致。\n2.如持护照登机，使用中文姓名，必须确认护照上有中文姓名。\n3.持护照等级的外宾，必须按照护照顺序区分姓与名，例如“Smith/Black”,不区分大小写                                    \n4.英文名字的长度不可超过26个字符，如名字过长请使用缩写，乘客的姓氏不能缩写，名可以缩写。姓氏中如包含空格请在输入时删掉空格。\n5.姓名中不可含有称谓等词语，如：小姐、先生、太太、夫人等。\n6.中文名字不可少于2个汉字，英文姓名不可少于2个英文单词。"];
    [altRetView show];
}
#pragma mark - TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==1000) {
        iSeleperson.iName = [textField text];
    }
    else if (textField.tag == 1001){  // 证件号
        iSeleperson.iCredNumber = [textField text];
        if ([iSeleperson.iCredtype isEqualToString:@"身份证"])
        {
            if ([BeRegularExpressionUtil validateIdentityCard:textField.text])
            {
                NSString *str = [textField.text substringWithRange:NSMakeRange(6, 8)];
                NSMutableString *mubStr = [NSMutableString stringWithString:str];
                [mubStr insertString:@"-" atIndex:4];
                [mubStr insertString:@"-" atIndex:7];
                iSeleperson.iBirthday = mubStr;
                if(self.sourceType == AddPassengerSourceTypeHotel)
                {
                    return;
                }
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    else if (textField.tag ==2002)
    {
        iSeleperson.iMobile = [textField text];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - ABAddressBook
- (void)addTxBtnClick
{
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
            if (granted == YES) { // 允许
                ABPeoplePickerNavigationController *peoleVC = [[ABPeoplePickerNavigationController alloc] init];
                peoleVC.peoplePickerDelegate = self;
                isPopView = NO;
                [self.navigationController presentViewController:peoleVC animated:YES completion:nil];
            } else { // 不允许
                return;
            }
            CFRelease(book);
        });
    } else if (status == kABAuthorizationStatusAuthorized) {
        ABPeoplePickerNavigationController *peoleVC = [[ABPeoplePickerNavigationController alloc] init];
        peoleVC.peoplePickerDelegate = self;
        isPopView = NO;
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
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_DEPRECATED_IOS(2_0, 8_0)
{
    if (property == kABPersonPhoneProperty)
        {
            ABMutableMultiValueRef phoneMulti =  ABRecordCopyValue(person,kABPersonPhoneProperty);
            int index = (int)ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
            NSString *phone =  (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
            phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            iSeleperson.iMobile = phone;
            [self.tableView reloadData];
    }
    return NO;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0)
{
    if (property == kABPersonPhoneProperty)
    {
        ABMutableMultiValueRef phoneMulti =  ABRecordCopyValue(person,kABPersonPhoneProperty);
        int index =  (int)ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString *phone =  (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        iSeleperson.iMobile = phone;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
