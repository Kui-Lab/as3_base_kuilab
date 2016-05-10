package kuilab_com.animation
{
	public class CirculatorUserCtl extends Circulator
	{
		public function CirculatorUserCtl( animationDspObj:Array, speed:int=1, horiOrVerti:Boolean=true, paneLength:Object=0 )
		{
			super( animationDspObj, speed, horiOrVerti, paneLength ) ;
		}
		
		protected var speedTemp:Number ;
		
		public function pause():void
		{
			
		}
		
		public function prev():void
		{
			if( speed > 0 ){
				oritRevert() ;
			}else{
			}
			if( pauseCunt >= 0 )
				pauseCunt = 0 ;
		}
		
		public function next():void
		{
			if( speed < 0 ){
				oritRevert() ;
			}else{
			}
			if( pauseCunt >= 0 )
				pauseCunt = 0 ;
		}
		
		public function isRunning():Boolean
		{
			
		}
		
		protected function oritRevert():void
		{
			speed = - speed ;
			
		}
		
	}
}