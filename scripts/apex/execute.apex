//  for Approach-1  
for(UserRole thisRole : Hierarchy.getRoleHierarchy_Single('00E5g... ')){
    System.Debug(thisRole);
}

//  for Approach-2
Hierarchy.RoleHierarchyNode result = new Hierarchy.RoleHierarchyNode();
result =  Hierarchy.getRoleHierarchy_Multiple('00E5g... ');
System.debug(result);
System.debug(JSON.serialize(result));