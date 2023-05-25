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
    },
    
    listener : function(component, event, helper) {
        console.log('heard an event');
    },
    
    //updates the field
    handleClick : function(component, event, helper){
        var target = event.target.title;
        
        //if you're allowed to change a value
        if (component.get("v.clickToChange")){
            console.log('changing value');
            
            //actually make the change
            //    public static void setNewValue(string recordId, string picklistField, string newValue){            
            var doUpdate= component.get("c.setNewValue");
            var params = {
                "recordId" : component.get("v.recordId"),
                "picklistField" : component.get("v.pathField"),
                "newValue" : target            
            };
            doUpdate.setParams(params);
            doUpdate.setCallback(this, function(a){
                console.log(a.getReturnValue());
                //reflect the change in the path component
            	component.set("v.currentValue", target);  
            	helper.buildPath(component, event, helper);
            });
            $A.enqueueAction(doUpdate);            
        } 
    }
})