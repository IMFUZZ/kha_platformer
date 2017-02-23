package engine.command;

interface IInvoker {
	public var commands:Array<ICommand>;
	public function invokeCommands():Void;
}