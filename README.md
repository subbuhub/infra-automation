# Requirement

Create simple nodejs application and deploy in AWS with automation tools

# Build docker image:

Create docker image and push to docker registry.

    Follow the README.md file in "docker" folder for instructions.

# Create AWS AMI image for web application server:

Build AMI image with docker installation 

Note the AMI ID for next section

    Follow the README.md file in "packer" folder for instructions


# Build infrastructure and start application:

Note: All the below given steps done through automation using terraform for Infrastructure-as-a-service
      
    Follow the README.md file in "terraform" folder for instructions

1) Creates VPC
2) Creates SSH key pair
3) Creates Launch configuration
4) Creates application load balancer
5) Creates Auto scale group
6) Creates EC2 instance with user data ( to start docker container )
