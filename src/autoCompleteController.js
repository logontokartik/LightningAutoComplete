({
    
    init: function(component, event, helper) {       
        if (typeof jQuery !== "undefined" && typeof $j === "undefined") {
            $j = jQuery.noConflict(true);;
        }        
        
       	component.set("v.ready", true);
       	helper.initHandlers(component);
    }
    
})