package alatarus.collections
{
	import mx.collections.CursorBookmark;
	import mx.collections.HierarchicalCollectionView;
	import mx.collections.HierarchicalData;
	import mx.collections.ICollectionView;
	import mx.collections.IHierarchicalData;
	import mx.collections.IList;
	import mx.collections.IViewCursor;
	import mx.core.mx_internal;
	import mx.utils.UIDUtil;
	
	use namespace mx_internal;
	
	public class HierarchicalList extends HierarchicalCollectionView implements IList
	{
		public function HierarchicalList(hierarchicalData:IHierarchicalData=null, argOpenNodes:Object=null)
		{
			super(hierarchicalData, argOpenNodes);
		}
		
		private var _cursor:IViewCursor;
		
		public function isOpen(node:Object):Boolean
		{
			return openNodes[UIDUtil.getUID(node)];
		}
		
		public function isBranch(node:Object):Boolean
		{
			return source.hasChildren(node);
		}
		
		public function addItem(item:Object):void
		{
			addChild(null, item);
		}
		
		public function addItemAt(item:Object, index:int):void
		{
			if (index == 0)
			{
				addChildAt(null, item, index);
				return;
			}
			
			_cursor ||= createCursor();
			_cursor.seek(CursorBookmark.FIRST, index);
			
			var parent:Object = getParentItem(_cursor.current);
			
			if (parent)
			{
				index -= getItemIndex(parent) + 1;
			}
			
			addChildAt(parent, item, index);
		}
		
		public function getItemAt(index:int, prefetch:int=0):Object
		{
			if (index < 0 || index >= length)
				throw new Error("index " + index + " is out of bounds");
			
			_cursor ||= createCursor();
			_cursor.seek(CursorBookmark.FIRST, index);
			return _cursor.current;
		}
		
		public function getItemIndex(item:Object):int
		{
			_cursor ||= createCursor();
			_cursor.findAny(item);
			return int(_cursor.bookmark.value);
		}
		
		public function removeAll():void
		{
			source = new HierarchicalData();
		}
		
		public function removeItemAt(index:int):Object
		{
			_cursor ||= createCursor();
			_cursor.seek(CursorBookmark.FIRST, index);
			return _cursor.remove();
		}
		
		public function setItemAt(item:Object, index:int):Object
		{
			_cursor ||= createCursor();
			_cursor.seek(CursorBookmark.FIRST, index);
			
			var parent:Object = getParentItem(_cursor.current);
			var children:ICollectionView = getChildren(parent);
			
			if (parent)
			{
				index -= getItemIndex(parent) + 1;
			}
			
			_cursor = children.createCursor();
			_cursor.seek(CursorBookmark.FIRST, index);
			_cursor.remove();
			_cursor.insert(item);

			return item;
		}
		
		public function toArray():Array
		{
			var result:Array = [];
			_cursor ||= createCursor();
			_cursor.seek(CursorBookmark.FIRST);
			
			while (!_cursor.afterLast)
			{
				result.push(_cursor.current);
				_cursor.moveNext();
			}
			
			return result;
		}
		
		override public function createCursor():IViewCursor
		{
			return new HierarchicalListCursor(this, treeData, source);
		}
	}
}