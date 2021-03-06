//
//  P9HistoryManager.m
//  
//
//  Created by Tae Hyun Na on 2016. 3. 4.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

#import "P9HistoryManager.h"

#define     kStepNameKey        @"stepNameKey"
#define     kParameterKey       @"parameterKey"
#define     kUndoActionKey      @"undoActionKey"
#define     kRedoActionKey      @"redoActionKey"

@interface P9HistoryManager ()
{
    NSMutableDictionary *_historiesForKey;
    NSMutableDictionary *_stepIndexForKey;
}
@end

@implementation P9HistoryManager

- (instancetype)init
{
    if( (self = [super init]) != nil ) {
        if( (_historiesForKey = [NSMutableDictionary new]) == nil ) {
            return nil;
        }
        if( (_stepIndexForKey = [NSMutableDictionary new]) == nil ) {
            return nil;
        }
    }
    
    return self;
}

+ (P9HistoryManager *)defaultP9HistoryManager
{
    static dispatch_once_t once;
    static P9HistoryManager *sharedInstance;
    dispatch_once(&once, ^{sharedInstance = [[self alloc] init];});
    return sharedInstance;
}

- (NSUInteger)countOfAllStepsForKey:(NSString *)key
{
    if( key.length == 0 ) {
        return 0;
    }
    
    NSUInteger count = 0;
    
    @synchronized(self) {
        count = [_historiesForKey[key] count];
    }
    
    return count;
}

- (NSUInteger)countOfPrevStepsForKey:(NSString *)key
{
    if( key.length == 0 ) {
        return 0;
    }
    
    NSUInteger count = 0;
    
    @synchronized(self) {
        NSNumber *indexNumber = _stepIndexForKey[key];
        if( indexNumber != nil ) {
            count = indexNumber.unsignedIntegerValue + 1;
        }
    }
    
    return count;
}

- (NSUInteger)countOfNextStepsForKey:(NSString *)key
{
    if( key.length == 0 ) {
        return 0;
    }
    
    NSUInteger count = 0;
    
    @synchronized(self) {
        if( (count = [_historiesForKey[key] count]) > 0 ) {
            NSNumber *indexNumber = _stepIndexForKey[key];
            if( indexNumber != nil ) {
                count -= (indexNumber.unsignedIntegerValue + 1);
            }
        }
    }
    
    return count;
}

- (BOOL)stepForKey:(NSString *)key stepName:(NSString *)stepName parameters:(NSDictionary *)parameters undoAction:(P9HistoryManagerAction)undoAction redoAction:(P9HistoryManagerAction)redoAction
{
    if( key.length == 0 ) {
        return NO;
    }
    NSMutableDictionary *stepNode = [NSMutableDictionary new];
    if( stepNode == nil ) {
        return NO;
    }
    if( stepName.length > 0 ) {
        stepNode[kStepNameKey] = stepName;
    }
    if( parameters.count > 0 ) {
        stepNode[kParameterKey] = parameters;
    }
    if( undoAction != nil ) {
        stepNode[kUndoActionKey] = undoAction;
    }
    if( redoAction != nil ) {
        stepNode[kRedoActionKey] = redoAction;
    }
    
    @synchronized(self) {
        NSMutableArray *queue = _historiesForKey[key];
        NSUInteger nextStepIndex;
        if( queue == nil ) {
            if( (queue = [NSMutableArray new]) == nil ) {
                return NO;
            }
            _historiesForKey[key] = queue;
            nextStepIndex = 0;
        } else {
            NSUInteger count = [_historiesForKey[key] count];
            nextStepIndex = [_stepIndexForKey[key] unsignedIntegerValue] + 1;
            if( nextStepIndex < count ) {
                [queue removeObjectsInRange:NSMakeRange(nextStepIndex, count-nextStepIndex)];
            }
        }
        [queue addObject:stepNode];
        _stepIndexForKey[key] = @(nextStepIndex);
    }
    
    return YES;
}

- (NSString *)peekPrevStepNameForKey:(NSString *)key
{
    if( key.length == 0 ) {
        return nil;
    }
    
    NSMutableDictionary *prevStepNode = nil;
    @synchronized(self) {
        NSNumber *stepIndexNumber = _stepIndexForKey[key];
        if( stepIndexNumber == nil ) {
            return nil;
        }
        NSUInteger stepIndex = stepIndexNumber.unsignedIntegerValue;
        if( stepIndex == 0 ) {
            return nil;
        }
        NSMutableArray *queue = _historiesForKey[key];
        prevStepNode = queue[stepIndex-1];
    }
    
    return prevStepNode[kStepNameKey];
}

- (NSString *)peekNextStepNameForKey:(NSString *)key
{
    if( key.length == 0 ) {
        return nil;
    }
    
    NSMutableDictionary *nextStepNode = nil;
    @synchronized(self) {
        NSNumber *stepIndexNumber = _stepIndexForKey[key];
        if( stepIndexNumber == nil ) {
            return nil;
        }
        NSMutableArray *queue = _historiesForKey[key];
        NSUInteger stepIndex = stepIndexNumber.unsignedIntegerValue;
        if( stepIndex >= (queue.count-1) ) {
            return nil;
        }
        nextStepNode = queue[stepIndex+1];
    }
    
    return nextStepNode[kStepNameKey];
}

- (BOOL)undoStepForKey:(NSString *)key
{
    if( key.length == 0 ) {
        return NO;
    }
    
    NSMutableDictionary *stepNode = nil;
    @synchronized(self) {
        NSNumber *stepIndexNumber = _stepIndexForKey[key];
        if( stepIndexNumber == nil ) {
            return NO;
        }
        NSMutableArray *queue = _historiesForKey[key];
        NSUInteger stepIndex = stepIndexNumber.unsignedIntegerValue;
        stepNode = queue[stepIndex];
        if( stepIndex == 0 ) {
            [_stepIndexForKey removeObjectForKey:key];
        } else {
            _stepIndexForKey[key] = @(stepIndex-1);
        }
    }
    
    P9HistoryManagerAction action = stepNode[kUndoActionKey];
    if( action != nil ) {
        action(stepNode[kParameterKey]);
    }
    
    return YES;
}

- (BOOL)redoStepForKey:(NSString *)key
{
    if( key.length == 0 ) {
        return NO;
    }
    
    NSMutableDictionary *stepNode = nil;
    @synchronized(self) {
        NSMutableArray *queue = _historiesForKey[key];
        NSNumber *stepIndexNumber = _stepIndexForKey[key];
        NSUInteger stepIndex;
        if( stepIndexNumber == nil ) {
            if( queue.count == 0 ) {
                return NO;
            }
            stepIndex = 0;
        } else {
            stepIndex = stepIndexNumber.unsignedIntegerValue + 1;
        }
        if( stepIndex > (queue.count-1) ) {
            return NO;
        }
        stepNode = queue[stepIndex];
        _stepIndexForKey[key] = @(stepIndex);
    }
    
    P9HistoryManagerAction action = stepNode[kRedoActionKey];
    if( action != nil ) {
        action(stepNode[kParameterKey]);
    }
    
    return YES;
}

- (void)clearAllStepsForKey:(NSString *)key
{
    if( key.length == 0 ) {
        return;
    }
    
    @synchronized(self) {
        [_historiesForKey removeObjectForKey:key];
        [_stepIndexForKey removeObjectForKey:key];
    }
}

- (void)clearAllSteps
{
    @synchronized(self) {
        [_historiesForKey removeAllObjects];
        [_stepIndexForKey removeAllObjects];
    }
}

@end
