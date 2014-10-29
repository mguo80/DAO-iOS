//
//  MingStoreWithPreference.h
//
//  Created by Guo, Ming on 10/9/14.
//

#import <Foundation/Foundation.h>
#import "MingStore.h"

@interface MingStoreWithPreference : NSObject<MingStore>

/**
 * Initializer
 * param cloud - cloud store, pass nil if cloud is not needed
 */
-(instancetype)initWithCloud:(id<MingCloud>)cloud;

-(id)getObjectByKey:(NSString*)key;

-(BOOL)setObject:(id)obj ByKey:(NSString*)key;

-(id)getCustomObjectByKey:(NSString*)key;

-(BOOL)setCustomObject:(id<NSCoding>)obj ByKey:(NSString*)key;

@end
