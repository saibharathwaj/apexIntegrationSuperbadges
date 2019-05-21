public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
	@InvocableMethod
    public static void postOpportunityToPMS(List<Id> oppIds){
        Opportunity opp=[Select Id, Name, Account.Name, CloseDate, Amount from Opportunity where Id=:OppIds[0]];
        String token=ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
        String jsonInput = '{\n' +
            ' "opportunityId" : "'+opp.Id+'",\n'+
            ' "opportunityName" : "'+opp.Name+'",\n'+
            ' "accountName" : "'+opp.Account.Name+'",\n'+
            ' "closeDate" : "'+String.ValueOf(opp.CloseDate).mid(0,10)+'",\n'+   
            ' "amount" : "'+opp.Amount+'"\n}';
   
    System.enqueueJob(new QueueablePMSCall(token, jsonInput, opp.Id));
    }
    
    @Future(callout=true)
    private static void postToPMS(String serviceToken, String jsonInput, Id oppId){
        HttpRequest request= new HttpRequest();
        request.setEndpoint('callout:ProjectService');
        request.setMethod('POST');
        request.setHeader('token',serviceToken);
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        request.setBody(jsonInput);
        Http http= new Http();
        HttpResponse response=http.send(request);
        Opportunity opp= new Opportunity(Id=oppId);
        if(response.getStatusCode() == 201) {
            opp.StageName='Submitted Project';
            System.debug('Success :::'+response.getStatus());
        } else {
            opp.StageName='Resubmit Project';
            System.debug('Failures:::'+response.getStatus());
        }
        update opp;
    }
    
    class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts{
        private String serviceToken;
        private String jsonInput;
        private Id oppId;
        
        public QueueablePMSCall(String serviceToken, String jsonInput, Id oppId){
            this.serviceToken = serviceToken;
            this.jsonInput = jsonInput;
            this.oppId = oppId;
        }
        
        public void execute(QueueableContext qc){
            postToPMS(serviceToken, jsonInput, oppId);        
        }
    }
}