({
    doInit : function(component, event, helper) {
        console.log("doInit plante");
		console.log(component);
		component.set("v.isToggled", true);
        console.log("pas");
    },
    
    gotoURL : function (component, event, helper) {
        var isDesktop = $A.get("$Browser.isDesktop");
        if(isDesktop) {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "#/sObject/" + component.get('{!v.node.a.Id}') + "/view"
            });
            urlEvent.fire();   
        }
        else {
            sforce.one.navigateToSObject(component.get('{!v.node.a.Id}'));
        }
    },
    
	toggle : function(component, event, helper) {
        /*if (typeof jQuery !== "undefined" && typeof $j === "undefined") {
            $j = jQuery.noConflict(true);
        }
        var $j = jQuery.noConflict();      
        var ctx = component.getElement();*/
        
        /*var theId = "wrapper_" + component.get('{!v.node.a.Id}');
        var toggle = component.find(theId);
        $A.util.toggleClass(toggle, 'isHidden');*/
        //$j(theId, ctx).toggle();
        component.set("v.isToggled", !component.get('{!v.isToggled}'));
	},
    
	toggleContacts : function(component, event, helper) {
        /*if (typeof jQuery !== "undefined" && typeof $j === "undefined") {
            $j = jQuery.noConflict(true);
        }
        var $j = jQuery.noConflict();                
        var ctx = component.getElement();*/
        
        /*var theId = "contacts_" + component.get('{!v.node.a.Id}');
        console.log('trying to find : ' + theId);
        var toggle = component.find(theId);
        console.log(toggle);
        $A.util.toggleClass(toggle, 'isHidden');*/
        //$j(theId, ctx).toggle();
        component.set("v.isToggledContacts", !component.get('{!v.isToggledContacts}'));
	}
})