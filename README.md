AutoComplete Lightning
===================
 1. Register for new DE Edition  - https://developer.salesforce.com/en/signup
 2.  Login to the newly created Developer Org and register a namespace by navigating to  Setup → Create → Packages, Click Edit and Register a namespace prefix (it can be anything simple and unique)
 3.  Enable Lightning Components, Setup→ Develop → Lightning Component and check the box Enable Lightning Components and click save
 4.  Install the below Unmanaged Package in your Salesforce Org - https://login.salesforce.com/packaging/installPackage.apexp?p0=04tB000000011BX
 5.  Change the namespace in all the components installed via package to your org’s namespace. 
Eg: Navigate to File→ Open Lightning Component →  requires.cmp. Change the below to your namespace  
```
<aura:registerEvent name="requiresReady" type="stech2:requiresReady"/> 
```
 6.  Open Developer Console, click on File → New → Apex class, name the apex class “AutoCompleteController” and copy paste the below code  
 ```
 public class AutocompleteController {
    @AuraEnabled
    public static List<sObject> getSuggestions(String sObjectType, String term, String fieldsToGet, Integer limitSize) {
        // could add in logic to remove possible duplicate fields
        String fields = fieldsToGet.length() > 0 ? ',' + fieldsToGet : ''; 
    	String soql = 
            ' SELECT Name, Id ' + String.escapeSingleQuotes(fields) +
            ' FROM '   + String.escapeSingleQuotes(sObjectType) +
            ' WHERE Name Like \'' + String.escapeSingleQuotes(term) + '%\'' +
            ' LIMIT ' + limitSize;
        return Database.query(soql);
    }
}

 ```
 7.  Open Developer Console, click on File → New → Lightning Event and name the event “autoCompleteEvt”, copy the below code
 ```
 <aura:event type="COMPONENT">
		<aura:attribute name="selectedOption" type="Object"/>
</aura:event>

 ```
 9. Open Developer Console, click on File → New → Lightning Component and name the component “autoComplete” and provide any description and copy the below code. (change the namespace accordingly) 
```
<aura:component controller="stech2.AutocompleteController">
    <aura:attribute name="sObjectType" required="true" type="String" description="Name of the sObject that will be filtered" />
    <aura:attribute name="fields" type="String[]" default="" description="List of fields to get with each record"/>
    <aura:attribute name="limit" type="Integer" default="10" description="Limits the number returned to this value" />
    <aura:attribute name="inputLabel" type="String" default="Find" description="Label for text input"/>
    <aura:attribute name="ready" type="Boolean" default="false" description="Used to check if resources have been loaded"/>

    <aura:registerEvent name="autocompleteEvent" type="stech2:autocompleteEvt"/>
    
    <stech2:requires 
        baseUrl="/resource/"
		scripts="{jquery:'jquery/jquery.js',jqueryui:'jqueryui/jquery-ui.min.js', typeahead: 'typeahead/bootstrap.min.js'}"
      	deps="{jqueryui:['jquery']}"
                     styles="{typeahead:'typeahead/bootstrap.min.css',jqueryui:'jqueryui/jquery-ui.css',bs_autocomplete:'typeahead/bs_autocomplete.css'}"
		requiresReady="c.init"
    />
            <div>
        <label>Enter search term for {!v.sObjectType} </label>&nbsp;
        <input class="autocomplete" type="text"/>
    </div>
</aura:component>

```
10. Click on the Controller option on the right and copy/paste the below code 
```
({
    
    init: function(component, event, helper) {       
        if (typeof jQuery !== "undefined" && typeof $j === "undefined") {
            $j = jQuery.noConflict(true);;
        }        
        
       	component.set("v.ready", true);
       	helper.initHandlers(component);
    }
    
})

```   
11.  Click on the Helper on the right and copy / paste the below code
```
({  
    initHandlers: function(component) {
    	var ready = component.get("v.ready");
 
        if (ready === false) {
           	return;
        }
        
        var ctx = component.getElement();
        
        $j(".autocomplete", ctx).autocomplete({
            minLength: 2,
            delay: 500,
            source: function(request, response) {
                var action = component.get("c.getSuggestions");
                var fieldsToGet = component.get("v.fields");
               
                action.setParams({
                    "sObjectType": component.get("v.sObjectType"),
                    "term": request.term,
                    "fieldsToGet": fieldsToGet.join(),
                    "limitSize": component.get("v.limit")
                });
                
                action.setCallback(this, function(a) {
                	var suggestions = a.getReturnValue();
                    suggestions.forEach(function(s) {
                        s["label"] = s.Name,
                        s["value"] = s.Id
                    });
                    response(suggestions);
                });
                
                $A.run(function() {
                    $A.enqueueAction(action); 
                });
            },
            select: function(event, ui) {  
                event.preventDefault();
                var ctx = component.getElement();
                $j(".autocomplete", ctx).val(ui.item.label);
                    
                var selectionEvent = component.getEvent("autocompleteEvent");
                selectionEvent.setParams({
                    selectedOption: ui.item 
                });
                selectionEvent.fire();
            }
        });
    }
})

```

12.  Click on the Rendered on the right and copy / paste the below code
```
({
    
	afterRender : function(component, helper) {
	    this.superAfterRender();
            helper.initHandlers(component);
	}
})

```
13.  Save the Component
14.  Create a Lightning App by clicking File → New → Lightning App. Name the app and copy/paste the code below (change the namespace)
```
<aura:application>
    <div class="container-fluid">
        <div class="jumbotron">
          <h1>Auto-Complete Lightning Component</h1>
             <p><a class="btn btn-primary btn-lg" href="https://developer.salesforce.com/lightning" role="button">Learn more</a></p>
        </div>
        <div class="row">    
        <div class="form-group text-center">
            <stech2:autocomplete sObjectType="Account" autocompleteEvent="{!c.handleAutocomplete}" fields="Phone,AccountNumber" />
        </div>
        <div class="form-group text-center">    
            <stech2:autocomplete sObjectType="Contact" autocompleteEvent="{!c.handleAutocomplete}" fields="Email,Phone"/>
        </div>
        </div>
        <div id="result"></div>
    </div>
</aura:application>

```
15.  Add the below code to the Controller of the Lightning App
```
({
    handleAutocomplete : function(component, event, helper) {
        var so = event.getParam("selectedOption");
        document.getElementById("result").innerHTML = 'Selected:' + so.Name;
    }
})

```

Finally open the newly created Application.