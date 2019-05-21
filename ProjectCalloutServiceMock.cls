public class ProjectCalloutServiceMock implements HttpCalloutMock{
   //Implement http mock callout here
    public HttpResponse respond(HttpRequest req){
        HttpResponse resp= new HttpResponse();
        resp.setHeader('Content-Type','application/json');
        resp.setStatusCode(201);
        resp.setStatus('Created');
        return resp;
    }
}