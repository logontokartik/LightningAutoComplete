({
    handleAutocomplete : function(component, event, helper) {
        var so = event.getParam("selectedOption");
        document.getElementById("result").innerHTML = 'Selected:' + so.Name;
    }
})