public with sharing class learnClass {
    public learnClass() {
// public class sendEmailFlow {

//   /*  public class InputWrapper{
        
//         @InvocableVariable(required=true)
//         public Id contactId;
//     }

//     @InvocableMethod(label='Send Email Action')
//     public static void method(List<InputWrapper> inputs){

//         Set<Id> conIds = new Set<Id>();

//         for(InputWrapper inp : inputs){
//             conIds.add(inp.contactId);
//         }

//         List<Contact> conList = [
//             SELECT Id, Name, Email
//             FROM Contact
//             WHERE Id IN :conIds
//         ];

//         List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

//         for(Contact c : conList){

//             if(c.Email != null){

//                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

//                 mail.setToAddresses(new List<String>{c.Email});
//                 mail.setSubject('Test Email From Flow');
//                 mail.setPlainTextBody('Hello ' + c.Name + ', Email sent successfully from Flow + Apex.');

//                 emails.add(mail);

//                 System.debug('Email Prepared For: ' + c.Email);
//             }
//         }

//         if(!emails.isEmpty()){
//             Messaging.sendEmail(emails);
//             System.debug('Emails Sent Successfully');
//         }
//     }*/

//     @InvocableMethod(label='Send Email Action')
//     public static void method(List<Id>contactId){

//         List<Contact> conList = [
//             SELECT Id, Name, Email
//             FROM Contact
//             WHERE Id IN :contactId
//         ];

//         List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

//         for(Contact c : conList){

//             if(c.Email != null){

//                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

//                 mail.setToAddresses(new List<String>{c.Email});
//                 mail.setSubject('Test Email From Flow');
//                 mail.setPlainTextBody('Hello ' + c.Name + ', Email sent successfully from Flow + Apex.');

//                 emails.add(mail);

//                 System.debug('Email Prepared For: ' + c.Email);
//             }
//         }

//         if(!emails.isEmpty()){
//             Messaging.sendEmail(emails);
//             System.debug('Emails Sent Successfully');
//         }
//     }
// }



// Agar kisi bhi new Salesforce org me email send karwana hai (Apex, Flow, Workflow, Approval, etc.), to ye cheezein check kar lo:

// 1. Deliverability ON honi chahiye
// Setup → Deliverability
// Access Level = All Email

// ⚠️ Bahut saare Developer/Trial orgs me ye "System Email Only" hota hai, isliye mail nahi jata.

// 2. User ka Email Verified hona chahiye
// Setup → Users → Users
// Apne user record me email check karo.
// Agar "Verify Email" ka option aaye to email verify kar lo.
// 3. Automated Process User ka Email set karo (Flow ke liye)

// Agar Flow ya Platform Event se email bhej rahe ho:

// Setup → Process Automation Settings
// "Default Workflow User" select karo.
// Ya Automated Process User ka email set aur verify karo.

// Nahi to error aata hai:

// Automated Process User has no email address.

// 4. Email Relays ya Compliance Settings check karo
// Setup → Email → Email Relays
// Agar koi relay configured hai aur properly work nahi kar raha to emails block ho sakti hain.

// 5. Organization-Wide Email Address (agar use kar rahe ho)
// Setup → Organization-Wide Addresses
// Email add karo.
// Verification mail aayegi, usse verify karo.

// Apex me agar Org-Wide Email use kar rahe ho aur verify nahi hai, to mail nahi jayega.

// 6. Email Logs check karo
// Setup → Email Log Files
// Yahan se dekh sakte ho ki Salesforce ne mail send kiya ya nahi.
// 7. Apex Code me setToAddresses sahi hai ya nahi

// Example:

// Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
// mail.setToAddresses(new List<String>{'abc@gmail.com'});
// mail.setSubject('Test');
// mail.setPlainTextBody('Hello');
// Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
// 8. Sandbox me external email restrictions

// Kuch sandboxes me company policies ki wajah se external emails block ho sakte hain. Pehle apni email id par test kar lo.













// Step 1: Create a Record ID Variable in Your Screen FlowTo have the Quick Action automatically pass the current record's data to your flow:Open your Screen Flow in Salesforce Flow Builder.
// Open the Manager tab (toolbox icon on the left) and click New Resource.Set the Resource Type to Variable.Set the API Name to exactly recordId.Set the Data Type to Text.Check the box for Available for input (this allows Salesforce to pass the ID) and click Done.
// Step 2: Create the Quick ActionGo to Setup > Object Manager and select the object where the quick action will live (e.g., Account or Contact).Click Buttons, Links, and Actions, then click New Action.For the Action Type, select Flow.In the Flow dropdown, select your screen flow (make sure it is activated).For Label, type the name that will appear on the button (e.g., "Create Related Case").Click Save.
// Step 3: Add the Action to the Page LayoutWhile still on the same object in the Object Manager, click Page Layouts.Select your layout.In the layout editor palette, click Mobile & Lightning Actions.Drag your new flow action into the Salesforce Mobile and Lightning Experience Actions section.Click Save.




//Time formatting and getting current user 
// Datetime dt = [SELECT LastModifiedDate
//                FROM Opportunity Order by createdDate desc
//                LIMIT 1].LastModifiedDate;

// System.debug('Raw = ' + dt);//utc
// System.debug('format = ' + dt.format()); //ist
// Indian time =utc+5.30

// Id currentUserId = UserInfo.getUserId();
// System.debug(currentUserId); 




//Dummy Response

// public class ResponseWrapper{
//     public String status;
//     public String requestId;
//     public List<ResultData> data;
// }

// public class ResultData{
//     public String id;
//     public String message;
// }


// ResponseWrapper res = new ResponseWrapper();
// res.status = 'SUCCESS';
// res.requestId = '12345';

// ResultData d = new ResultData();
// d.id = 'TEMP001';
// d.message = 'Processing Started';

// res.data = new List<ResultData>{d};

// return res;

// Then later, when batch processing is completed, replace the dummy values with actual data from a custom object or status API.





//Or






// public class ResponseController {
    
//     // 1. Define the Wrapper Class
//     public class ResponseWrapper {
//         public String status;
//         public Integer statusCode;
//         public String message;
//         public List<String> dataList;
//     }
    
//     // 2. Method that populates, serializes, and returns the wrapper as a String
//     public static String getSerializedResponse() {
        
//         // Instantiate the wrapper and populate data
//         ResponseWrapper response = new ResponseWrapper();
//         response.status = 'Success';
//         response.statusCode = 200;
//         response.message = 'Records processed successfully.';
//         response.dataList = new List<String>{'Record A', 'Record B', 'Record C'};
        
//         // Serialize the wrapper instance into a JSON string
//         String jsonString = JSON.serialize(response);
        
//         return jsonString;
//     }
// }








//URL


// https://orgfarm-928d820ca4-dev-ed.develop.my.salesforce.com/services/oauth2/authorize?client_id=3MVG97L7PWbPq6UyeAghY5y7ojFyEo6wzRK7Ywm60OHFxVlMcthAs4H6n4er3ep4Oee6s0R2tKZZU0oCiunHo&client_secret=9E43469AE5B190917D5A4D09FF3F60900D989A533B9A0D1305B617BCAE52DA7D&response_type=code&redirect_uri=https://cyntexa.com&code_challenge=cMqP7w68-2y7ldIJ0XhB0HVOHHpfLFvKdsL3IBm74uQ&code_challenge_method=S256



//Schedule by apex

// String cronExp = '0 0 0 * * ?';

// System.schedule(
//     'Night Batch Job',
//     cronExp,
//     new NightBatch()
// );

// System.schedule('Job_00', '0 0 * * * ?', new batchExpire());
// System.schedule('Job_17', '0 17 * * * ?', new batchExpire());
// System.schedule('Job_34', '0 34 * * * ?', new batchExpire());
// System.schedule('Job_51', '0 51 * * * ?', new batchExpire());



// Yes, absolutely. A class does not have to be a Batch Apex class to be scheduled.
// The only requirement for System.schedule() is that the class you schedule must implement the Schedulable interface.

// Example 1: Normal scheduled class
// global class MyScheduler implements Schedulable {

//     global void execute(SchedulableContext sc) {
//         // Your logic here
//         List<Account> accs = [SELECT Id, Name FROM Account LIMIT 10];
//         System.debug(accs);
//     }
// }

// Schedule it:

// System.schedule(
//     'My Job',
//     '0 0 10 * * ?',
//     new MyScheduler()
// );

// This works perfectly.

// Example 2: Scheduled class that calls a batch

// This is what people usually do for large data volumes:

// global class MyScheduler implements Schedulable {

//     global void execute(SchedulableContext sc) {
//         Database.executeBatch(new MyBatch(), 200);
//     }
// }
// Example 3: Scheduled class that calls a Queueable
// global class MyScheduler implements Schedulable {

//     global void execute(SchedulableContext sc) {
//         System.enqueueJob(new MyQueueable());
//     }
// }


//For queuable 

// Correct way: Schedulable → Queueable
// Step 1: Create the Queueable class
// public class MyQueueable implements Queueable {

//     public void execute(QueueableContext qc) {
//         System.debug('Queueable is running');
//         // Your logic here
//     }
// }
// Step 2: Create a Schedulable class
// global class MyScheduler implements Schedulable {

//     global void execute(SchedulableContext sc) {
//         System.enqueueJob(new MyQueueable());
//     }
// }
// Step 3: Schedule it
// String cron = '0 0 10 * * ?';
// System.schedule('Queueable Job', cron, new MyScheduler());

// This will:

// 10:00 AM
//      ↓
// Schedulable executes
//      ↓
// System.enqueueJob(new MyQueueable())
//      ↓
// Queueable executes
// Can one class implement both?

// Yes!

// global class MyJob implements Schedulable, Queueable {

//     global void execute(SchedulableContext sc) {
//         System.enqueueJob(this);
//     }

//     public void execute(QueueableContext qc) {
//         System.debug('Queueable logic');
//     }
// }

// Schedule it:

// System.schedule('My Job', '0 0 10 * * ?', new MyJob());

// Flow:

// Scheduler
//     ↓
// execute(SchedulableContext)
//     ↓
// enqueue this class
//     ↓
// execute(QueueableContext)

// This pattern is quite common in interviews because it keeps everything in a single class.





//Wrapper
// public class wrapperClass{
//  public string id;
//  public string name;
//  public string email;
//  public Boolean isActive;

// }

// public class wrapperClass{
//  public string id;
//  public string name;
//  public AddressClass address;

//  public class AddressClass{
//  public string city;
//  public string state;
//  public string pincode;
//  }
// }

// public class wrapperClass{
// public string success;
// public string message;
// public Emp employee;
// public List<SkillClass> skills;
// public class Emp{
// public string id;
// public string name;
// public Dept department; //Cn you tell how to access deptId and skillname
// }

// public class Dept{
// public string deptId;
// public string deptName;
// }
// public class SkillClass{
//  public string skillName;
//  public Integer experience;
// }
// }













// public class WrapperClass{
// public string status;
// public List<Datas> data;
// public class Datas{
//  public string employeeId;
//  public string employeeName;
//  public List<Pro> projects;
// }
// public class Pro{
//  public string projectId;
//  public string projectName;
//  public List<task> tasks;
// }

// public class task{
//  public Integer taskId;
//  public string  taskname;

// } // how to acess employeeid , taskId and how many class can we make in one class and how many class in nested form



// }


// WrapperClass obj =
// (WrapperClass)JSON.deserialize(responseBody, WrapperClass.class);


// {
//    "employee": { }      // Class
//    "skills": [ ]        // List<Class>
//    "name": "Anjali"     // String
//    "id": 101            // Integer
//    "success": true      // Boolean
// }




// {
//     "success": true,
//     "message": "Data Found",
//     "employee": {
//         "id": 101,
//         "name": "Anjali",
//         "department": {
//             "deptId": 10,
//             "deptName": "Salesforce"
//         }
//     },
//     "skills": [
//         {
//             "skillName": "Apex",
//             "experience": 2
//         },
//         {
//             "skillName": "LWC",
//             "experience": 1
//         }
//     ]
// }









// Agar JSON ka structure fix nahi hai ya fields dynamically aa rahi hain, to JSON.deserializeUntyped() use karte hain.

// Example JSON
// {
//   "name": "Anjali",
//   "age": 22,
//   "skills": ["Apex", "LWC"],
//   "address": {
//     "city": "Jaipur",
//     "state": "Rajasthan"
//   }
// }
// In Rest Resource
// @RestResource(urlMapping='/test/*')
// global with sharing class MyRestClass {

//     @HttpPost
//     global static void doPost() {

//         String body = RestContext.request.requestBody.toString();

//         Map<String, Object> data =
//             (Map<String, Object>) JSON.deserializeUntyped(body);

//         String name = (String)data.get('name');
//         Integer age = (Integer)data.get('age');

//         List<Object> skills =
//             (List<Object>)data.get('skills');

//         Map<String, Object> address =
//             (Map<String, Object>)data.get('address');

//         String city = (String)address.get('city');

//         System.debug(name);
//         System.debug(age);
//         System.debug(skills);
//         System.debug(city);
//     }
// }
// If JSON contains an array at root
// [
//   {
//     "name":"Anjali"
//   },
//   {
//     "name":"Rahul"
//   }
// ]

// Then:

// List<Object> records =
//     (List<Object>)JSON.deserializeUntyped(body);

// for(Object obj : records){
//     Map<String,Object> rec =
//         (Map<String,Object>)obj;

//     System.debug(rec.get('name'));
// }
// Nested Dynamic JSON Example
// {
//   "employee":{
//     "personal":{
//       "name":"Anjali"
//     }
//   }
// }

// Apex:

// Map<String,Object> data =
//     (Map<String,Object>)JSON.deserializeUntyped(body);

// Map<String,Object> employee =
//     (Map<String,Object>)data.get('employee');

// Map<String,Object> personal =
//     (Map<String,Object>)employee.get('personal');

// String name = (String)personal.get('name');
// When to use deserialize() vs deserializeUntyped()
// Method	Use Case
// JSON.deserialize()	Structure fixed hai, wrapper class bana sakte ho
// JSON.deserializeUntyped()	Structure dynamic hai, fields pehle se nahi pata
// Interview answer:

// "For dynamic JSON in a REST Resource, I use JSON.deserializeUntyped() which returns a Map<String,Object> or List<Object>. Then I traverse the structure using type casting depending on whether the node is an object, array, string, or primitive value."





//Batch Chaining

// Batch chaining means one Batch class starts another Batch class from its finish() method.

// Batch 1
// global class Batch1 implements Database.Batchable<SObject> {

//     global Database.QueryLocator start(Database.BatchableContext bc) {
//         return Database.getQueryLocator(
//             'SELECT Id, Name FROM Account'
//         );
//     }

//     global void execute(Database.BatchableContext bc,
//                         List<Account> scope) {

//         for(Account a : scope) {
//             a.Description = 'Processed by Batch1';
//         }
//         update scope;
//     }

//     global void finish(Database.BatchableContext bc) {

//         // Chain the second batch
//         Database.executeBatch(new Batch2(), 200);
//     }
// }
// Batch 2
// global class Batch2 implements Database.Batchable<SObject> {

//     global Database.QueryLocator start(Database.BatchableContext bc) {
//         return Database.getQueryLocator(
//             'SELECT Id, LastName FROM Contact'
//         );
//     }

//     global void execute(Database.BatchableContext bc,
//                         List<Contact> scope) {

//         for(Contact c : scope) {
//             c.Description__c = 'Processed by Batch2';
//         }
//         update scope;
//     }

//     global void finish(Database.BatchableContext bc) {
//         System.debug('Batch2 Completed');
//     }
// }
// Start the first batch
// Database.executeBatch(new Batch1(), 200);
// Flow
// Batch1 Start
//       ↓
// Batch1 Execute
//       ↓
// Batch1 Finish
//       ↓
// Database.executeBatch(new Batch2())
//       ↓
// Batch2 Start → Execute → Finish
// Passing data from Batch1 to Batch2

// Use Database.Stateful.

// Batch1
// global class Batch1 implements Database.Batchable<SObject>,
//                                 Database.Stateful {

//     List<Id> accountIds = new List<Id>();

//     global Database.QueryLocator start(Database.BatchableContext bc){
//         return Database.getQueryLocator(
//             'SELECT Id FROM Account'
//         );
//     }

//     global void execute(Database.BatchableContext bc,
//                         List<Account> scope){

//         for(Account a : scope){
//             accountIds.add(a.Id);
//         }
//     }

//     global void finish(Database.BatchableContext bc){

//         Database.executeBatch(
//             new Batch2(accountIds),
//             200
//         );
//     }
// }
// Batch2
// global class Batch2 implements Database.Batchable<SObject>{

//     List<Id> ids;

//     public Batch2(List<Id> ids){
//         this.ids = ids;
//     }

//     global Database.QueryLocator start(
//         Database.BatchableContext bc){

//         return Database.getQueryLocator([
//             SELECT Id, Name
//             FROM Contact
//             WHERE AccountId IN :ids
//         ]);
//     }

//     global void execute(Database.BatchableContext bc,
//                         List<Contact> scope){

//         // logic
//     }

//     global void finish(Database.BatchableContext bc){}
// }
// Interview points
// Batch chaining is done by calling Database.executeBatch() inside the finish() method of another batch.
// Only one batch can be active at a time from a chain, so Batch2 starts only after Batch1 completes.
// Database.Stateful is used when data needs to be passed from Batch1's execute() methods to its finish() method and then to the next batch.













// Haan yrr, API callouts me sabse zyada confusion endpoint aur authorization me hi hoti hai. Main tumhe ek simple process bata deta hu jo paper aur real project dono me kaam aayega.

// Step 1: Sabse pehle API Documentation kholo

// Har API ki documentation me ye 4 cheezein dhoondho:

// ✅ Base URL
// ✅ Endpoint URL
// ✅ HTTP Method (GET/POST/PUT/DELETE)
// ✅ Authentication Type

// Example:

// Base URL:
// https://api.twilio.com

// Endpoint:
// POST /2010-04-01/Accounts/{AccountSid}/Messages.json

// Final endpoint:

// https://api.twilio.com/2010-04-01/Accounts/AC123/Messages.json
// Step 2: Authentication kaise identify kare?

// Documentation me ye keywords dhoondho:

// Case 1: API Key

// Agar likha ho:

// Headers:
// x-api-key: abc123

// ya

// Authorization: ApiKey xyz

// To simple header lagana hai:

// req.setHeader('x-api-key', apiKey);
// Case 2: Bearer Token (Most Common)

// Agar docs me likha ho:

// Authorization: Bearer <token>

// To:

// req.setHeader(
//     'Authorization',
//     'Bearer ' + token
// );

// Examples:

// Twilio Verify
// OpenAI APIs
// Slack APIs
// Most modern APIs
// Case 3: Basic Authentication

// Agar docs me likha ho:

// Authorization: Basic base64(username:password)

// To:

// String auth =
// EncodingUtil.base64Encode(
// Blob.valueOf(username+':'+password)
// );

// req.setHeader(
// 'Authorization',
// 'Basic '+auth
// );

// Twilio SMS API isi type ka use karta hai.

// Case 4: OAuth 2.0

// Agar docs me ye words dikhe:

// Client Id
// Client Secret
// Access Token
// Refresh Token
// Grant Type

// To samajh jao OAuth hai.

// Usually Salesforce me:

// Named Credential
// +
// External Credential

// use karte hain.

// Examples:

// Google APIs
// Salesforce APIs
// Microsoft APIs
// Case 5: No Authentication

// Kabhi docs me likha hoga:

// No authentication required.

// To simply endpoint hit kar do.

// Exam me agar completely new API de di jaye to kya karna hai?

// Main hamesha ye checklist follow karta hu:

// Question 1

// Endpoint kya hai?

// Search:

// GET /users
// POST /orders
// Question 2

// Method kya hai?

// GET
// POST
// PUT
// DELETE
// PATCH
// Question 3

// Request body chahiye?

// Example:

// {
//   "name":"Anjali"
// }

// Then:

// req.setBody(jsonString);
// Question 4

// Authorization kya hai?

// Docs me ye words dhoondho:

// Keyword	Authentication
// Bearer	OAuth Token
// Basic	Username Password
// API Key	x-api-key
// Client Id	OAuth
// Access Token	OAuth
// Subscription-Key	API Key
// Example

// Suppose docs give:

// POST https://api.xyz.com/v1/users

// Headers:
// Authorization: Bearer token
// Content-Type: application/json

// Immediately tumhara code:

// HttpRequest req = new HttpRequest();

// req.setEndpoint(
// 'callout:XYZ/v1/users'
// );

// req.setMethod('POST');

// req.setHeader(
// 'Authorization',
// 'Bearer '+token
// );

// req.setHeader(
// 'Content-Type',
// 'application/json'
// );

// req.setBody(body);
// Ek aur trick jo interviews me bahut kaam aati hai

// Paper me API documentation dekhte hi pehle ye likh lo:

// 1. Endpoint
// 2. Method
// 3. Headers
// 4. Authentication
// 5. Request Body
// 6. Response Body

// Agar ye 6 cheezein identify kar li, to tum koi bhi new API integrate kar logi.

// Mere hisab se tumhe sabse zyada confusion OAuth aur Basic Auth me hoti hai. Ek line me yaad rakho:
// Username + Password/SID
//         ↓
//      Basic Auth

// Token
//         ↓
//      Bearer Auth

// Client Id + Secret
//         ↓
//        OAuth

// Agar chaho to main tumhe 5 different API document screenshots dekar practice questions bhi kara sakta hu, exactly waise hi jaise interview ya exam me aate hain.

// oauth token kha se lau 

// Ye sabse important question hai 😄. OAuth token hum khud create nahi karte, API provider deta hai. Tumhe pehle token generate karna padta hai.

// Step 1: Documentation dekho

// Agar docs me ye dikhe:

// Client Id
// Client Secret
// Token Endpoint
// Grant Type

// to samajh jao ki OAuth use ho raha hai.

// Case 1: Client Credentials Flow (bahut common)

// Documentation:

// Token Endpoint:
// https://api.xyz.com/oauth/token

// Grant Type:
// client_credentials

// Client Id:
// abc123

// Client Secret:
// xyz789

// Token lane ke liye pehle ye call karoge:

// POST https://api.xyz.com/oauth/token

// grant_type=client_credentials
// client_id=abc123
// client_secret=xyz789

// Response:

// {
//   "access_token": "eyJhbGciOi...",
//   "token_type": "Bearer",
//   "expires_in": 3600
// }

// Ab ye access_token use hoga:

// req.setHeader(
//     'Authorization',
//     'Bearer ' + accessToken
// );
// Case 2: Username Password Flow

// Request:

// POST /token

// grant_type=password
// client_id=xxx
// client_secret=yyy
// username=test@test.com
// password=password+securityToken

// Response:

// {
//   "access_token": "00D...."
// }
// Case 3: Authorization Code Flow

// Ye tab hota hai jab user login karta hai.

// Flow:

// Login Screen
//       ↓
// Authorization Code
//       ↓
// Exchange for Access Token
//       ↓
// Bearer Token

// Isme token manually nahi milta, login process se milta hai.

// Salesforce me practically kya karte hain?

// Normally:

// ✅ Connected App banate hain.

// ya

// ✅ Named Credential + External Credential use karte hain.

// Salesforce automatically token manage kar leta hai.

// Tum sirf likhti ho:

// req.setEndpoint('callout:MyAPI/users');

// Token refresh sab Salesforce handle kar deta hai.

// Exam me agar pooche:

// "OAuth token kahan se laoge?"

// Answer:

// "OAuth access token is obtained by making a request to the authorization server's token endpoint using the credentials provided by the API provider, such as Client Id, Client Secret, and the appropriate grant type."

// Ek shortcut yaad rakho:
// API Provider
//      ↓
// gives
// Client Id + Secret
//      ↓
// Call Token Endpoint
//      ↓
// Get Access Token
//      ↓
// Use Bearer Token in API Callout

// Aur agar documentation me token endpoint hi nahi diya hai, to samajh jao:

// ya to OAuth use nahi ho raha,
// ya docs incomplete hain,
// ya Salesforce ke Named Credential setup ka use karna hai.
// mujhe koi api do na jise m hit krke dekhu 

// Haan yrr, practice ke liye kuch free APIs deti hoon jo tum Salesforce se hit karke dekh sakti ho.

// 1. JSONPlaceholder (Best for Practice)

// JSONPlaceholder

// GET Request

// Endpoint:

// https://jsonplaceholder.typicode.com/users

// Apex:

// Http h = new Http();
// HttpRequest req = new HttpRequest();

// req.setEndpoint(
//     'https://jsonplaceholder.typicode.com/users'
// );
// req.setMethod('GET');

// HttpResponse res = h.send(req);

// System.debug(res.getBody());

// No authentication required ✅

// 2. Countries API

// REST Countries API

// Endpoint:

// https://restcountries.com/v3.1/name/india

// Apex:

// HttpRequest req = new HttpRequest();
// req.setEndpoint(
// 'https://restcountries.com/v3.1/name/india'
// );
// req.setMethod('GET');

// HttpResponse res =
// new Http().send(req);

// System.debug(res.getBody());

// No authentication required ✅

// 3. Cat Facts API

// Cat Facts API

// Endpoint:

// https://catfact.ninja/fact

// No authentication required ✅

// 4. Official Joke API

// Official Joke API

// Endpoint:

// https://official-joke-api.appspot.com/random_joke

// No authentication required ✅

// 5. Practice OAuth API (Very good for learning)

// ReqRes API

// Login endpoint:

// POST https://reqres.in/api/login

// Body:

// {
//   "email": "eve.holt@reqres.in",
//   "password": "cityslicka"
// }

// Apex:

// HttpRequest req = new HttpRequest();

// req.setEndpoint(
// 'https://reqres.in/api/login'
// );

// req.setMethod('POST');
// req.setHeader(
// 'Content-Type',
// 'application/json'
// );

// req.setBody(
// '{"email":"eve.holt@reqres.in","password":"cityslicka"}'
// );

// HttpResponse res =
// new Http().send(req);

// System.debug(res.getBody());
// Salesforce Setup

// Before hitting any external API:

// Setup → Remote Site Settings
// Add:
// https://jsonplaceholder.typicode.com

// or whichever API you're using.

// (If using Named Credential, then Remote Site Setting isn't needed.)

// Mere hisab se tum ye order follow karo:
// JSONPlaceholder → GET
// JSONPlaceholder → POST
// Countries API → Dynamic JSON
// ReqRes → Login and token response
// Twilio → Basic Auth practice

// Agar exam kal hai, to JSONPlaceholder perfect hai kyunki usme GET, POST, PUT, DELETE sab practice ho jayega aur dynamic JSON bhi mil jayega.











// Agar tum Action Button (Quick Action) se Apex call karna chahti ho, to directly Apex method ko button se call nahi kar sakte. Iske liye usually ye approaches use hoti hain:

// 1. Quick Action → LWC → Apex (Recommended)
// Step 1: Apex Class
// public with sharing class AccountController {
//     @AuraEnabled
//     public static void doSomething(Id recordId) {
//         Account acc = [SELECT Id, Name FROM Account WHERE Id = :recordId];
//         acc.Description = 'Updated from Action';
//         update acc;
//     }
// }
// Step 2: LWC JS
// import { LightningElement, api } from 'lwc';
// import doSomething from '@salesforce/apex/AccountController.doSomething';

// export default class MyAction extends LightningElement {
//     @api recordId;

//     connectedCallback() {
//         doSomething({ recordId: this.recordId })
//             .then(() => {
//                 console.log('Success');
//             })
//             .catch(error => {
//                 console.error(error);
//             });
//     }
// }
// Step 3: Meta XML
// <targets>
//     <target>lightning__RecordAction</target>
// </targets>

// <targetConfigs>
//     <targetConfig targets="lightning__RecordAction">
//         <actionType>ScreenAction</actionType>
//     </targetConfig>
// </targetConfigs>

// Then:

// Setup → Object Manager → Buttons, Links, and Actions
// Create New Action
// Action Type = Lightning Web Component
// Select your LWC.
// 2. Quick Action → Flow → Apex Action

// Agar Apex method @InvocableMethod hai, to:

// public class MyActionClass {
//     @InvocableMethod
//     public static void process(List<Id> recordIds) {
//         // logic
//     }
// }

// Then:

// Create a Flow.
// Add Action → Apex.
// Select MyActionClass.
// Create a Quick Action to launch the Flow.
// 3. URL Button se Apex call?

// ❌ Directly possible nahi hai.

// Button sirf:

// Flow
// LWC
// Visualforce
// URL

// launch kar sakta hai. Apex hamesha inke through indirectly call hota hai.

// Interview Answer:

// "Apex cannot be invoked directly from a Quick Action. We usually expose Apex through an LWC using @AuraEnabled methods or through a Flow using @InvocableMethod, and then launch that component from the action button."
 


//LWC slds classss;-

// 1.  To take button in right

// <div class="slds-grid slds-grid_align-end">
//             <lightning-button label="Refresh" icon-name="utility:refresh" onclick={refresh1}></lightning-button>
//         </div>


//2. To make button align with other divs in a grid
//  <div class="slds-col slds-align-bottom">
//             <lightning-button label="Refresh" icon-name="utility:refresh" onclick={refresh2}></lightning-button>
//         </div>

// 1. Multiple cards ek line me dikhane ke liye
// <div class="slds-grid slds-wrap">

//     <div class="slds-col slds-size_1-of-3">
//         <lightning-card title="Card 1"></lightning-card>
//     </div>

//     <div class="slds-col slds-size_1-of-3">
//         <lightning-card title="Card 2"></lightning-card>
//     </div>

//     <div class="slds-col slds-size_1-of-3">
//         <lightning-card title="Card 3"></lightning-card>
//     </div>

// </div>
// Size classes
// slds-size_1-of-2   → 2 cards
// slds-size_1-of-3   → 3 cards
// slds-size_1-of-4   → 4 cards
// slds-size_1-of-1   → Full width
// 2. Gap dena ho cards ke beech
// <div class="slds-m-around_medium">

// or

// <div class="slds-p-around_medium">
// Difference
// m = margin
// p = padding
// 3. Text center me
// <p class="slds-text-align_center">
//     Hello
// </p>

// Left:

// slds-text-align_left

// Right:

// slds-text-align_right
// 4. Text bada karna
// <p class="slds-text-heading_large">
//     Hello
// </p>

// Other sizes:

// slds-text-heading_small
// slds-text-heading_medium
// slds-text-heading_large
// 5. Bold text
// <p class="slds-text-title_bold">
//     Hello
// </p>
// 6. Button ko right me karna
// <div class="slds-text-align_right">
//     <lightning-button label="Save"></lightning-button>
// </div>

// ya

// <div class="slds-grid slds-grid_align-end">
//     <lightning-button label="Save"></lightning-button>
// </div>
// 7. Button center me
// <div class="slds-grid slds-grid_align-center">
//     <lightning-button label="Save"></lightning-button>
// </div>
// 8. Button left me
// <div class="slds-grid slds-grid_align-start">
//     <lightning-button label="Save"></lightning-button>
// </div>
// 9. Div ke andar elements ko horizontally rakhna
// <div class="slds-grid">
//     <p>One</p>
//     <p>Two</p>
// </div>
// 10. Horizontally aur center me
// <div class="slds-grid slds-grid_align-center">
// 11. Vertically center
// <div class="slds-grid slds-grid_vertical-align-center">
// 12. Space between do items
// <div class="slds-grid slds-grid_align-spread">

// Example:

// Title                           Button

// Bahut kaam aata hai dashboard me.

// 13. Background color

// SLDS me limited colors hote hain.

// Gray:

// <div class="slds-box slds-theme_default">

// Dark:

// <div class="slds-box slds-theme_shade">

// Blue:

// <div class="slds-box slds-theme_info">

// Green:

// <div class="slds-box slds-theme_success">

// Red:

// <div class="slds-box slds-theme_error">

// Yellow:

// <div class="slds-box slds-theme_warning">
// 14. Custom color dena ho

// CSS use karo.

// HTML:

// <div class="box">

// CSS:

// .box{
//     background-color:#4CAF50;
//     color:white;
// }
// 15. Border dena
// <div class="slds-box">
// 16. Shadow dena
// <div class="slds-box slds-theme_default">

// ya CSS:

// .box{
//     box-shadow:0px 2px 5px gray;
// }
// 17. Ek card ke andar multiple cards
// <div class="slds-grid slds-wrap">

//     <div class="slds-col slds-size_1-of-2">
//         <lightning-card title="Revenue"></lightning-card>
//     </div>

//     <div class="slds-col slds-size_1-of-2">
//         <lightning-card title="Projects"></lightning-card>
//     </div>

// </div>
// 18. Center me spinner
// <div class="slds-align_absolute-center">
//     <lightning-spinner></lightning-spinner>
// </div>
// 19. Icon aur text ek line me
// <div class="slds-grid slds-grid_vertical-align-center">
//     <lightning-icon icon-name="utility:user"></lightning-icon>
//     <p class="slds-m-left_small">Anjali</p>
// </div>
// 20. Exam ke liye sabse important classes
// Purpose	Class
// Grid	slds-grid
// Wrap	slds-wrap
// Center	slds-grid_align-center
// Right	slds-grid_align-end
// Space Between	slds-grid_align-spread
// Vertical Center	slds-grid_vertical-align-center
// Margin	slds-m-around_medium
// Padding	slds-p-around_medium
// Text Center	slds-text-align_center
// Large Text	slds-text-heading_large
// Bold	slds-text-title_bold
// Border	slds-box
// Background	slds-theme_success/info/error
// Card Width	slds-size_1-of-2, 1-of-3, 1-of-4






//Lightning-layout
//  <lightning-layout multiple-rows>
      
//         <template for:each={datas} for:item="item1">
//           <lightning-layout-item
//             key={item1}
//             size="12"
//             small-device-size="6"
//             medium-device-size="4"
//             large-device-size="3"
//             padding="around-small">
//      <template lwc:if={item1.HouseFULL__c}>
//       <lightning-card title="" class="carddimmed container" >
//         <a onclick={handleModal} data-detail={item1.FullDetails__c}>{item1.Movie_Name__c}</a>
//         <p>{item1.Location__c}</p>
//        <span>{item1.Genre__c}{empty}</span>
//        <span>Rating->{item1.Rating__c}</span>
//        <p class="slds-text-color_error">Available Seats -> HOUSEFULL </p>
//         <lightning-button label="Silver"  class="slds-m-left_x-small" onclick={m1}></lightning-button>
//         <lightning-button label="Gold"  class="slds-m-left_x-small" onclick={m1}></lightning-button>
//          <lightning-button label="Platinum"  class="slds-m-left_x-small" onclick={m1}></lightning-button>
//       </lightning-card>
//       </template>


//       <template lwc:else>
    
//       <lightning-card title=""  class="container">
//         <a onclick={handleModal} data-detail={item1.FullDetails__c}>{item1.Movie_Name__c}</a>
//         <p>{item1.Location__c}</p>
//        <span>{item1.Genre__c}{empty}</span>
//        <span>Rating->{item1.Rating__c}</span>
//        <p >Available Seats -> {item1.Available_Seats__c}</p>
//         <lightning-button label="Silver"  class="slds-m-left_x-small" onclick={m1} data-showname={item1.Name}></lightning-button>
//         <lightning-button label="Gold"  class="slds-m-left_x-small" onclick={m1} data-showname={item1.Name}></lightning-button>
//          <lightning-button label="Platinum"  class="slds-m-left_x-small" onclick={m1} data-showname={item1.Name}></lightning-button>

//       </lightning-card>
//         </template>
//         </lightning-layout-item>
//          </template>
    
//      </lightning-layout>



//For color:-  slds-text-color_error

//To make border around div :-

// <div class="slds-box">
//             <p class="slds-align_absolute-center">Total reservations</p>
//             <p
//               class="slds-align_absolute-center slds-text-heading_large slds-text-color_error"
//             >
//               {data1}
//             </p>
//             </div>








//Wrapper APex


// Haan, bilkul. Tumhare case me method1 se method8 sirf dashboard data la rahe hain. Itna saara @wire lagane ki jagah ek hi Apex method bana sakte ho jo ek wrapper return kare.

// Apex Wrapper
// public class DashboardWrapper {
//     @AuraEnabled public Integer totalTrains;
//     @AuraEnabled public Integer totalReservations;
//     @AuraEnabled public Integer confirmedReservations;
//     @AuraEnabled public Integer waitingReservations;
//     @AuraEnabled public Integer cancelledReservations;
//     @AuraEnabled public Integer todaysDeparture;
//     @AuraEnabled public Decimal availableSeats;
//     @AuraEnabled public Decimal occupancyPercentage;
// }
// Single Apex Method
// @AuraEnabled(cacheable=true)
// public static DashboardWrapper getDashboardData() {

//     DashboardWrapper wrap = new DashboardWrapper();

//     wrap.totalTrains =
//         [SELECT Count() FROM Train11__c];

//     wrap.totalReservations =
//         [SELECT Count() FROM Booking__c];

//     wrap.confirmedReservations =
//         [SELECT Count() FROM Booking__c
//          WHERE Status__c='Confirmed'];

//     wrap.waitingReservations =
//         [SELECT Count() FROM Waiting1__c];

//     wrap.cancelledReservations =
//         [SELECT Count() FROM Booking__c
//          WHERE Status__c='Canceled'];

//     wrap.todaysDeparture =
//         [SELECT Count() FROM Train11__c
//          WHERE JourneyDate__c = :Date.today()];

//     AggregateResult seatAgg =
//         [SELECT
//             SUM(General_Quota__c) totalGeneral,
//             SUM(Sleeper_Seats__c) totalSleeper,
//             SUM(AC_Seats__c) totalAC
//          FROM Train11__c];

//     Decimal totalSeats =
//         (Decimal)seatAgg.get('totalGeneral') == null ? 0 :
//         (Decimal)seatAgg.get('totalGeneral');

//     totalSeats +=
//         (Decimal)seatAgg.get('totalSleeper') == null ? 0 :
//         (Decimal)seatAgg.get('totalSleeper');

//     totalSeats +=
//         (Decimal)seatAgg.get('totalAC') == null ? 0 :
//         (Decimal)seatAgg.get('totalAC');

//     wrap.availableSeats = totalSeats;

//     AggregateResult bookingAgg =
//         [SELECT SUM(Seat_Count__c) booked
//          FROM Booking__c
//          WHERE Status__c IN ('Confirmed','Pending')];

//     Decimal booked =
//         bookingAgg.get('booked') == null ?
//         0 : (Decimal)bookingAgg.get('booked');

//     wrap.occupancyPercentage =
//         totalSeats == 0 ?
//         0 :
//         ((booked / totalSeats) * 100)
//             .setScale(1);

//     return wrap;
// }
// LWC JS

// Import sirf ek method:

// import getDashboardData
// from '@salesforce/apex/railClass.getDashboardData';
// dashboardResult;

// @wire(getDashboardData)
// wiredDashboard(result){
//     this.dashboardResult = result;

//     if(result.data){
//         this.data0 = result.data.totalTrains;
//         this.data1 = result.data.totalReservations;
//         this.data2 = result.data.confirmedReservations;
//         this.data3 = result.data.waitingReservations;
//         this.data4 = result.data.cancelledReservations;
//         this.data5 = result.data.todaysDeparture;
//         this.data6 = result.data.availableSeats;
//         this.data7 = result.data.occupancyPercentage;

//         this.totalPages =
//             Math.ceil(this.data1 / this.pagelength);
//     }
// }

// Refresh:

// refresh1(){
//     refreshApex(this.dashboardResult);
// }
}
}