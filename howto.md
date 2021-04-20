## Swarm deployment

Preparation:

1. Install terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli)
1. Install Azure CLI (https://docs.microsoft.com/de-de/cli/azure/install-azure-cli-windows?view=azure-cli-latest&tabs=azure-cli)
1. Make sure you have a file "id_rsa.pub" in $HOME\.ssh. If not, do `ssh-keygen -m PEM -t rsa -b 4096`
1. git clone https://github.com/lippertmarkus/azure-swarm-autoscaling

Doing:

1. Open `swarm.tfvars` in `azure-swarm-autoscaling/autoscaling` with a text editor
1. Replace the email address with your email address
1. Check worker and manager size and number
1. Open the `tf` directory in a PowerShell
1. `az login`
1. `az account set --subscription="..."`
1. `terraform init`
1. `terraform apply -var-file ..\autoscaling\swarm.tfvars`

Cleanup:
`terraform destroy`