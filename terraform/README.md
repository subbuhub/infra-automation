# Pre-requisites:

1) Create AWS credentials with permissions to create ALB, EC2, Autoscaling group and launch configuration.

2) Export AWS credentials:

```shell script
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="us-west-2"
```

3) Create s3 bucket for terraform state:

```shell script
S3 Bucket: test-terraform-states
Region: us-west-2
```

Note: Update bucket name in "bucket" variable in "environments/test/provider.tf" file


4) Create SSH private and public keys:

```shell script
ssh-keygen -t rsa -b 2048
```

Copy id_rsa.pub file content and replace variable "ssh_public_key" in "environments/test/variables.tf"


5) Install terraform:

Note: Install terraform as per the OS system instructions given below.

```shell script
https://learn.hashicorp.com/tutorials/terraform/install-cli
```

Check Terraform version:

```shell script
terraform --version
```


# Update variables

Note: Update below given variables in file "environments/test/variables.tf"

1) aws_account_id ( AWS account ID where we want to setup )
2) ami  ( Get value from output of packer section )
3) app_server_ssh_whitelist_ips  ( The IP address from which allow SSH access to app server )


# Create infrastructure and start web application:

Note: Run below given commands from "environments/test/" folder

```shell script
terraform init
terraform plan
terraform apply -auto-approve
```

# Login to web application instance:

Get the public IP of EC2 instance and login with SSH private key generated in first section:

```shell script
terraform output web_app_node_public_ips
```

# Check the website with ALB url:

Get ALB endpoint 

```shell script
terraform output web_app_elb_dns_name
```
Open the output url in web browser, for "Hello World" output of web application.


# To destroy infrastructure:

```shell script
terraform destroy -auto-approve
```
