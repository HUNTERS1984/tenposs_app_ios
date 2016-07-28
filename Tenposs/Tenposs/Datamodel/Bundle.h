//
//  Bundle.h
//  Tenposs
//
//  Created by Phúc Nguyễn on 7/28/16.
//  Copyright © 2016 Tenposs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bundle : NSObject
{
    NSMutableDictionary * dictionary;
}
-(id)           put:(NSString*) key value:(id) value;
-(void)         clear;
-(BOOL)         getBoolean:(NSString*) key;
-(id)           get:(NSString*) key;
-(NSInteger)    getInt:(NSString*) key;
-(long)    getLong:(NSString*) key;
-(double)       getDouble:(NSString*) key;

@end
