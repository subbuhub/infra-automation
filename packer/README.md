# Pre-requisites:

Install packer as per instructions given in below URL:

```shell script
https://learn.hashicorp.com/tutorials/packer/getting-started-install
```

Check packer version:

```shell script
packer version
```

# Export aws credentials:

Note: Create aws IAM account with neccessary permissions to create EC2 instance

```shell script
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="us-west-2"
```

# Build AWS AMI with packer

```shell script
packer build amazon-linux-2-docker-AMI.json
```

# Capture AMI ID in output

Note: Capture AMI ID in the output to use in terraform section




