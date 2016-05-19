
/////////////////////////////////////////////////////////////

// 版权归汪汪所有,您可以自由使用,但是禁止用于开发生化武器,
// 核武器,以及各种可能的能够毁灭地球或宇宙或者是对蚂蚁
// 进行种族灭绝的科学研究....

// 科学家敬告诸位coder:吸烟有害健康....

// @link http://aaaqe.com/

// 作者: 汪汪 (被kuilab抄袭)


/////////////////////////////////////////////////////////////

package kuilab_com.ui.util
{
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 使用方法：“[Frame(factoryClass="loader.Preloader")]” 
	 */
	public class Preloader extends MovieClip
	{
		
		/*public static function set mainClassName( className:String ):void
		{
			nameMainClass_ = className ;
		}*/
		
		protected var nameMainClass_:String ;
		
		public function Preloader()
		{
			super();
			//stage$ = stage ;
			createChildren();
			init();
			nameMainClass_ = loaderInfo.url.split( '/' ).pop() ;
			nameMainClass_ = nameMainClass_.replace( '.swf', '' ) ;
		}
		
		private function init():void
		{
			addEventListener( Event.ADDED_TO_STAGE, added, false, 0, true );
			added(null);
		}
		private var tf:TextField;
		
		private var progressBar:Shape;
		private function createChildren():void
		{
			
			tf = new TextField();
			tf.width = 200;
			tf.height = 100;
			tf.text = "";
			addChild(tf);
			progressBar = new Shape();
			addChild( progressBar );
			with( progressBar.graphics )
			{
				beginFill(Math.random() * 0xFFFFFF);
				drawRect(0,0,100,5);
			}
		}
		
		private function added( evt:Event = null ):void
		{
			//var loaderInfo:LoaderInfo;
			if(stage)
			{
				removeEventListener( Event.ADDED_TO_STAGE,added );
				//loaderInfo = root.loaderInfo;
				//loaderInfo.addEventListener(ProgressEvent.PROGRESS , progress,false,0,true);
				//loaderInfo.addEventListener( Event.COMPLETE, complete, false, 0, true );
				addEventListener( Event.ENTER_FRAME, enterFrame, false, 0, true );
				progressBar.x = ( stage.stageWidth - 100 ) / 2 ;
				progressBar.y = ( stage.stageHeight - progressBar.height ) / 2 ;
				tf.x = progressBar.x ;
				tf.y = progressBar.y + progressBar.height + 5 ;
			}
		}
		
		private function progress( evt:ProgressEvent ):void
		{
		}
		
		private function complete( evt:Event ):void
		{
		}
		
		//private var count:int = 0 ;
		private function enterFrame( evt:Event ):void
		{
			if( loaderInfo.bytesLoaded != loaderInfo.bytesTotal )
			{
				var loaderInfo:LoaderInfo = root.loaderInfo ;
				var percent:Number = loaderInfo.bytesLoaded / loaderInfo.bytesTotal;
				progressBar.width =  percent * 200 ;
				tf.text = Math.round( percent )*100 +"%\n剩余 " +  ( loaderInfo.bytesTotal -loaderInfo.bytesLoaded ) + '\t字节' ;
			}else{
				tf.text = '\n加载完成,初始化...'+nameMainClass_ ;
				if( ApplicationDomain.currentDomain.hasDefinition( nameMainClass_ ) )
				{
					var clazz:Class = getDefinitionByName( nameMainClass_ ) as Class;
					new( clazz )( stage ) ;
					stage.removeChild( this );
					removeEventListener(Event.ENTER_FRAME,enterFrame);
				}
			}
			
		}
	}
}