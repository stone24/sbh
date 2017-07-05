//
//  BeMapServer.m
//  sbh
//
//  Created by RobinLiu on 15/7/14.
//  Copyright (c) 2015年 shenbianhui. All rights reserved.
//

#import "BeMapServer.h"
#import "ServerConfigure.h"
#import "MessageListModel.h"
#import "NSDictionary+Additions.h"
#import "BeAddressModel.h"
#import "CommonDefine.h"
#import "BeSpecialCarHttp.h"
#import "SBHHttp.h"

@implementation BeMapServer

- (void)doInquireSuggestAddressWithCity:(BeSpeCityModel *)city andText:(NSString *)text byCallBack:(void (^)(NSMutableArray *))callback failureCallback:(void (^)(NSString *))failureCallback
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kSpeRequestUrl,@"ZC5_getAddress"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    NSData *data1 = [@"sbh:sbhzuche123" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithFormat:@"Basic %@", [data1 base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    [request setValue:str forHTTPHeaderField:@"Authorization"];
    NSString *valueStr = [NSString stringWithFormat:@"access_token=%@&city=%@&input=%@", [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken],city.cityName,text];
    NSData *postData = [valueStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [request setHTTPBody:postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data!=nil)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            if([dict dictValueForKey:@"data"]!=nil)
            {
                NSDictionary *responseObject = [dict dictValueForKey:@"data"];
                for(NSDictionary *dict1 in [responseObject arrayValueForKey:@"place_data"])
                {
                    BeAddressModel *model = [[BeAddressModel alloc]init];
                    model.addressId = [dict1 stringValueForKey:@"uid" defaultValue:@""];
                    model.title = [dict1 stringValueForKey:@"displayname" defaultValue:@""];
                    model.address = [dict1 stringValueForKey:@"address" defaultValue:@""];
                    model.location = CLLocationCoordinate2DMake([[dict1 objectForKey:@"lat"] floatValue], [[dict1 objectForKey:@"lng"] floatValue]);
                    if(city.cityCode > 0)
                    {
                        model.city = city.cityCode;
                    }
                    else
                    {
                        model.city = city.cityName;
                    }
                    [dataArray addObject:model];
                }
            }
            callback(dataArray);
        }
        else
        {
            NSMutableArray *dataArray = [[NSMutableArray alloc]init];
            callback(dataArray);
        }
    }];
}

- (void)getSpecialCarCityWithCallback:(void (^)(NSMutableArray *))callback andFailure:(void (^)(NSError *))error
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kSpeRequestUrl,@"ZC4_getCityCar"];
    [BeSpecialCarHttp getPath:urlStr success:^(id dataArray)
     {
         callback(dataArray);
     }failure:^(NSError *failure)
     {
         error(failure);
     }];
}
- (void)getSearchHistoryWithCityName:(NSString *)CityName SuccessCallback:(void (^)(NSMutableArray *searchArray,BeAddressModel *homeModel,BeAddressModel *companyModel))callback andFailure:(void (^)(NSMutableArray *searchArray,BeAddressModel *homeModel,BeAddressModel *companyModel,NSError *error))failure
{
    NSMutableArray *searchArray = [[NSMutableArray alloc]init];
    BeAddressModel *companyModel = [[BeAddressModel alloc]init];
    BeAddressModel *homeModel = [[BeAddressModel alloc]init];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"ZuChe/GetHistoryAddress"];
    [[SBHHttp sharedInstance]postPath:urlStr withParameters:@{@"usertoken":[GlobalData getSharedInstance].token,@"CityName":CityName} showHud:NO success:^(NSDictionary *dict)
    {
        for(NSDictionary *member in [dict objectForKey:@"data"])
        {
            BeAddressModel *addressModel = [[BeAddressModel alloc]init];
            addressModel.title = [member stringValueForKey:@"CityAddress" defaultValue:@""];
            addressModel.address = [member stringValueForKey:@"Address" defaultValue:@""];
            addressModel.location = CLLocationCoordinate2DMake([[member stringValueForKey:@"Lat" defaultValue:@""] floatValue], [[member stringValueForKey:@"Lng" defaultValue:@""] floatValue]);
            addressModel.city = [member stringValueForKey:@"CityName" defaultValue:@""];
            [searchArray addObject:addressModel];
        }
        if([[dict objectForKey:@"home"] count] > 0)
        {
            NSDictionary *member = [[dict objectForKey:@"home"] firstObject];
            homeModel.title = [member stringValueForKey:@"CityAddress" defaultValue:@""];
            homeModel.address = [member stringValueForKey:@"Address" defaultValue:@""];
            homeModel.location = CLLocationCoordinate2DMake([[member stringValueForKey:@"Lat" defaultValue:@""] floatValue], [[member stringValueForKey:@"Lng" defaultValue:@""] floatValue]);
            homeModel.city = [member stringValueForKey:@"CityName" defaultValue:@""];
        }
        if([[dict objectForKey:@"company"] count] > 0)
        {
            NSDictionary *member = [[dict objectForKey:@"company"] firstObject];
            companyModel.title = [member stringValueForKey:@"CityAddress" defaultValue:@""];
            companyModel.address = [member stringValueForKey:@"Address" defaultValue:@""];
            companyModel.location = CLLocationCoordinate2DMake([[member stringValueForKey:@"Lat" defaultValue:@""] floatValue], [[member stringValueForKey:@"Lng" defaultValue:@""] floatValue]);
            companyModel.city = [member stringValueForKey:@"CityName" defaultValue:@""];
        }
        callback(searchArray,homeModel,companyModel);
    }failure:^(NSError *error)
    {
        failure(searchArray,homeModel,companyModel,error);
    }];
}
- (void)modifyAddressWithFlag:(NSString *)flag andModel:(BeAddressModel *)model Callback:(void (^)(void))callback andFailure:(void (^)(NSError *))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kServerHost,@"ZuChe/SetHomeOrCompanyAddress"];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"usertoken"] = [GlobalData getSharedInstance].token;
    para[@"flag"] = flag;
    para[@"CityName"] = model.city;
    para[@"Address"] = model.address;
    para[@"CityAddress"] = model.title;
    para[@"Lng"] = [NSString stringWithFormat:@"%.6f",model.location.longitude];
    para[@"Lat"] = [NSString stringWithFormat:@"%.6f",model.location.latitude];
     [[SBHHttp sharedInstance]postPath:urlStr withParameters:para showHud:NO success:^(id data)
      {
          callback();
      }failure:^(NSError *error)
      {
          failure(error);
      }];
}
@end
