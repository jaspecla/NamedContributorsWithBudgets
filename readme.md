# Named Contributors With Budgets

A terraform script to create a resource group for a particular user to use.  That user will 
have contributor access to that resource group.  The script also creates a budget for that
resource group.

Usage:
```
terraform apply -var="user_name=[full name of user to grant access to]" -var="user_email=[username to grant access to]" -var="tenant_id=[target azure ad tenant]" -var="subscription_id=[target subscription id]" -var="client_id=[client id]" -var="client_secret=[client secret]"
```