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