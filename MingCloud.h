//
//  MingCloud.h
//
//  Created by mguo80 on 10/22/14.
//

#import <Foundation/Foundation.h>

@protocol MingCloud

@property (nonatomic, strong)   NSString *cloudName;

-(id)getObjectByKey:(NSString*)key;

/**
 * @param obj - NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary
 * @param key - string only
 * @return YES if succeed, NO if fail
 */
-(BOOL)setObject:(id)obj ByKey:(NSString*)key;

@end
