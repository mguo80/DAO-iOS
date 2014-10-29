//
//  MingDAO.h
//
//  Created by Guo, Ming on 9/12/14.
//

#import <Foundation/Foundation.h>
#import "MingStore.h"

@interface MingDAO : NSObject

/**
 * Application interacts with DAO on memory, which is persistent on disk store automatically
 */
@property (nonatomic, strong)   id<MingStore> store;

/**
 * Initializer
 * @param store - instance of a disk store which is used to persist DAO content
 */
-(instancetype)initWithStore:(id<MingStore>)store;

/**
 * Synchronous
 * Get standard objective-c object (NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary) by key
 * @param key
 * @return NSObject
 */
-(id)getObjectByKey:(NSString*)key;

/**
 * Synchronous
 * Set object by key
 * @param obj - NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary (conform to NSCoding)
 * @param key - string only
 * @return YES if succeed, NO if fail
 */
-(BOOL)setObject:(id)obj ByKey:(NSString *)key;

/**
 * Synchronous
 * Get non-standard (user-defined, conforming to NSCoding) object by key
 * @return NSObject
 */
-(id)getCustomObjectByKey:(NSString*)key;

/**
 * Synchronous
 * Set non-standard (user-defined) object by key
 * @param obj - must conform to NSCoding
 * @param key - string only
 * @return YES if succeed, NO if fail
 */
-(BOOL)setCustomObject:(id<NSCoding>)obj ByKey:(NSString*)key;

@end
