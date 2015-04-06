$Acl = Get-Acl "C:\Users\Rob\Google Drive"
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("Administrators","FullControl","ContainerInherit, ObjectInherit","None","Allow")
$Acl.SetAccessRule($Ar)
Set-Acl "C:\Users\Rob\Google Drive" $Acl