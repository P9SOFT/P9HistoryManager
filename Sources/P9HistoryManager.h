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
typedef void(^P9HistoryManagerAction)(NSDictionary *);

/*!
 P9HistoryManager
 
 Developers can easily manage events of history like undo/redo function with P9HistoryManager.
 */
@interface P9HistoryManager : NSObject

/*!
 Get shared default singleton module.
 @returns Return singleton P9HistoryManager object
 */
+ (P9HistoryManager *)defaultManager;

/*!
 Get count of all event nodes in history for given key.
 @param key History identifier string
 @returns Number of event nodes in history for given key.
 */
- (NSUInteger)countOfAllStepsForKey:(NSString *)key;

/*!
 Get count of previous event nodes at current step in history for given key.
 @param key History identifier string
 @returns Number of previous event nodes at current step in history for given key.
 */
- (NSUInteger)countOfPrevStepsForKey:(NSString *)key;

/*!
 Get count of next event nodes at current step in history for given key.
 @param key History identifier string
 @returns Number of next event nodes at current step in history for given key.
 */
- (NSUInteger)countOfNextStepsForKey:(NSString *)key;

/*!
 Do step action of history for given key.
 If current step is not last, it'll rewrite all events from current step to last.
 @param key History identifier string
 @param stepName Name of step to referencing after.
 @param undoAction Block code for undo action.
 @param redoAction Block code for redo action.
 @returns Result of add step action succeed.
 */
- (BOOL)stepForKey:(NSString *)key stepName:(NSString *)stepName parameters:(NSDictionary *)parameters undoAction:(P9HistoryManagerAction)undoAction redoAction:(P9HistoryManagerAction)redoAction;

/*!
 Get previous step name of history for given key.
 @param key History identifier string
 @returns Name of step.
 */
- (NSString *)peekPrevStepNameForKey:(NSString *)key;

/*!
 Get next step name of history for given key.
 @param key History identifier string
 @returns Name of step.
 */
- (NSString *)peekNextStepNameForKey:(NSString *)key;

/*!
 Do undo action of history for given key.
 @param key History identifier string
 @returns Result of undo action succeed.
 */
- (BOOL)undoStepForKey:(NSString *)key;

/*!
 Do redo action of history for given key.
 @param key History identifier string
 @returns Result of redo action succeed.
 */
- (BOOL)redoStepForKey:(NSString *)key;

/*!
 Clear all steps in history for given key.
 @param key History identifier string
 */
- (void)clearAllStepsForKey:(NSString *)key;

/*!
 Clear all steps of all history.
 */
- (void)clearAllSteps;

@end
