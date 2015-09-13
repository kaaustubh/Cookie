//
//  Product.h
//  Cookie
//
//  Created by Kaustubh on 13/09/15.
//  Copyright (c) 2015 Default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, strong, readonly) NSString *productName;
@property (readonly) float productId;
@property (nonatomic, strong, readonly) NSArray *productImages;
@property (nonatomic, strong, readonly) NSString *productBrand;
@property (readonly) float productPrice;

-(id)initProductWithDictionary:(NSDictionary*)dictionary;

@end
