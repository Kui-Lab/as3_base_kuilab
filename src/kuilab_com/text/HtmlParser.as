package kuilab_com.text
{
	import flash.utils.Dictionary;
	
	import kuilab_com.KuilabERROR;

	public class HtmlParser
	{
		
		public function get mapTag():Object
		{
			return mapTag_;
		}
		public function set mapTag(value:Object):void
		{
			mapTag_ = value;
		}
		
		public function regTagParse( tag:Object, f:Function ):void
		{
			if( f != null )
				mapTag_[ tag ] = f ;
			else
				delete mapTag_[ tag ] ;
		}
		
		public function dispose():void
		{
			
		}
		
		public function HtmlParser()
		{
			
		}
		
		protected var mapTag_:Object = new Dictionary ;
		//protected var chLine:String = '\n\r' ;
		/**内容是以String形式给TextField的，而不是Xml，所以虽格式要符合XML，但要输出为String。**/
		public function parse( xml:Object ):*
		{
			if( xml is XML )
			{}else{
				var ignoreWhitespace:Boolean = XML.ignoreWhitespace ;
				XML.ignoreWhitespace = false ;
				xml = XML( String( xml ) ) ;
			}
			const tText:Object = 'text' ;
			const tELEm:Object = 'element' ;
			var ret:String = proc( ( xml as XML ) );
			XML.ignoreWhitespace = ignoreWhitespace ;
			return ret ;
			function proc( node:XML ):String
			{
				var str:String
				if( node.nodeKind() == tText )
				{
					str = node.toString() ;
					if( str == '\r\n' ) return null ;//%%这里可以用正则。
					return str ;
				}
				var name:String = node.localName() ;
				var vStr:Array = [] ;
				
				var xml处理只处理了最外层的标记未处理嵌套的
				if( node.nodeKind() == tELEm )//元素节点。
					for each( var c:XML in node.children() )
						vStr.push( proc( c ) ) ;
				else
					return '' ;
				str = vStr.join( '' ) ;
				if( mapTag_.hasOwnProperty( name ) )
					return mapTag_[ name ]( node, str ) ;
				name = node.name() ;
				//str之前的值没用了
				var strAtt:* = [] ;
					for each( var att:XML in node.attributes() )
						strAtt.push( att.name(),'="',att.toString(),'"' ) ;
					if( strAtt.length )
						strAtt = ' '+strAtt.join( '' ) ;
				str = ['<',name,strAtt,'>',str,'</',name,'>'].join('') ;
				return str ;
			}
		}
		
		protected function toAttStr( list:XMLList ):String
		{
			var arr:Array = [] ;
			for each( var att:XML in list )
				arr.push( att.name()+'="'+att.toString()+'"' ) ;
			if( arr.length )
				arr.unshift( ' ' ) ;
			return arr.join( '' ) ;
		}

		/*public function parse( text:String, lineBreakChar:Object = null ):void
		{
			var IDX:* = 'index' ;
			var STR:* = 0 ;
			var NAM:* = 'NAM' ;
			var ITV:* = 'ITV' ;
			var regTag:RegExp = /<\/?(?P<NAM>\w+)\/?>/gms 
			var mat:Array = [{index:0}] ;//这一个是为了防止出错，在算完后要废弃。
			var lst:* = null ;
			while( true )
			{
				var m:Object = regTag.exec( text ) ;
				if( m )
				{
					m[ITV] = m[IDX] - end( lst )+1 ;
					lst = m ;
				}else
					break ;
			}
			mat.splice( 0, 1 ) ;
			
			var text2:String = '' ;
			var stkM:Array = [] ;
			var stkT:Array = [] ;
			var stkP:Array = [] ;
			var sPr:String
			var sNx:String
			for each( m in mat )
			{
				var tag:String = m[STR] ;
				switch( tag.indexOf( '/' ) )
				{
					case -1 ://围堵标记的开始<a>
						stkM.push( m ) ; 
						//stkT
						m[NAM]
						break ;
					case 1 ://围堵标记的结束</a>
						var m1:*
						var top:Boolean
						for each( var ms:* in stkM ) 
						{
							if( ms[NAM] == m[NAM] )
							{
								m1 = ms ;
								break ;
							}
						}
						for( var j:uint = stkM.length-1; j > 0; j-- ) 
						{
							stkM[j][NAM]
						}
						var idxP:uint
						var strX:String ;
						var strP:String ;
						if( top )//不包含其它标签。
						{//<cur>aaa<b>aa</b>aa</cur>
							strX.substr( m1[ITV], endL(m) )
							
							var sCr:String = sPr + stkT.pop() + sNx ;
							stkT.push( mapTag[ NAM ]( sCr ) ) ;
						}else{//中间还包含其它标签
							
						}
						
							strP = mapTag[ NAM ](  ) ;
						break ;
					default ://空标记，<a/>
						break ;
				}
			}
			return
			function end( mat:Object ):uint
			{
				return mat[IDX]+String(mat[STR]).length ;
			}
			function cut( mat:Object, next:Object ):uint
			{
				return null
			}
			function endL( mat:Object ):uint
			{
				return null
			}
		}
		
		protected function readLine( line:String, arr:Array ):*
		{
			var regTag:RegExp = /<\/?\w+>|<\w+\/?>/gms ;
			do{
				var m:Object = regTag.exec( line ) ;
			}while( m && ( arr.push( m ) ) )
		}*/
	}
}