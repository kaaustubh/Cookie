//
//  ProductsManager.m
//  Cookie
//
//  Created by Kaustubh on 13/09/15.
//  Copyright (c) 2015 Default. All rights reserved.
//

#import "ProductsManager.h"
#import "Reachability.h"
#import "HTTPManager.h"
#import "Product.h"


#define kProductsURL            @"https://www.zalora.com.my/mobile-api/women/clothing/?maxItems=10&page=%d"
#define kMetadata               @"metadata"
#define kResults                @"results"
#define kCachedProductPlistName @"/CachedProducts.plist"

@interface ProductsManager()
{
    HTTPManager *httpManager;
}

@end

@implementation ProductsManager

+ (id)sharedManager
{
    static ProductsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)getAllProductsForPageIndex:(int)index Completion:(void(^)(NSArray *array, NSError *error))completionBlock
{
    Reachability *reachability=[Reachability reachabilityForInternetConnection];
    NSString *urlStr=[NSString stringWithFormat:kProductsURL,index];
    if (reachability.currentReachabilityStatus!=NotReachable)
    {
        httpManager=[HTTPManager sharedManager];
        [httpManager sendRequestForURL:urlStr Success:^(NSData *data)
         {
             NSError *error;
             NSDictionary *dictionaryFromData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             if (!error)
             {
                 [self saveProducts:(dictionaryFromData[@"metadata"])[@"results"]];
                 if (completionBlock)
                 {
                     completionBlock ([self getAllProductsFromDictionary:(dictionaryFromData[@"metadata"])[@"results"]], nil);
                 }
             }
             else
             {
                 if (completionBlock)
                 {
                     completionBlock(nil, error);
                 }
             }
          }
        Failure:^(NSError * error)
        {
            if (completionBlock)
            {
                completionBlock(nil, error);
            }
        }];
    }
    else
    {
        //Get cached data if avialable
        NSArray *cachedProducts=[self getCachedProducts];
        if (cachedProducts)
        {
            if (completionBlock)
            {
                completionBlock ([self getAllProductsFromDictionary:cachedProducts], nil);
            }
        }
        else
        {
            NSError *error=[NSError errorWithDomain:@"CookieApp" code:NSURLErrorNotConnectedToInternet userInfo:nil];
            if (completionBlock)
            {
                completionBlock (nil, error);
            }
            
        }
        
    }
}

-(NSArray*)getAllProductsFromDictionary:(NSArray*)dictionary
{
    Product *newProduct;
    NSMutableArray *arr=[NSMutableArray array];
    for (NSDictionary *productDictionary in dictionary)
    {
        newProduct=[[Product alloc] initProductWithDictionary:productDictionary];
        [arr addObject:newProduct];
    }
    return arr;
}

-(BOOL)saveProducts:(NSArray*)newProducts
{
    NSArray *prevProdutcs=[self getCachedProducts];
    NSMutableArray *allProducts=[NSMutableArray arrayWithArray:prevProdutcs];
    [allProducts addObjectsFromArray:newProducts];
    NSDictionary *dictionaryToSave=[NSDictionary dictionaryWithObject:allProducts forKey:@"products"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentsDir = [paths objectAtIndex:0];

    NSString *path = [documentsDir stringByAppendingString:kCachedProductPlistName];
    NSLog(@"Path :: %@",path);
    BOOL success = [dictionaryToSave writeToFile:path atomically:YES];
    return success;
}

-(NSArray *)getCachedProducts
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistLocation = [documentsDirectory stringByAppendingPathComponent:kCachedProductPlistName];
    NSDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistLocation];
    NSArray *products=plistDict[@"products"];
    return products;
}

@end
