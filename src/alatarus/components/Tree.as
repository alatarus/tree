package alatarus.components
{
	import alatarus.collections.HierarchicalList;
	import alatarus.components.supportClasses.ITreeItemRenderer;
	import alatarus.events.TreeEvent;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.HierarchicalCollectionView;
	import mx.collections.HierarchicalData;
	import mx.collections.ICollectionView;
	import mx.collections.IHierarchicalData;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	
	import spark.components.List;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when a branch is closed or collapsed.
	 *
	 *  @eventType alatarus.events.TreeEvent.ITEM_CLOSE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="itemClose", type="alatarus.events.TreeEvent")]
	
	/**
	 *  Dispatched when a branch is opened or expanded.
	 *
	 *  @eventType alatarus.events.TreeEvent.ITEM_OPEN
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="itemOpen", type="alatarus.events.TreeEvent")]
	
	/**
	 *  Dispatched when a branch open or close is initiated.
	 *
	 *  @eventType alatarus.events.TreeEvent.ITEM_OPENING
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="itemOpening", type="alatarus.events.TreeEvent")]

	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  Specifies the icon that is displayed next to a parent item that is open so that its
	 *  children are displayed.
	 *
	 */
	[Style(name="disclosureOpenIcon", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 *  Specifies the icon that is displayed next to a parent item that is closed so that its
	 *  children are not displayed (the subtree is collapsed).
	 *
	 */
	[Style(name="disclosureClosedIcon", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 *  Specifies the folder open icon for a branch item of the tree.
	 */
	[Style(name="folderOpenIcon", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 *  Specifies the folder closed icon for a branch item of the tree.
	 */
	[Style(name="folderClosedIcon", type="Class", format="EmbeddedFile", inherit="no")]
	
	/**
	 *  Specifies the default icon for a leaf item.
	 */
	[Style(name="defaultLeafIcon", type="Class", format="EmbeddedFile", inherit="no")]
	
	public class Tree extends List
	{
		public function Tree()
		{
			super();
		}
		
		protected var hierarchicalList:HierarchicalList;
		
		public function openNode(node:Object):void
		{
			var event:TreeEvent;
			
			if (hasEventListener(TreeEvent.ITEM_OPENING))
			{
				event = new TreeEvent(TreeEvent.ITEM_OPENING, false, true, node);
				event.opening = true;
				dispatchEvent(event);
			}
			
			if (event.isDefaultPrevented())
				return;
			
			hierarchicalList.openNode(node);
			hierarchicalList.refresh();
			
			if (hasEventListener(TreeEvent.ITEM_OPEN))
			{
				event = new TreeEvent(TreeEvent.ITEM_OPEN);
				event.item = node;
				dispatchEvent(event);
			}
		}
		
		public function closeNode(node:Object):void
		{
			var event:TreeEvent;
			
			if (hasEventListener(TreeEvent.ITEM_OPENING))
			{
				event = new TreeEvent(TreeEvent.ITEM_OPENING, false, true, node);
				event.opening = false;
				dispatchEvent(event);
			}
			
			if (event.isDefaultPrevented())
				return;
			
			hierarchicalList.closeNode(node);
			hierarchicalList.refresh();
			
			if (hasEventListener(TreeEvent.ITEM_CLOSE))
			{
				event = new TreeEvent(TreeEvent.ITEM_CLOSE);
				event.item = node;
				dispatchEvent(event);
			}
		}
		
		private var _iconFunction:Function;

		/**
		 * Icon function. Signature <code>function(item:Object, level:int, isBranch:Boolean, isOpen:Boolean ):Class</code>.
		 */
		public function get iconFunction():Function
		{
			return _iconFunction;
		}

		public function set iconFunction(value:Function):void
		{
			_iconFunction = value;
		}

		override public function set dataProvider(value:IList):void
		{
			if (hierarchicalList === value)
				return;
			
			if (hierarchicalList)
			{
				hierarchicalList.filterFunction = null;
				hierarchicalList.refresh();
			}
			
			if (value is HierarchicalList)
			{
				hierarchicalList = value as HierarchicalList;
			}
			else if (value is IHierarchicalData)
			{
				hierarchicalList = new HierarchicalList(value as IHierarchicalData);
			}
			else if (value is HierarchicalCollectionView)
			{
				var hcw:HierarchicalCollectionView = HierarchicalCollectionView(value)
				hierarchicalList = new HierarchicalList(hcw.source);
				hierarchicalList.sort = hcw.sort;
				hierarchicalList.filterFunction = hcw.filterFunction;
				hierarchicalList.refresh();
			}
			else if (value is ICollectionView)
			{
				hierarchicalList = new HierarchicalList(new HierarchicalData(value));
			}
			else if (value)
			{
				hierarchicalList = new HierarchicalList(new HierarchicalData(new ListCollectionView(value)));
			}
			else
			{
				hierarchicalList = null;
			}
			
			super.dataProvider = hierarchicalList;
		}
		
		override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
		{
			super.updateRenderer(renderer, itemIndex, data);
			
			var treeRenderer:ITreeItemRenderer = renderer as ITreeItemRenderer;
			
			if (treeRenderer)
			{
				var isOpen:Boolean = hierarchicalList.isOpen(data);
				var isBranch:Boolean = hierarchicalList.isBranch(data);
				var level:int = hierarchicalList.getNodeDepth(data);
				
				var icon:Class;
				
				if (iconFunction != null)
				{
					icon = iconFunction(data, level, isBranch, isOpen);
				}
				else if (isBranch)
				{
					icon = isOpen ? getStyle("folderOpenIcon") : getStyle("folderClosedIcon")
				}
				else
				{
					icon = getStyle("defaultLeafIcon");
				}
				
				treeRenderer.isBranch = isBranch;
				treeRenderer.level = level;
				treeRenderer.isOpen = isOpen;
				treeRenderer.disclosureIcon = isOpen ? getStyle("disclosureOpenIcon") : getStyle("disclosureClosedIcon");
				treeRenderer.icon = icon;
			}
		}
		
		override protected function adjustSelectionAndCaretUponNavigation(event:KeyboardEvent):void
		{
			super.adjustSelectionAndCaretUponNavigation(event);
			
			if (!selectedItem || !hierarchicalList.isBranch(selectedItem))
				return;
			
			var navigationUnit:uint = mapKeycodeForLayoutDirection(event);
			
			if (navigationUnit == Keyboard.LEFT && hierarchicalList.isOpen(selectedItem))
			{
				closeNode(selectedItem);
			}
			else if (navigationUnit == Keyboard.RIGHT && !hierarchicalList.isOpen(selectedItem))
			{
				openNode(selectedItem);
			}
		}
	}
}