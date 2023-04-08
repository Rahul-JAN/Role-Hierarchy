public with sharing class Hierarchy {
    public static List<UserRole> getRoleHierarchy(Id roleId){
        
        //Getting Roles which are associate to user define hierarchy 
        Map<Id,UserRole> roles = new Map<Id,UserRole>([Select id, ParentRoleId from UserRole where name like 'Test%' ]);

        Map<Id, UserRole> rolesWithParent = new Map<Id, UserRole>();
        List<UserRole> rolesHierarchy = new List<UserRole>();

        rolesHierarchy.add(roles.get(roleId));

        for(UserRole thisRole : roles.values()) {
            if(thisRole.ParentRoleId != null){
                //put Parent RoleId as key and UserRole as value
                rolesWithParent.put(thisRole.ParentRoleId,thisRole);
            }

            if(roles.get(rolesHierarchy[0].ParentRoleId) != null) {
                //Add the Parent Role of First Role in list 
                rolesHierarchy.add(0,roles.get(rolesHierarchy[0].ParentRoleId));    
            }
        }
        

        for(Integer index = 0; index < rolesWithParent.values().size(); index++) {
            if(rolesWithParent.get(rolesHierarchy[rolesHierarchy.size() - 1].Id) != null){
                //Add the Child Role of Last Role in list 
                rolesHierarchy.add(rolesWithParent.get(rolesHierarchy[rolesHierarchy.size() - 1].Id));    
            }
            else{
                break;
            }
        }

        return rolesHierarchy;
    }
}