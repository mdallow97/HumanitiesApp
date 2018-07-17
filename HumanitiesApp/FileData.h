//
//  FileData.h
//  HumanitiesApp
//
//  Created by Michael Dallow on 7/9/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef FileData_h
#define FileData_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FileData : NSObject

@property int fileType;
@property NSString *fileName;
@property UIImage *previewImage;

// store document
// store presentation
@property UIImage *image;
// store audio
// store video
// store AR

@end


#endif /* FileData_h */
