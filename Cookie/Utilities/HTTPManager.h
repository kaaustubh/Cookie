//
//  HTTPManager.h
//  Cookie
//
//  Created by Kaustubh on 13/09/15.
//  Copyright (c) 2015 Default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPManager : NSObject

-(void)sendRequestForURL:(NSString*)urlString Success:(void(^)(NSData *data))success Failure: (void(^)(NSError *error))failure;
+ (id)sharedManager ;

@end
