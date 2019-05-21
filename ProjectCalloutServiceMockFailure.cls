public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout failure here
    public HttpResponse respond(HttpRequest req){
        HttpResponse resp= new HttpResponse();
        resp.setHeader('Content-Type','application/json');
        resp.setStatusCode(400);
        resp.setStatus('Bad Request');
        return resp;
    } 
}