//
//  SDAFParseAPIClient.h
//  menu
//
//  Created by Olivier Delecueillerie on 15/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"

@interface SDAFParseAPIClient : AFHTTPClient

+ (SDAFParseAPIClient *)sharedClient;
- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate;

@end
