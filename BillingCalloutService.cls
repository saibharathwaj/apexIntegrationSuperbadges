public class BillingCalloutService {
    //Implement business and callout logic methods here
    @future(callout=true)
    public static void callBillingService(String projectRef, Decimal billingAmount){
        ServiceCredentials__c srvCred= ServiceCredentials__c.getValues('BillingServiceCredential');
        BillingServiceProxy.project projectInst= new BillingServiceProxy.project();
        projectInst.username = srvCred.Username__c;
        projectInst.password = srvCred.Password__c;
        projectInst.projectid = projectRef;
        projectInst.billAmount = billingAmount;
        BillingServiceProxy.InvoicesPortSoap11 invPortSoapInst = new BillingServiceProxy.InvoicesPortSoap11();
        String response = invPortSoapInst.billProject(projectInst);
        
        List<Project__c> lstOfProjects = new List<Project__c>();
        if(response != null && response.equalsIgnoreCase('OK')){
            List<Project__c> lstOfPrjts = [SELECT Status__c FROM Project__c WHERE ProjectRef__c = :projectRef];
            for(Project__c prjt : lstOfPrjts){
                prjt.Status__c = 'Billed';
                
                lstOfProjects.add(prjt);
            }
            
            UPDATE lstOfProjects;
        }
    }
}