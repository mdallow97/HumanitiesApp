//
//  FileData.m
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/9/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "FileData.h"

@implementation FileData

- (void) storeImage: (UIImage *) image
{
    self->_image = image;
    self->_previewImage = image;
}

- (void) storeDescription: (NSString *) description
{
    self->_fileDescription = description;
}

@end
