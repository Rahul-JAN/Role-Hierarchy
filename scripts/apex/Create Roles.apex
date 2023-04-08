Database.SaveResult lastRole;
for(integer i = 1; i<=10; i++){
    if(i==1){
        lastRole = DataBase.insert(new UserRole(Name='Test '+i, DeveloperName='Test_'+i));
    }
    else{
        lastRole = Database.insert(new UserRole(Name='Test '+i, DeveloperName='Test_'+i, ParentRoleId=lastRole.Id));
    }
}