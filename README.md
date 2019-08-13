# wordpress Deployment template for multiple environments
## Complted : 
  Single template for all resources
  parameter files for multiple envs
  RDS params in ssm
  Different Resources for Prod and Dev
  
## ToDo : 
  Better IAM roles/policies for RDS/EC2. Less Priviliges.
  Better NACLs/SGs. Less Access.
  Query for RDS endpoint after its created and use it in the userdata.
  
Usage : 
  1. clone the repo
  2. cd wordpress
  3. ./deploy.sh dev ## Only dev and prod allowed right now.
