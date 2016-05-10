package kuilab_com.util
{
	import flash.utils.getQualifiedClassName;

	/**
	 * %%还未支持忽略大小写。
	 */
	public class Util_Xml
	{
		public function Util_Xml()
		{
		}
		
		public static const NODEKIND_element:String = 'element' ;
		public static const NODEKIND_comment:String = 'comment' ;
		public static const NODEKIND_processing_instruction:String = 'processing-instruction' ;
		public static const NODEKIND_text:String = 'text' ;
		public static const NODEKIND_attribute:String = 'attribute' ;
		
		public static function getAttOrChild( xml:XML, name:Object ):XML
		{
			var r:XMLList = xml.attribute( name ) ;
			if( r.length() > 0 )
				return r[0] ;
			return xml.child( name )[0] ;
		}
		
		public static function getChildByAtt( xml:XML, attName:Object, attValue:String ):XML
		{
			if( attName is String ){}
			else if( attName is QName ){}
				else throw new Error( '"attName" must be a String or a QName. Now it\'s a('+getQualifiedClassName( attName )+')' ) ; 
			for each( var node:XML in xml.children() )
			{
				var listAtt:XMLList = node.attribute( attName ) ;
				var nodeAtt:XML = listAtt[0] ;
				if( nodeAtt )
				{
					var nameNode:QName = nodeAtt.name() as QName ;
					if( attName is String )
					{
						if( nameNode.localName == attName )
						if( nameNode.uri == '' )
						if( attValue == nodeAtt.toString() )
							return node ;
					}else{//must be QName.
						if( nameNode.uri == QName( attName ).uri )
						if( nameNode.localName == QName( attName ).localName )
						if( attValue == nodeAtt.toString() )
							return node ;
					}
				}
			}
			return null ;
		}
		
		//public static function getChildByAttOrName
		/**建议使用原生的，除非有必要。因为转化成Array还是有运算量的。根本原因还是傻逼Adobe不给提供查询返回Array的方法。**/
		public static function getChildrenArray( xml:XML ):Array
		{
			/*if( xml == null )
				return null ;*/
			var arr:Array = [] ;
			for each( var j:XML in xml.children() )
			{
				arr.push( j ) ;
			}
			return arr ;
		}
		
		/**建议使用原生的，除非有必要。因为转化成Array还是有运算量的。根本原因还是傻逼Adobe不给提供原生查询返回Array的方法。**/
		public static function getAttArray( xml:XML ):Array
		{
			var ret:Array = [] ;
			for each( var att:XML in xml.attributes() ){
				ret.push( att ) ;
			}
			return ret ;
		}
		
		public static function getChildren( xml:XML, name:* ):Array
		{
			/*if( xml == null )
				return null ;*/
			var ret:Array = [] ;
			for each( var j:XML in xml.children() )
			{
				if( j.name() == name )
					ret.push( j ) ;
			}
			return ret ;
		}
		
		/**已知名字才可以查询，所以名字是已知的，也就无需返回名字，所以返回剥离了名字的内容部分。**///有病啊？谁家萨比会在一个节点里面写多个有相同名字的属性？
		public static function getAtt( xml:XML, attName:Object ):String
		{
			try{
				var att:XML = xml.attribute( attName )[0] ;
				return att.toString() ;
			}catch( e:* ){
				return null ;
			}
			return null ;
		}
		
		public static function getAttIgnoreCase( xml:XML, attNameOrRegExp:*, wholeWord:Boolean=true ):*{
			var regExp:RegExp ;
			if( attNameOrRegExp is RegExp )
				regExp = attNameOrRegExp ;
			else
				regExp =Util_RegExp.createIgnoreCase( attNameOrRegExp, wholeWord ) ;
			for each( var att:XML in xml.attributes() ){
				if( regExp.test( att.localName() ) ){
					return att.toString() ;
				}
			}
			return null ;
		}
		
		public static function attEqual( xml:XML, attName:Object, value:String ):Boolean
		{
			var list:XMLList = xml.attribute( attName ) ;
			if( list.length() )
				return String( list[0] ) == value ; 
			return false ;
		}
		
		public static function getChild( xml:XML, childName:Object ):XML
		{
			return xml.child( childName )[0] ;
		}
		
		public static function getChildStr( xml:XML, childName:Object ):String
		{
			return String( xml.child( childName )[0] ) ;
		}
		
		public static function getChildIgnoreCase( xml:XML, childNameOrRegExp:*, onlyFirstOne:Boolean=false, wholeWord:Boolean=true ):*
		{
			var regExp:RegExp ;
			if( childNameOrRegExp is RegExp )
				regExp = childNameOrRegExp ;
			else
				regExp = Util_RegExp.createIgnoreCase( childNameOrRegExp, wholeWord ) ;
			var ret:Array = [] ;
			for each( var ch:XML in xml.children() ){ c::d0{ var d:* = ch.localName() }
				if( regExp.test( ch.localName() ) ){
					if( onlyFirstOne )
						return ch ;
					else
						ret.push( ch ) ;
				}
			}
			if( ret.length == 0 )
				return null ;//如果onlyFirstOne为true，则与期待的返回值类型不符，从而引发类型错误。
			return ret ;
		}
		
		public static function isAttFalseOrNotExist( xml:XML, attName:Object ):Boolean
		{
			var list:XMLList = xml.attribute( attName ) ;
			if( list.length() > 0 )
			{
				switch( list[0].toString() )
				{
					case '0' :
					case 'false' :
					case '' :
					case 'null' :
					case 'undefined' :
						return true ;
					default :
						return false ;
				}
			}
			return true ;
		}
		
		public static function isAttTrueOrNotExist( xml:XML, attName:Object ):Boolean
		{
			var list:XMLList = xml.attribute( attName ) ;
			if( list.length() )
			{
				switch( list[0].toString() )
				{
					case '0' :
					case 'false' :
					case 'null' :
					case '' :
					case 'undefined' :
						return false ;
					default :
						return true ;
				}
			}
			return true ;
		}
		
		public static function getPath( node:XML ):Array
		{
			var path:Array = [] ;
			while( node )
			{
				path.unshift( node ) ; 
				node = node.parent() ;
			}
			return path ;
		}
		
		public static function childrenToArr( node:XML, fieldName:String="*" ):*
		{
			var arr:Array = [] ;
			var n:XML ;
			if( fieldName == '*' )
			{
				for each ( n in node.children() ) 
					arr.push( n.toXMLString() ) ;
			}else if( fieldName == '~' )
			{
				for each ( n in node.children() ) 
					arr.push( n.toString() ) ;
			}else{
				for each ( n in node.children() ) 
					arr.push( getAttOrChild( n, fieldName ).toString() ) ;
			}
			return arr ;
		}

										
	}
}