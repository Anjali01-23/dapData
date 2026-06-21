public with sharing class relatedClass {
  @AuraEnabled(cacheable=true)
  public static List<Map<String,Object>> getData(String objectName, String recordId) {

    List<Map<String,Object>> data = new List<Map<String,Object>>();
    Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
    List<Schema.ChildRelationship> childRelationships = objType.getDescribe()
      .getChildRelationships();
    for (Schema.ChildRelationship child : childRelationships) {
      String childObject = String.valueOf(child.getChildSObject());

      String relationField = String.valueOf(child.getField());

      String relationshipName = child.getRelationshipName();

      if (relationshipName == null) {
        continue;
      }
      Schema.DescribeSObjectResult childDescribe = child.getChildSObject()
        .getDescribe();

      if (!childDescribe.isQueryable()) {
        continue;
      }
      if (
        childObject.contains('History') ||
        childObject.contains('Feed') ||
        childObject.contains('Share') ||
        childObject.contains('ChangeEvent') ||
        childObject.contains('Tag') ||
        childObject.contains('OwnerSharingRule')
      ) {
        continue;
      }
      String query =
        'SELECT Id FROM ' +
        childObject +
        ' WHERE ' +
        relationField +
        ' = :recordId LIMIT 3';

      try {
        List<SObject> records = Database.query(query);

        if (!records.isEmpty()) {
          Map<String,Object> mpp=new Map<String,Object>();
          mpp.put('objectName',relationshipName);
          mpp.put('records',records);
          mpp.put('child',childObject);
          data.add(mpp);
        }
      } catch (Exception e) {
        continue;
      }
    }
    return data;
  }

}
