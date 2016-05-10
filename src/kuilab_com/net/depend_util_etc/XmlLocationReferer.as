package kuilab_com.net.depend_util_etc
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import kuilab_com.KuilabERROR;
	import kuilab_com.util.Map_applicationDomain;
	import kuilab_com.util.Util_Xml;
	import kuilab_com.util.Util_loader;
	
	/**<pre>一般在程序内部转换地址用，也就是资源服务（SrvGetAseet），而不是给外部加载服务用。
	 * 比如在某个swf资源包里面查找以绑定的类形式存在的资源。</pre>
	 */	
	public class XmlLocationReferer implements ILocationRefer
	{
		public function XmlLocationReferer( mapDoc:XML )
		{
			if( mapDoc )
				parseDoc( mapDoc ) ;
		}
				
		protected var mapPkg:* = new Dictionary ;
		protected var classMap:* ;
		protected var doc:XML ;
		//没考虑name就是个LocationData的情况。%%
		public function refer( name:Object, packagee:Object ):Object
		{
			/*var pkg:* = mapPkg[ packagee ] ;
			if( pkg ){
				return pkg[ tar ] ;
			}*/
			//在这里想要把字符串反射成类因为Loader域的问题不好搞。
				var pkg:* = mapPkg[ packagee ] ;
				if( pkg == null )
					return name ;
				var pkgDoc:XML = pkg[ pkg ] ;
				
				var item:XML = Util_Xml.getChildByAtt( pkgDoc, 'key', String( name ) ) ;
				
				if( item ){
					var ret:* = new XmlLocationData( item, packagee ) ;
						//MAP_packageKeyObject[ ret ] = packagee ;
					return ret ;
				}else
					return name ;
		}
		/**
		 * @param <pre>能根据类名字查到作为键名类的对象，也可以直接输入一个ApplicationDomain。不输入会在当前ApplicationDomain中查找。
		 * 如果键名类所在类定义域（ApplicationDomain）是禁止访问的，那么只能手动获取那个类然后传入。</pre>
		 */		
		public function setDoc( doc:XML, classMap:*=null ):void
		{
			this.doc = doc ;
		}
		
		//%%未实现有重复名称报错
		protected function parseDoc( doc:XML, classMap:*=null ):*
		{
			for each( var pkgNode:XML in doc.child('package') ){
				var pkgName:String = Util_Xml.getAtt( pkgNode, 'name' ).toString() ;
				
				var keyP:* ;
				if( pkgName.indexOf( 'class:' ) == 0  ){//用类做包名键，相关处理。
					pkgName = pkgName.replace( 'class:', '' ) ;
					if( classMap == null )
						classMap = ApplicationDomain.currentDomain ;
					if( classMap is ApplicationDomain ){
						Util_loader.getDefinition( classMap, pkgName ) ;
						if( ApplicationDomain( classMap ).hasDefinition( pkgName ) ){
							keyP = ApplicationDomain( classMap ).getDefinition( pkgName ) ;
						}
					}else
						keyP = classMap[ pkgName ] ;
					if( keyP == null )
						throw new Error( 'class {#} used for a key to storing missing .用来做包键名的类{#}没有找到。'.replace( pkgName ) ) ;
						
				}else
					keyP = pkgName ;
				var pkgObj:Object = new Dictionary ;
					pkgObj[ pkgObj ] = pkgNode ;
				mapPkg[ keyP ] = pkgObj ;
			}
		}
	}
}