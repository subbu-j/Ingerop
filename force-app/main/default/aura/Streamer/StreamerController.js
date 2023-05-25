({
    doInit : function(component, event, helper) {
        console.log('doing init on streamer');
        
        // Retrieve the session id and initialize cometd
        var sessionAction = component.get("c.sessionId");
        
        sessionAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state  === "SUCCESS") {
                var sessionId = response.getReturnValue();
                var authstring = "OAuth " + sessionId;
                
                //authenticate to the Streaming API
                $.cometd.init({
                    url: window.location.protocol + '//' + window.location.hostname + '/cometd/36.0/',
                    requestHeaders: { Authorization: authstring },
                    appendMessageTypeToURL : false
                });
                $.cometd.subscribe('/topic/'+component.get("v.topic"), function (message){
                    //placeholder.  for real, emit as a message event
                    console.log(message);
                    console.log(message.data.sobject);
                    var appEvent = $A.get("e.c:StreamerEvent");
					appEvent.setParams({ "message" : message });
					appEvent.fire();
                });
                	
            }
        });
        $A.enqueueAction(sessionAction);        
    }
})