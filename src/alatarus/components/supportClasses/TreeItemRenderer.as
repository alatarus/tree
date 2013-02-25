package alatarus.components.supportClasses
{
	import alatarus.components.Tree;
	
	import flash.events.Event;
	
	import spark.components.supportClasses.ItemRenderer;
	
	public class TreeItemRenderer extends ItemRenderer implements ITreeItemRenderer
	{
		public function TreeItemRenderer()
		{
			super();
		}
		
		private var _isBranch:Boolean = false;
		
		[Bindable("isBranchChange")]
		public function get isBranch():Boolean
		{
			return _isBranch;
		}
		
		public function set isBranch(value:Boolean):void
		{
			_isBranch = value;
			dispatchEvent(new Event("isBranchChange"));
		}
		
		private var _isOpen:Boolean = false;
		
		[Bindable("isOpenChange")]
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		public function set isOpen(value:Boolean):void
		{
			_isOpen = value;
			dispatchEvent(new Event("isOpenChange"));
		}
		
		private var _level:int = 0;

		[Bindable("levelChange")]
		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
			dispatchEvent(new Event("levelChange"));
		}
		
		private var _disclosureIcon:Class;

		[Bindable("disclosureIconChange")]
		public function get disclosureIcon():Class
		{
			return _disclosureIcon;
		}

		public function set disclosureIcon(value:Class):void
		{
			_disclosureIcon = value;
			dispatchEvent(new Event("disclosureIconChange"));
		}

		private var _icon:Class;

		[Bindable("iconChange")]
		public function get icon():Class
		{
			return _icon;
		}
		
		public function set icon(value:Class):void
		{
			_icon = value;
			dispatchEvent(new Event("iconChange"));
		}
		
		public function toggle():void
		{
			if (owner && owner is Tree)
			{
				if (isOpen)
				{
					(owner as Tree).closeNode(data);
				}
				else
				{
					(owner as Tree).openNode(data);
				}
			}
		}

	}
}