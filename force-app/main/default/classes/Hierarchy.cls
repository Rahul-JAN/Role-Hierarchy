public with sharing class Hierarchy {

    public Class RoleHierarchyNode{
        UserRole role;
        List<RoleHierarchyNode> subordinateRoles;
    }
    //  Holds Role id as key and all associated (child) roles as value
    public static Map<Id, List<UserRole>> rolesWithParent = new Map<Id, List<UserRole>>();

    /*  
        Approach 1
        Description:    Works for single child hierarchy
    */
    public static List<UserRole> getRoleHierarchy_Single(Id roleId){
        
        Map<Id,UserRole> roles = new Map<Id,UserRole>([Select id, ParentRoleId, Name, DeveloperName from UserRole]);
        //  Holds Role id as key and associated (child) role as value
        Map<Id, UserRole> rolesWithParent = new Map<Id, UserRole>();
        List<UserRole> rolesHierarchy = new List<UserRole>();

        rolesHierarchy.add(roles.get(roleId));

        for(UserRole thisRole : roles.values()) {
            if(thisRole.ParentRoleId != null){
                //  Put Parent RoleId as key and UserRole as value
                rolesWithParent.put(thisRole.ParentRoleId,thisRole);
            }

            if(roles.get(rolesHierarchy[0].ParentRoleId) != null) {
                //  Add the Parent Role of First Role in list 
                rolesHierarchy.add(0,roles.get(rolesHierarchy[0].ParentRoleId));    
            }
        }
        

        for(Integer index = 0; index < rolesWithParent.size(); index++) {
            if(rolesWithParent.get(rolesHierarchy[rolesHierarchy.size() - 1].Id) != null){
                //  Add the Child Role of Last Role in list 
                rolesHierarchy.add(rolesWithParent.get(rolesHierarchy[rolesHierarchy.size() - 1].Id));    
            }
            else{
                break;
            }
        }

        return rolesHierarchy;
    }

    /*  
        Approach 2
        Description:    Works for multiple child hierarchy
    */
    public static RoleHierarchyNode getRoleHierarchy_Multiple(Id roleId){

        Id parentId = roleId;
        RoleHierarchyNode roleHierarchy =  new RoleHierarchyNode();
        
        Map<Id,UserRole> roles = new Map<Id,UserRole>([Select id, ParentRoleId, Name, DeveloperName from UserRole]);

        //  Traverse to find Top-most Role in hierarchy 
        while(roles.get(parentId).ParentRoleId != null){
            parentId = roles.get(parentId).ParentRoleId; 
        }

        //  Iterate over all roles to get associated (child) roles
        for(UserRole thisRole : roles.values()) {
            if(thisRole.ParentRoleId != null){
                if(rolesWithParent.containsKey(thisRole.ParentRoleId)){
                    List<UserRole> childRoles = rolesWithParent.get(thisRole.ParentRoleId);
                    childRoles.add(thisRole);

                    rolesWithParent.put(thisRole.ParentRoleId,childRoles);
                }
                else{
                    rolesWithParent.put(thisRole.ParentRoleId, new List<UserRole>{thisRole});
                }
            }
        }

        roleHierarchy.role = roles.get(parentId);
        //  to get all associated (child) roles
        roleHierarchy.subordinateRoles = getSubordinateRoles(parentId);
        
        return roleHierarchy;
    }
    
    /* 
        Parameters: 
            rolesWithParent => Holds all the related child roles of a Role
            roleId          => Id of a Role 

        Description:    Return all the related child roles of a Role
    */
    public static List<RoleHierarchyNode> getSubordinateRoles(Id roleId){

        List<RoleHierarchyNode> relatedRoles =  new List<RoleHierarchyNode>();

        if(rolesWithParent.containsKey(roleId)){
            for(UserRole thisRole : rolesWithParent.get(roleId)){
                RoleHierarchyNode roleHierarchy =  new RoleHierarchyNode(); 
                roleHierarchy.role = thisRole;

                if(rolesWithParent.containsKey(thisRole.Id)){
                    //  Get all child role of VAR(thisRole)
                    roleHierarchy.subordinateRoles = getSubordinateRoles(thisRole.Id);
                }
                
                relatedRoles.add(roleHierarchy);
            }
        }

        return relatedRoles;
    }

}