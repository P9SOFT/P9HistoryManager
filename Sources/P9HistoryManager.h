//
//  P9HistoryManager.h
//  
//
//  Created by Tae Hyun Na on 2016. 3. 4.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

@import Foundation;

/*!
 Block code definition to handling when undo/redo action.
 Parameter NSDictionary is given data when calling step.
 */
typedef void(^P9HistoryManagerAction)(NSDictionary * _Nullable);

/*!
 P9HistoryManager
 
 Developers can easily manage events of history like undo/redo function with P9HistoryManager.
 */
@interface P9HistoryManager : NSObject

/*!
 Get shared default singleton module.
 @returns Return singleton P9HistoryManager object
 */
+ (P9HistoryManager * _Nonnull)defaultP9HistoryManager;

/*!
 Get count of all event nodes in history for given key.
 @param key History identifier string
 @returns Number of event nodes in history for given key.
 */
- (NSUInteger)countOfAllStepsForKey:(NSString * _Nullable)key;

/*!
 Get count of previous event nodes at current step in history for given key.
 @param key History identifier string
 @returns Number of previous event nodes at current step in history for given key.
 */
- (NSUInteger)countOfPrevStepsForKey:(NSString * _Nullable)key;

/*!
 Get count of next event nodes at current step in history for given key.
 @param key History identifier string
 @returns Number of next event nodes at current step in history for given key.
 */
- (NSUInteger)countOfNextStepsForKey:(NSString * _Nullable)key;

/*!
 Do step action of history for given key.
 If current step is not last, it'll rewrite all events from current step to last.
 @param key History identifier string
 @param stepName Name of step to referencing after.
 @param undoAction Block code for undo action.
 @param redoAction Block code for redo action.
 @returns Result of add step action succeed.
 */
- (BOOL)stepForKey:(NSString * _Nullable)key stepName:(NSString * _Nullable)stepName parameters:(NSDictionary * _Nullable)parameters undoAction:(P9HistoryManagerAction _Nullable)undoAction redoAction:(P9HistoryManagerAction _Nullable)redoAction;

/*!
 Get previous step name of history for given key.
 @param key History identifier string
 @returns Name of step.
 */
- (NSString * _Nullable)peekPrevStepNameForKey:(NSString * _Nullable)key;

/*!
 Get next step name of history for given key.
 @param key History identifier string
 @returns Name of step.
 */
- (NSString * _Nullable)peekNextStepNameForKey:(NSString * _Nullable)key;

/*!
 Do undo action of history for given key.
 @param key History identifier string
 @returns Result of undo action succeed.
 */
- (BOOL)undoStepForKey:(NSString * _Nullable)key;

/*!
 Do redo action of history for given key.
 @param key History identifier string
 @returns Result of redo action succeed.
 */
- (BOOL)redoStepForKey:(NSString * _Nullable)key;

/*!
 Clear all steps in history for given key.
 @param key History identifier string
 */
- (void)clearAllStepsForKey:(NSString * _Nullable)key;

/*!
 Clear all steps of all history.
 */
- (void)clearAllSteps;

@end
