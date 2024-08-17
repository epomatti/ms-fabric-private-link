# azure-fabric-demo

## Fabric

### Base project

In order to complete this project, initiate a Fabric environment, such as in the [Lakehouse Tutorial][4].

### Licensing

The following licenses are required:

- Power BI license
- Microsoft Fabric
- Microsoft 365

Fabric is available at https://app.fabric.microsoft.com/.

### Private Link

#### Configuration

Set the Fabric tenant to use [Azure Private link][1].

#### Fabric Capacity

In order to use Private Link, purchasing paid Fabric Capacity [is required][1].

After provisioning Fabric Capacity in the [Azure Portal][3], assign the capacity to the workspace.

## Azure infrastructure

### Setup

> [!NOTE]
> This project is built for the **ARM** platform.

Generate the `.auto.tfvars` from the template:

```sh
cp config/template.tfvars
```

Get your public IP address and set it to the `allowed_source_address_prefixes` variable in CIDR format:

```sh
# allowed_source_address_prefixes = ["1.2.3.4/32"]
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

### Post-deployment verification

Start an SSH session in the VM:

```sh
ssh -i keys/temp_rsa.pub azureuser@<public-ip>
```

Check if the initialization script finished successfully:

```sh
cloud-init status --wait
```

Test the docker runtime:

```sh
sudo docker run hello-world
```

Confirm that the Fabric endpoints are resolving to private IPs:

> [!NOTE]
> Make sure that the Fabric endpoints are resolving to private CIDRs

```sh
dig +short app.fabric.microsoft.com
dig +short onelake.dfs.fabric.microsoft.com
dig +short <tenant-object-id-without-hyphens>-api.privatelink.analysis.windows.net
```

## Connect

https://learn.microsoft.com/en-us/fabric/security/security-managed-private-endpoints-create


SQL analytics endpoint

m26bvs4vdluubiodgfvs7sj4bu-m6d5xj5dylcunhnik6jsdwtxte.datawarehouse.fabric.microsoft.com


##



https://learn.microsoft.com/en-us/fabric/get-started/fabric-trial
https://learn.microsoft.com/en-us/fabric/get-started/fabric-trial#other-ways-to-start-a-microsoft-fabric-trial


https://learn.microsoft.com/en-us/fabric/security/security-managed-vnets-fabric-overview
https://learn.microsoft.com/en-us/fabric/data-warehouse/entra-id-authentication
https://learn.microsoft.com/en-us/fabric/data-warehouse/entra-id-authentication


[1]: https://learn.microsoft.com/en-us/fabric/security/security-private-links-overview#other-considerations-and-limitations
[2]: https://learn.microsoft.com/en-us/fabric/security/security-private-links-use
[3]: https://portal.azure.com/#create/Microsoft.Fabric
[4]: https://learn.microsoft.com/en-us/fabric/data-engineering/tutorial-lakehouse-introduction
