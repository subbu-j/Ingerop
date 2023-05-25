({
    doInit : function(component, event, helper) {
        console.log('doing init');
        var getValue = component.get("c.getCurrentValue");
        var getOptions = component.get("c.getPicklistOptions");
        
        var params = {
            "recordId" : component.get("v.recordId"),
            "picklistField" : component.get("v.pathField"),
            "sObjectName" : component.get("v.sObjectName")            
        };
        
        console.log(params);
        
        getValue.setParams(params);
        getValue.setCallback(this, function(a){
            console.log(a.getReturnValue());
            component.set("v.currentValue", a.getReturnValue());
            component.set("v.valueDone", true);
            helper.buildPath(component, event, helper);
        });
        $A.enqueueAction(getValue);
        
        
        getOptions.setParams(params);
        getOptions.setCallback(this, function(a){
            console.log(a.getReturnValue());
            component.set("v.options", a.getReturnValue());
            component.set("v.picklistDone", true);
            helper.buildPath(component, event, helper);
            
            //index picklist index of current value
            //component.set(v.currentIndex, a.getReturnValue())
        });
        $A.enqueueAction(getOptions);        

        //do some streaming API subscribe stuff
        if (component.get("v.listenForChange")){
            console.log('going to get topic');

            var getTopic = component.get("c.dynamicTopic");

                getTopic.setParams({
                    "WhichObject" : component.get("v.sObjectName"), 
                    "Field" : component.get("v.pathField")
                });
                getTopic.setCallback(this, function(a){

                //create a streamer dynamically with given topicName
                var topicName = a.getReturnValue();
                console.log(topicName);

                //TODO: dealing with failure!
                $A.createComponent(
                    "c:Streamer", 
                    {"topic" : topicName },
                    function (topicAdded, status){
                        console.log("trying to create streamer");
                        console.log(status);

                        if (component.isValid()) {
                            var body = component.get("v.body");
                            body.push(topicAdded);
                            component.set("v.body", body);
                        }
                    }
                    );
            });
                $A.enqueueAction(getTopic);

            }
        },

        listener : function(component, event, helper) {
            console.log('heard an event');
            var message = event.getParam("message");
            var recordId = message.data.sobject.Id;
            var value = message.data.sobject[component.get("v.pathField")];

            if (recordId == component.get("v.recordId")){
                console.log("I care about this update: " + message.data.sobject);
                console.log(recordId + " : " + value);

                component.set("v.currentValue", value);
                helper.buildPath(component);
            }
        },

    //updates the field
    handleClick : function(component, event, helper){
        console.log("heard click");
        var target = event.target.title;
        
        //if you're allowed to change a value
        if (component.get("v.clickToChange")){
            console.log('changing value');
            
            //actually make the change          
                var doUpdate= component.get("c.setNewValue");
                var params = {
                    "recordId" : component.get("v.recordId"),
                    "picklistField" : component.get("v.pathField"),
                    "newValue" : target            
                };
                doUpdate.setParams(params);
                doUpdate.setCallback(this, function(a){
                    console.log(a.getReturnValue());
                    if (a.getState() === "SUCCESS") {                        
                        //reflect the change in the path component
                        component.set("v.currentValue", target);  
                        helper.buildPath(component, event, helper);
                    } else if (a.getState() === "ERROR"){
                        var errors = doUpdate.getError();
                        console.log(errors)
                        if (errors) {
                            //iterate the errors!
                            //TODO: duplicate rules errors ?
                            _.forEach(errors[0].pageErrors, function(value, key){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error:",
                                    "message": value.message,
                                    "type": "error",
                                    "mode": "dismissible"
                                });
                                toastEvent.fire();
                            });
                            _.forEach(errors[0].fieldErrors, function(value, key){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Field Error on " + key + " : ",
                                    "message": value[0].message,
                                    "type": "error",
                                    "mode": "dismissible"
                                });
                                toastEvent.fire();
                            });
                        }
                    }
                });
                $A.enqueueAction(doUpdate);            
            } 
        },        
    })