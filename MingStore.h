//
//  MingStore.h
//
//  Created by Guo, Ming on 9/12/14.
//

#import <Foundation/Foundation.h>
#import "MingCloud.h"

@protocol MingStore

/**
 * disk store is backed up into a corresponding store in cloud
 */
@property (nonatomic, strong)   id<MingCloud> cloud;

/**
 * Synchronous
 * Get standard objective-c object (NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary) by key
 * @param key
 */
-(id)getObjectByKey:(NSString*)key;

/**
 * Synchronous
 * @param obj - NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary
 * @param key - string only
 */
-(BOOL)setObject:(id)obj ByKey:(NSString*)key;

/**
 * Synchronous
 * Get non-standard (user-defined, conforming to NSCoding) object by key
 */
-(id)getCustomObjectByKey:(NSString*)key;

/**
 * Synchronous
 * Set non-standard (user-defined) object by key
 * @param obj - must conform to NSCoding
 * @param key - string only
 */
-(BOOL)setCustomObject:(id<NSCoding>)obj ByKey:(NSString*)key;

@end
