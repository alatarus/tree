package alatarus.components.supportClasses
{
	import spark.components.IItemRenderer;
	
	public interface ITreeItemRenderer extends IItemRenderer
	{
		function get isBranch():Boolean;
		function set isBranch(value:Boolean):void;
		
		function get isOpen():Boolean;
		function set isOpen(value:Boolean):void;
		
		function get level():int;
		function set level(value:int):void;
		
		function get disclosureIcon():Class;
		function set disclosureIcon(value:Class):void;
		
		function get icon():Class;
		function set icon(value:Class):void;
		
		function toggle():void;
	}
}