//
//  Product.m
//  Cookie
//
//  Created by Kaustubh on 13/09/15.
//  Copyright (c) 2015 Default. All rights reserved.
//

#import "Product.h"

#define kData           @"data"
#define kId             @"id"
#define kName           @"name"
#define kBrand          @"brand"
#define kPrice          @"price"
#define kImages         @"images"
#define kImagePath      @"path"


@implementation Product

-(id)initProductWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if (self)
    {
        NSDictionary *dataDictionary=dictionary[kData];
        _productName=dataDictionary[kName];
        _productId=[dictionary[kId] floatValue];
        _productBrand=dataDictionary[kBrand];
        _productPrice=[dataDictionary[kPrice] floatValue];
        NSArray *imagesArray=dictionary[kImages];
        if (imagesArray.count)
        {
            NSMutableArray *tempArray=[[NSMutableArray alloc] initWithCapacity:imagesArray.count];
            NSString *imageURL;
            for (NSDictionary *image in imagesArray)
            {
                imageURL=image[kImagePath];
                [tempArray addObject:imageURL];
            }
            _productImages=tempArray;
        }
        
    }
    return self;
}

@end
