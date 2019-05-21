@isTest
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here
  //
  @TestSetup
    private static void setup() {
        ServiceTokens__c serviceToken=new ServiceTokens__c(Name='ProjectServiceToken', Token__c='new_service_token');
        insert serviceToken;
    }
      @isTest
    private static void testFailure() {
        Opportunity opp = OpportunityFactory.createOpportunity('Closed Won');
        insert opp;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        ProjectCalloutService.postOpportunityToPMS(new List<Id>{opp.Id});
        Test.stopTest();

        //List<Opportunity> opportunities = OpportunitySelector.getOpportunities(new Set<Id>{opp.Id});
        //System.assertEquals(OpportunitySelector.STAGE_RESUBMIT_PROJECT, opportunities.get(0).StageName);
    }

    @isTest
    private static void testSuccess() {
        Opportunity opp = OpportunityFactory.createOpportunity('Closed Won');
        insert opp;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        ProjectCalloutService.postOpportunityToPMS(new List<Id>{opp.Id});
        Test.stopTest();

        //List<Opportunity> opportunities = OpportunitySelector.getOpportunities(new Set<Id>{opp.Id});
        //System.assertEquals(OpportunitySelector.STAGE_SUBMITTED_PROJECT, opportunities.get(0).StageName);
    }
}