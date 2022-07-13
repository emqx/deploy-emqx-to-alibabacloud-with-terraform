# terraform-emqx-emqx-alicloud
> Deploy emqx and emqx-enterprise on alicloud

*Note:* Not support EMQX 5.x currently

## Install terraform
> Please refer to [terraform install doc](https://learn.hashicorp.com/tutorials/terraform/install-cli)


## Alicloud AccessKey Pair
```bash
export ALICLOUD_ACCESS_KEY="anaccesskey"
export ALICLOUD_SECRET_KEY="asecretkey"
export ALICLOUD_REGION="cn-shenzhen"
```

## Deploy EMQ X single node
```bash
cd services/emqx
terraform init
terraform plan
terraform apply -auto-approve
```


## Deploy EMQ X cluster(default 2 node)
```bash
cd services/emqx_cluster
terraform init
terraform plan
terraform apply -auto-approve
```

## Destroy
```bash
terraform destroy -auto-approve
```

## Version
- os
> ubuntu 20.04

- emqx
> emqx open source 4.3.8

## Config variables(optional)
- instance_type
> default is 2C2G `ecs.t6-c1m1.large`

- vpc_cidr
> default is `172.16.0.0/16`

- region
> default is `cn-shenzhen`
