# azure-fabric-demo

## Fabric

### Licenses

> [TIP]
> Free trial is available for the required licenses. Microsoft Fabric needs to enabled separately in the Power BI portal.

The following licenses are required:

- Power BI license
- Microsoft Fabric
- Microsoft 365


https://app.fabric.microsoft.com/


### 

Set the Fabric tenant to use [Azure Private link][1].




## Azure infrastructure

> [!NOTE]
> This project is built for the **ARM** platform.

Generate the `.auto.tfvars` from the template:

```sh
cp config/template.tfvars
```

Get your public IP address and set it to the `allowed_source_address_prefixes` variable in CIDR format:

```sh
# Example: allowed_source_address_prefixes = ["1.2.3.4/32"]
curl ipinfo.io/ip
```

Create a temporary key for the Virtual Machine:

```sh
mkdir keys && ssh-keygen -f keys/temp_rsa
```

Deploy the resources:

```sh
terraform init
terraform apply -auto-approve
```

## Post-deployment

```sh
ssh -i keys/temp_rsa.pub azureuser@<public-ip>
```

```sh
cloud-init
```

Test docker:

```sh
sudo docker run hello-world
```

## Connect

https://learn.microsoft.com/en-us/fabric/security/security-managed-private-endpoints-create


##


https://learn.microsoft.com/en-us/fabric/data-engineering/tutorial-lakehouse-introduction
https://learn.microsoft.com/en-us/fabric/get-started/fabric-trial
https://learn.microsoft.com/en-us/fabric/get-started/fabric-trial#other-ways-to-start-a-microsoft-fabric-trial



[1]: https://learn.microsoft.com/en-us/fabric/security/security-private-links-use
