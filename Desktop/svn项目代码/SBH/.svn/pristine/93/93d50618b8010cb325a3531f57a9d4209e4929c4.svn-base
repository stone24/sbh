//
//  selectPerson.m
//  sbh
//
//  Created by musmile on 14-7-21.
//  Copyright (c) 2014年 shenbianhui. All rights reserved.
//

#import "selectPerson.h"
#import "NSDictionary+Additions.h"

@implementation selectPerson
- (NSMutableArray *)array
{
    if (_array == nil) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

-(id)init
{
    self =[super init];
    if (self)
    {
        _iId = @"";
        _iType = @"";
        _iGender = @"";
        _iName = @"";
        _iCredtype = @"";
        _iCredNumber = @"";
        _iMobile = @"";
        _iInsquantity =[NSString stringWithFormat:@"%d", [GlobalData getSharedInstance].insquantity];
        _iInsprice = @"";
        _iOftencred = @"";
        _iBirthday = @"";
        _iFromType = @"";
        _depid = @"";
        _rolename = @"";
        _owcb = @"";
        _rtcb = @"";
    }
    return self;
}
- (id)initWithDict:(NSDictionary *)member andFromType:(NSString *)type
{
    if(self = [super init])
    {
        _iId = [member stringValueForKey:@"id" defaultValue:@""];
        _iType = [member stringValueForKey:@"typecode" defaultValue:@"ADT"];
        _iGender =[member stringValueForKey:@"gender" defaultValue:@""];
        _depid = [member stringValueForKey:@"depid" defaultValue:@""];
        _iName = [member stringValueForKey:@"name" defaultValue:@""];
        _iCredtype = [member stringValueForKey:@"cardtype" defaultValue:@""];
        if ([_iCredtype isEqualToString:@"1"]) {
            _iCredtype = @"身份证";
        }
        else  if ([_iCredtype isEqualToString:@"2"]) {
            _iCredtype = @"护照";
        }
        else  if ([_iCredtype isEqualToString:@"3"]) {
            _iCredtype = @"回乡证";
        }
        else if ([_iCredtype isEqualToString:@"4"]) {
            _iCredtype = @"同胞证";
        }
        else if ([_iCredtype isEqualToString:@"5"]) {
            _iCredtype = @"军人证";
        }
        else if ([_iCredtype isEqualToString:@"6"]) {
            _iCredtype = @"警官证";
        }
        else if ([_iCredtype isEqualToString:@"7"]) {
            _iCredtype = @"港澳通行证";
        }
        else if ([_iCredtype isEqualToString:@"8"]) {
            _iCredtype = @"其他证件";
        }
        else
        {
            _iCredtype = @"其他证件";
        }
        _rolename = [member stringValueForKey:@"rolename" defaultValue:@""];
        _iCredNumber = [member stringValueForKey:@"cardno" defaultValue:@""];
        if([[member stringValueForKey:@"mobile"defaultValue:@""] length] > 0)
        {
            _iMobile = [member stringValueForKey:@"mobile" defaultValue:@""];
        }
        else
        {
            _iMobile = [member stringValueForKey:@"mobilephone" defaultValue:@""];
        }
        _iInsquantity = [NSString stringWithFormat:@"%d",[GlobalData getSharedInstance].insquantity];
        _iInsprice = @"";
        _iOftencred = @"";
        _iBirthday = [member stringValueForKey:@"birthday" defaultValue:@""];
        _iFromType = type;
    }
    return self;
}
@end
