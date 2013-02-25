package alatarus.collections
{
	import mx.collections.CursorBookmark;
	import mx.collections.HierarchicalCollectionView;
	import mx.collections.HierarchicalCollectionViewCursor;
	import mx.collections.ICollectionView;
	import mx.collections.IHierarchicalCollectionViewCursor;
	import mx.collections.IHierarchicalData;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class HierarchicalListCursor extends HierarchicalCollectionViewCursor implements IHierarchicalCollectionViewCursor
	{
		public function HierarchicalListCursor(collection:HierarchicalCollectionView,
											   model:ICollectionView,
											   hierarchicalData:IHierarchicalData)
		{
			super(collection, model, hierarchicalData);
		}
		
		override public function findAny(values:Object):Boolean
		{
			if (values is XMLList || values is XML)
				return super.findAny(values);
			
			seek(CursorBookmark.FIRST);
			
			var done:Boolean = false;
			
			while (!done)
			{
				if (values === current)
					return true;
				
				done = !moveNext();
			}
			
			return false;
		}
		
		override public function findLast(values:Object):Boolean
		{
			if (values is XMLList || values is XML)
				return super.findLast(values);
			
			seek(CursorBookmark.LAST);
			
			var done:Boolean = false;
			while (!done)
			{
				if (values === current)
					return true;
				
				done = !movePrevious();
			}
			
			return false;
		}
	}
}