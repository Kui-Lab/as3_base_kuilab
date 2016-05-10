package kuilab_com.ui
{
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.flash_proxy;
	
	import kuilab_com.util.Util_timer;
	/**
	 * 设置长宽时不会缩放的Sprite。
	 */	
	public class NoScaleSprite extends Sprite{
		public var fillColor:uint = 0x0;
		public var fillAlpha:Number = 0x0;
		
		protected var settedW:uint
		protected var settedH:uint
		
		protected var invalid:Boolean = false ; ;
		
		public function NoScaleSprite( w:uint=1, h:uint=1 )
		{
			width = w ;
			height = h
		}
		
		public override function set width( value:Number ):void
		{
			settedW = value ;
			invalidate() ;
		}
		
		public override function set height( value:Number ):void
		{
			settedH = value ;
			invalidate() ;
		}
		
		public function invalidate():void
		{
			if( invalid )
				return ;
			invalid = true ;
			addEventListener( Event.EXIT_FRAME, function( e:Event ):void
			{
				removeEventListener( e.type, arguments.callee ) ;
				doRender() ;
			} ) ;
		}
		
		public function doRender():void
		{
			var g:Graphics = this.graphics ;
			g.beginFill( fillColor, fillAlpha ) ;
			g.drawRect( 0, 0, settedW, settedH );
			g.endFill() ;
			invalid = false ;
		}
	}
}