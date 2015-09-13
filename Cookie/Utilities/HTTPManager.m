//
//  HTTPManager.m
//  Cookie
//
//  Created by Kaustubh on 13/09/15.
//  Copyright (c) 2015 Default. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPManager


+ (id)sharedManager {
    static HTTPManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    self = [super init];
    return self;
}


-(void)sendRequestForURL:(NSString*)urlString Success:(void(^)(NSData *data))success Failure: (void(^)(NSError *error))failure
{
    NSURLSession *session=[NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if(error && failure)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
            
        }
        else if(success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(data);
            });
        }
        
    }] resume];
}


@end
