//
//  ProductsManager.h
//  Cookie
//
//  Created by Kaustubh on 13/09/15.
//  Copyright (c) 2015 Default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductsManager : NSObject

+ (id)sharedManager;
-(void)getAllProductsForPageIndex:(int)index Completion:(void(^)(NSArray *array, NSError *error))completionBlock;

@end
