// ActionScript file

package tv.superawesome.sdk.advertiser {
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.StatusEvent;
	import tv.superawesome.sdk.advertiser.SAExtensionContext;
	
	public class SAVerifyInstall {
		
		// define a default callback so that it's never null and I don't have
		// to do a check every time I want to call it
		private var installCallback: Function = function(success: Boolean): void{};
	
		// instance vars
		private static var name: String = "SAVerifyInstall";
		
		// singleton variable
		private static var _instance: SAVerifyInstall;
		public static function getInstance(): SAVerifyInstall {
			if (!_instance) { _instance = new SAVerifyInstall(); }
			return _instance;
		}
		
		public function SAVerifyInstall () {
			if (_instance) {
				throw new Error("Singleton... use getInstance()");
			}
			
			// add callback
			SAExtensionContext.current().context().addEventListener(StatusEvent.STATUS, nativeCallback);
			
			// instrance 
			_instance = this;
		}
		
		public function handleInstall (callback: Function): void {
			// get a valid cpi callback, no matter what
			installCallback = callback != null ? callback : installCallback;
			
			// call create
			SAExtensionContext.current().context().call("SuperAwesomeAdvertiserAIRSAVerifyInstall", name);
		}
		
		public function nativeCallback(event:StatusEvent): void {
			// get data
			var data: String = event.code;
			var content: String = event.level;
			
			// parse data
			var meta: Object = com.adobe.serialization.json.JSON.decode(data);
			var callName:String = null;
			var success:Boolean = false;
			var call:String = null;
			
			// get properties (right way)
			if (meta.hasOwnProperty("name")) {
				callName = meta.name;
			}
			if (meta.hasOwnProperty("success")) {
				success = meta.success;
			}
			if (meta.hasOwnProperty("callback")) {
				call = meta.callback;
			}
			
			// check to see target
			if (callName != null && call != null && callName.indexOf(name) >= 0) {
				
				if (call.indexOf("HandleInstall") >= 0) {
					installCallback (success);
				}
			}
		}
	}
	
}