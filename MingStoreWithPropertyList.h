//
//  MingStoreWithPropertyList.h
//
//  Created by mguo80 on 10/12/14.
//

#import <Foundation/Foundation.h>
#import "MingStore.h"

@interface MingStoreWithPropertyList : NSObject<MingStore>

/**
 * Property list file name (excluding file path)
 * All property list files are put into the same file path, so application must make sure that file name is unique to avoid collision
 */
@property (nonatomic, strong)   NSString *name;

/**
 * Initializer
 * @param name - property list file name (excluding file path)
 * @param cloud - cloud store, pass nil if cloud is not needed
 */
-(instancetype)initWithName:(NSString *)name andCloud:(id<MingCloud>)cloud;

-(id)getObjectByKey:(NSString*)key;

-(BOOL)setObject:(id)obj ByKey:(NSString*)key;

-(BOOL)removeObjectByKey:(NSString *)key;

-(id)getCustomObjectByKey:(NSString*)key;

-(BOOL)setCustomObject:(id<NSCoding>)obj ByKey:(NSString*)key;

@end
