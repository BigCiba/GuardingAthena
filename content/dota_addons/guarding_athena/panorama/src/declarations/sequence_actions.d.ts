/**
 * 基础动作，这是一个每帧都会运行的东西，直到完成。
 */
declare class BaseAction {
	/**
	 * 启动函数：在动作开始执行前被调用。
	 */
	start(): void;
	/**
	 * 更新函数：每帧调用一次，直到它返回false，表示动作已经完成。
	 */
	update(): boolean;
	/**
	 * 完成函数：更新函数完成后调用
	 */
	finish(): void;
	/**
	 * 动作集：动作序列，一般会依次运行序列里的动作
	 */
	actions: BaseAction[];
}

/**
 * 依次运行一组其他动作的动作。
 */
declare class RunSequentialActions extends BaseAction {
}

/**
 * 同时运行多个动作的动作。当所有子动作完成后，该动作就完成了。
 */
declare class RunParallelActions extends BaseAction {
}

/**
 * 并行运行多个动作，但每个动作之间的开始时间略有错开。
 * @param staggerSeconds 错开秒数
 */
declare class RunStaggeredActions extends BaseAction {
	constructor(staggerSeconds: number);
}

/**
 * 运行一套动作集，直到其中一个动作完成后全部停止
 * @param continueOtherActions 是否继续完成剩余动作
 */
declare class RunUntilSingleActionFinishedAction extends BaseAction {
	constructor(continueOtherActions: boolean);
}

/**
 * 简单地运行一个函数的动作。你可以将函数参量依次填在调用构造函数的后续参量里
 * @param f 函数
 * @param arguments 可变参量
 */
declare class RunFunctionAction extends BaseAction {
	constructor(f: Function, ...arguments: any[]);
}

/**
 * 简单地运行一个返回布尔值函数的动作，动作将会持续运行，函数返回false将会停止。你可以将函数参量依次填在调用构造函数的后续参量里
 * @param f 函数
 * @param arguments 可变参量
 */
declare class WaitForConditionAction extends BaseAction {
	constructor(f: Function, ...arguments: any[]);
}

/**
 * 等待若干秒后再继续的动作
 * @param seconds 等待秒数
 */
declare class WaitAction extends BaseAction {
	constructor(seconds: number);
}

/**
 * 等待一帧的动作
 */
declare class WaitOneFrameAction extends BaseAction {
}

/**
 * 等待事件在给定的面板上发生的动作。（例：onmouseover事件）
 * @param panel 面板
 * @param eventName 事件名
 */
declare class WaitForEventAction extends BaseAction {
	constructor(panel: Panel, eventName: string);
}

/**
 * 运行一个动作，直到它完成，或者直到它达到超时
 * @param action 动作
 * @param timeoutDuration 超时时间
 * @param continueAfterTimeout 是否在动作超时后继续运行
 */
declare class ActionWithTimeout extends BaseAction {
	constructor(action: BaseAction, timeoutDuration: number, continueAfterTimeout: boolean);
}

/**
 * 打印调试信息的动作
 * @param msg 调试信息
 */
declare class PrintAction extends BaseAction {
	constructor(msg: string);
}

/**
 * 在面板上添加class的动作
 * @param panel 面板
 * @param panelClass class名
 */
declare class AddClassAction extends BaseAction {
	constructor(panel: Panel, panelClass: string);
}

/**
 * 在面板上移除class的动作
 * @param panel 面板
 * @param panelClass class名
 */
declare class RemoveClassAction extends BaseAction {
	constructor(panel: Panel, panelClass: string);
}

/**
 * 在面板上切换class的动作
 * @param panel 面板
 * @param panelSlot class名
 * @param panelClass class名
 */
declare class SwitchClassAction extends BaseAction {
	constructor(panel: Panel, panelSlot: string, panelClass: string);
}

/**
 * 等待class出现在面板上的动作
 * @param panel 面板
 * @param panelClass class名
 */
declare class WaitForClassAction extends BaseAction {
	constructor(panel: Panel, panelClass: string);
}

/**
 * 设置整数对话框变量的动作
 * @param panel 面板
 * @param dialogVariable 变量名
 * @param value 值
 */
declare class SetDialogVariableIntAction extends BaseAction {
	constructor(panel: Panel, dialogVariable: string, value: number);
}

/**
 * 动画设置整数对话框变量的动作
 * @param panel 面板
 * @param dialogVariable 变量名
 * @param start 开始值
 * @param end 结束值
 * @param seconds 持续秒数
 */
declare class AnimateDialogVariableIntAction extends BaseAction {
	constructor(panel: Panel, dialogVariable: string, start: number, end: number, seconds: number);
}

/**
 * 设置进度条的动作
 * @param progressBar 进度条
 * @param value 值
 */
declare class SetProgressBarValueAction extends BaseAction {
	constructor(progressBar: ProgressBar, value: number);
}

/**
 * 动画设置进度条的动作
 * @param progressBar 进度条
 * @param startValue 开始值
 * @param endValue 结束值
 * @param seconds 持续秒数
 */
declare class AnimateProgressBarAction extends BaseAction {
	constructor(progressBar: ProgressBar, startValue: number, endValue: number, seconds: number);
}

/**
 * 动画设置三段进度条的动作
 * @param progressBar 进度条
 * @param startValue 开始值
 * @param endValue 结束值
 * @param seconds 持续秒数
 */
declare class AnimateProgressBarWithMiddleAction extends BaseAction {
	constructor(progressBar: ProgressBar, startValue: number, endValue: number, seconds: number);
}

/**
 * 播放声音效果
 * @param soundName 
 */
declare function PlaySoundEffect(soundName: string): void;

/**
 * 播放音效的动作
 * @param soundName 音效名
 */
declare class PlaySoundEffectAction extends BaseAction {
	constructor(soundName: string);
}

/**
 * 播放音效的动作
 * @param soundName 音效名
 */
declare class PlaySoundAction extends BaseAction {
	constructor(soundName: string);
}

/**
 * 播放音效持续一段时间的动作
 * @param soundName 音效名
 * @param duration 持续时间
 */
declare class PlaySoundForDurationAction extends BaseAction {
	constructor(soundName: string, duration: number);
}

/**
 * 基类，可以定义一个类来继承LerpAction，然后重载applyProgress函数来做一个持续一段时间的线性插值。
 * @param seconds 持续秒数
 */
declare class LerpAction extends BaseAction {
	constructor(seconds: number);
}

/**
 * 启动一个动作，并持续运行，直到完成。
 * @param action 动作
 */
declare function RunSingleAction(action: BaseAction): void;
