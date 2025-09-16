public with sharing class GetAllUsersFromQueue {
    @InvocableMethod(label='Get All User From Queue')
    public static List<Response> methodName(List<Requests> requestsList){
        Set<String> userIds = new Set<String>();
        Set<Id> grpIds = new Set<Id>();
        Set<id> roleIds = new Set<id>();
        List<UserDetails> userDetailsList = new List<UserDetails>();
        Set<id> internalGroupIds = new Set<id>();
        Group thisGroup = [SELECT id,name,type from group where name =: requestsList[0].queueName and type = 'queue'];
        List<GroupMember> allGroupMembers = [SELECT id,UserorGroupId,GroupId
                                             FROM GroupMember
                                             WHERE GroupId = :thisGroup.id];
        for(GroupMember thisGrpMem : allGroupMembers){
            if(String.valueOf(thisGrpMem.UserorGroupId).startsWith('005')){
                userIds.add(thisGrpMem.UserorGroupId);
            }
            else if(String.valueOf(thisGrpMem.UserorGroupId).startsWith('00G')){
                grpIds.add(thisGrpMem.UserorGroupId);
            }
        }
        if(!grpIds.isEmpty()){
            List<Group> internalGroups = [SELECT id,Type,DeveloperName,RelatedId
                                          FROM Group
                                          WHERE id IN :grpIds];
            for(Group thisgrp : internalGroups){
                if(thisgrp.RelatedId != null){
                    roleIds.add(thisgrp.RelatedId);
                }
                else{
                    internalGroupIds.add(thisgrp.id);
                }
            }
        }
        if(!internalGroupIds.isEmpty()){
            List<GroupMember> allGroupMembers1 = [SELECT id,UserorGroupId,GroupId
                                                  FROM GroupMember
                                                  WHERE GroupId IN :internalGroupIds];
            for(GroupMember thisGrpMem : allGroupMembers1){
                if(String.valueOf(thisGrpMem.UserorGroupId).startsWith('005')){
                    userIds.add(thisGrpMem.UserorGroupId);
                }
            }
        }
        if(!roleIds.isEmpty()){
            List<User> userList = [SELECT id,name,UserRoleId FROM User WHERE UserRoleId IN :roleIds];
            for(User thisUser : userList){
                userIds.add(thisUser.id);
            }
        }
        
        List<GetAllUsersFromQueue.Response> responseList = new List<GetAllUsersFromQueue.Response>();
        GetAllUsersFromQueue.Response response = new GetAllUsersFromQueue.Response();
        List<User> userList = [SELECT id,Name,IsActive,Email
                               FROM User
                               WHERE id IN:userIds AND IsActive = true AND Email !=null ];
        for(User user: userList){
            UserDetails userDetails = new UserDetails();
            UserDetails.emailId = user.Email;
            UserDetails.userRecordId = user.Id;
            UserDetails.userId = user.Name;
            userDetailsList.add(UserDetails);
        }
        response.userDetail = userDetailsList;
        responseList.add(response);
        if (!responseList.isEmpty()) {
            return responseList;
        }
        return null;  
        
        
        
    }
    
    public class Requests {
        @InvocableVariable(label='Queue Name' required=true)
        public String queueName;
    }
    public class Response{
        @InvocableVariable(label='User Id')
        public List<UserDetails> userDetail; 
    }
}