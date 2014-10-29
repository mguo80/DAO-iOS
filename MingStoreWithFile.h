//
//  MingStoreWithFile.h
//
//  Created by Guo, Ming on 9/12/14.
//

#import <Foundation/Foundation.h>
#import "MingStore.h"

@interface MingStoreWithFile : NSObject<MingStore>

@property (nonatomic, strong)   NSString *name;

-(instancetype)initWithCloud:(id<MingCloud>)cloud;

/**
 * Initializer
 * @param name - the name of the cache folder under which all store files are located, it is not store file name
 * @param cloud - cloud store, pass nil if cloud is not needed
 */
-(instancetype)initWithName:(NSString *)name andCloud:(id<MingCloud>)cloud;

-(id)getObjectByKey:(NSString *)key;

-(BOOL)setObject:(id)obj ByKey:(NSString *)key;

-(id)getCustomObjectByKey:(NSString *)key;

-(BOOL)setCustomObject:(id<NSCoding>)obj ByKey:(NSString *)key;

@end
