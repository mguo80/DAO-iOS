//
//  MingCloudWithParse.h
//
//  Created by Guo, Ming on 10/22/14.
//

#import <Foundation/Foundation.h>
#import "MingCloud.h"

@interface MingCloudWithParse : NSObject<MingCloud>

-(id)getObjectByKey:(NSString*)key;

/**
 * @param obj - NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary
 * @param key - string only
 * @return YES if succeed, NO if fail
 */
-(BOOL)setObject:(id)obj ByKey:(NSString*)key;

@end
