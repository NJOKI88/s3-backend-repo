# My functions

environment () {
    TF_VAR_environment=prod
    ENVIRONMENT="${TF_VAR_environment}"
    TF_PLAN="${env}.tfplan"
    TF_PLAN_JSON="${TF_PLAN}.json"

    TERRAFORM_VERSION="1.6.0"
    
}

workspace () {
 echo "you are about to modify $env environment"
 terraform workspace new $env
 terraform workspace select $env
}

test () {
    terraform init
    terraform fmt -recursive
    terraform validate
    terraform plan -out ./terraform.tfstate.d/$env/${TF_PLAN}
    terraform show -json ./terraform.tfstate.d/$env/${TF_PLAN} > ./terraform.tfstate.d/$env/$env${TF_PLAN-JSON}
    checkov -f ./terraform.tfstate.d/$env/${TF_PLAN_JSON}
}

apply () {
  terraform init
  terraform fmt -recursive
  terraform validate
  terraform plan -out ./terraform.tfstate.d/$env/${TF_PLAN}
  terraform apply ./terraform.tfstate.d/$env/${TF_PLAN}

}
creds () {
 export VAULT_ADDR="http://127.0.0.1:8200"
 export VAULT_AWS_ROLE="ec2-admin-role"
 export VAULT_TOKEN="$(cat ~/.vault-token)"
 sleep 2
 unset AWS_ACCESS_KEY_ID
 unset AWS_SECRET_ACCESS_KEY
 export AWS_CREDS="$(vault read aws/creds/${VAULT_AWS_ROLE} -format=json)"
 sleep 10
 export AWS_ACCESS_KEY_ID="(echo $AWS_CREDS | jq -r .data.access_key)"
 export AWS_SECRET_ACCESS_KEY="$(echo $AWS_CREDS | jq -r .data.secret_key)"
 export AWS_DEFAULT_REGION="us-east-2"

 [ -d .terraform ] && rm -rf .terraform

 if [ -z "${AWS_SECRET_ACCESS_KEY}" ] || [ -z "${AWS_ACCESS_KEY_ID}" ] || [ -z "${AWS_DEFAULT_REGION}" ] || [ -z "${ENVIRONMENT}" ]
    echo "AWS credentials and default region must be set!"
    exit 1
    
}
