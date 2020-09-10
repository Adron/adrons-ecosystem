Posted:

* https://dev.to/adron/setup-postgres-and-graphql-api-with-hasura-on-azure-4mne
* https://compositecode.blog/2020/09/09/setup-postgres-and-graphql-api-with-hasura-on-azure/
* https://medium.com/@adron/setup-postgres-and-graphql-api-with-hasura-on-azure-980bb1873da4

# Setting up Postgres DB and Graphql API with Hasura

***Key Technologies:*** Hasura, Postgres, Terraform, and Azure.

I created a data model to store railroad systems, services, scheduled, time points, and related information, detailing the schema ["Beyond CRUD n’ Cruft Data-Modeling"](https://compositecode.blog/2019/11/25/beyond-crud-n-cruft-data-modeling/) with a few tweaks. The original I'd created for Apache Cassandra, and have since switched to Postgres giving the option of primary and foreign keys, relations, and the related connections for the model.

In this post I'll use that schema to build out an infrastructure as code solution with [Terraform](https://www.terraform.io/), utilizing [Postgres](https://www.postgresql.org/) and [Hasura (OSS)](https://hasura.io/opensource/).

## Prerequisites

* Terraform & Azure CLI - [Installation & Setup](https://compositecode.blog/2019/08/01/development-workspace-with-terraform/).
* Docker - Installation & Setup on [Windows](https://docs.docker.com/docker-for-windows/install/)/[Windows Home](https://docs.docker.com/docker-for-windows/install-windows-home/), [MacOS](https://docs.docker.com/docker-for-mac/install/), Linux [Ubuntu](https://docs.docker.com/engine/install/ubuntu/), [Fedora](https://docs.docker.com/engine/install/fedora/), [Debian](https://docs.docker.com/engine/install/debian/), or [CentOS](https://docs.docker.com/engine/install/centos/).
* Hasura CLI - [Installing the binary globally](https://hasura.io/docs/1.0/graphql/manual/hasura-cli/install-hasura-cli.html#install-a-binary-globally), and [other options](https://hasura.io/docs/1.0/graphql/manual/hasura-cli/install-hasura-cli.html).

## Docker Compose Development Environment

For the Docker Compose file I just placed them in the root of the repository. Add a docker-compose.yaml file and then added services. The first service I setup was the Postgres/PostgreSQL database. This is using the standard [Postgres image on Docker Hub](https://hub.docker.com/_/postgres/). I opted for version 12, I do want it to always restart if it gets shutdown or crashes, and then the last of the obvious settings is the port which maps from 5432 to 5432.

For the volume, since I might want to backup or tinker with the volume, I put the db_data location set to my own `Codez` directory. All my databases I tend to setup like this in case I need to debug things locally.

The POSTGRES_PASSWORD is an environment variable, thus the syntax `${PPASSWORD}`. This way no passwords go into the repo. Then I can load the environment variable via a standard `export POSTGRES_PASSWORD="theSecretPasswordHere!"` line in my system startup script or via other means.

```yaml
services:
  postgres:
    image: postgres:12
    restart: always
    volumes:
      - db_data:/Users/adron/Codez/databases
    environment:
      POSTGRES_PASSWORD: ${PPASSWORD}
    ports:
      - 5432:5432
```

For the db_data volume, toward the bottom I add the key value setting to reference it.

```yaml
volumes:
  db_data:
```

Next I added the GraphQL solution with Hasura. The image for the v1.1.0 probably needs to be updated (I believe we're on version 1.3.x now) so I'll do that soon, but got the example working with v1.1.0. Next I've got the ports mapped to open 8080 to 8080. Next, this service will depend on the postgres service already detailed. Restart, also set on always just as the postgres service. Finally two evnironment variables for the container:

* HASURA_GRAPHQL_DATABASE_URL - this variable is the base postgres URL connection string.
* HASURA_GRAPHQL_ENABLE_CONSOLE - this is the variable that will set the console user interface to initiate. We'll definitely want to have this for the development environment. However in production I'd likely want this turned off.

```yaml
  graphql-engine:
    image: hasura/graphql-engine:v1.1.0
    ports:
      - "8080:8080"
    depends_on:
      - "postgres"
    restart: always
    environment:
      HASURA_GRAPHQL_DATABASE_URL: postgres://postgres:logistics@postgres:5432/postgres
      HASURA_GRAPHQL_ENABLE_CONSOLE: "true"
```

At this point the commands to start this are relatively minimal, but in spite of that I like to create a start and stop shell script. My start script and stop script simply look like this:

Starting the services.

```shell
docker-compose up -d
```

For the first execution of the services you may want to skip the -d and instead watch the startup just to become familiar with the events and connections as they start.

Stopping the services.

```shell
docker-compose down
```

🚀 That's it for the basic development environment, we're launched and ready for development. With the services started, navigate to [https://localhost:8080/console](https://localhost:8080/console) to start working with the user interface, which I'll have a more details on the ["Beyond CRUD n’ Cruft Data-Modeling"](https://compositecode.blog/2019/11/25/beyond-crud-n-cruft-data-modeling/) swap to Hasura and Postgres in an upcoming blog post.

For full syntax of the docker-compose.yaml file, I've included it here:

```yaml
version: '3.6'
services:
  postgres:
    image: postgres:12
    restart: always
    volumes:
      - db_data:/Users/adron/Codez/databases
    environment:
      POSTGRES_PASSWORD: ${PPASSWORD}
    ports:
      - 5432:5432
  graphql-engine:
    image: hasura/graphql-engine:v1.1.0
    ports:
      - "8080:8080"
    depends_on:
      - "postgres"
    restart: always
    environment:
      HASURA_GRAPHQL_DATABASE_URL: postgres://postgres:logistics@postgres:5432/postgres
      HASURA_GRAPHQL_ENABLE_CONSOLE: "true"
volumes:
  db_data:
```

## Terraform Production Environment

For the production deployment of this stack I want to deploy to [Azure](https://azure.microsoft.com/en-us/), use [Terraform](https://www.terraform.io/) for infrastructure as code, and the [Azure database service for Postgres](https://azure.microsoft.com/en-us/services/postgresql/) while running [Hasura](https://hasura.io/) for my API GraphQL tier.

For the Terraform files I created a folder and added a `main.tf` file. I always create a folder to work in, generally, to keep the state files and initial prototyping of the infrastructre in a singular place. Eventually I'll setup a location to store the state and fully automate the process through a continues integration (CI) and continuous delivery (CD) process. For now though, just a singular folder to keep it all in.

For this I know I'll need a few variables and add those to the file. These are variables that I'll use to provide values to multiple resources in the Terraform templating.

```javascript
variable "database" {
  type = string
}

variable "server" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}
```

One other variable I'll want so that it is a little easier to verify what my Hasura connection information is, will look like this.

```javascript
output "hasura_url" {
  value = "postgres://${var.username}%40${azurerm_postgresql_server.logisticsserver.name}:${var.password}@${azurerm_postgresql_server.logisticsserver.fqdn}:5432/${var.database}"
}
```

Let's take this one apart a bit. There is a lot of concatenated and interpolated variables being wedged together here. This is basically the Postgres connection string that Hasura will need to make a connection. It includes the username and password, and all of the pertinent parsed and string escaped values. Note specifically the `%40` between the `${var.username}` and `${azurerm_postgresql_server.logisticsserver.name}` variables while elsewhere certain characters are not escaped, such as the `@` sign. When constructing this connection string, it is very important to be prescient of all these specific values being connected together. But, I did the work for you so it's a pretty easy copy and paste now!

Next I'll need the Azure provider information.

```javascript
provider "azurerm" {
  version = "=2.20.0"
  features {}
}
```

Note that there is a `features` array that is just empty, it is now required for the provider to designate this even if the array is empty.

Next up is the resource group that everything will be deployed to.

```javascript
resource "azurerm_resource_group" "adronsrg" {
  name     = "adrons-rg"
  location = "westus2"
}
```

Now the Postgres Server itself. Note the `location` and `resource_group_name` simply map back to the resource group. Another thing I found a little confusing, as I wasn't sure if it was a Terraform name or resource name tag or the server name itself, is the "name" key value pair in this resource. It is however the server name, which I've assigned `var.server`. The next value assigned "B_Gen5_2" is the Azure designator, which is a bit cryptic. More on that in a future post.

After that information the storage is set to, I believe if I RTFM'ed correctly to 5 gigs of storage. For what I'm doing this will be fine. The backup is setup for 7 days of retention. This means I'll be able to fall back to a backup from any of the last seven days, but after 7 days the backups are rolled and the last day is deleted to make space for the newest backup. The `geo_redundant_backup_enabled` setting is set to false, because with Postgres' excellent reliability and my desire to not pay for that extra reliability insurance, I don't need geographic redundancy. Last I set `auto_grow_enabled` to true, albeit I do need to determine the exact flow of logic this takes for this particular implementation and deployment of Postgres.

The last chunk of details for this resource are simply the username and password, which are derived from variables, which are derived from environment variables to keep the actual username and passwords out of the repository. The last two bits set the ssl to enabled and the version of Postgres to v9.5.

```javascript
resource "azurerm_postgresql_server" "logisticsserver" {
  name = var.server
  location = azurerm_resource_group.adronsrg.location
  resource_group_name = azurerm_resource_group.adronsrg.name
  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.username
  administrator_login_password = var.password
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}
```

Since the database server is all setup, now I can confidently add an actual database to that database. Here the `resource_group_name` pulls from the resource group resource and the `server_name` pulls from the server resource. The name, being the database name itself, I derive from a variable too. Then the character set is UTF8 and collation is set to US English, which are generally standard settings on Postgres being installed for use within the US. 

```javascript
resource "azurerm_postgresql_database" "logisticsdb" {
  name                = var.database
  resource_group_name = azurerm_resource_group.adronsrg.name
  server_name         = azurerm_postgresql_server.logisticsserver.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
```

The next thing I discovered, after some trial and error and a good bit of searching, is the Postgres specific firewall rule. It appears this is related to the Postgres service in Azure specifically, as for a number of trials and many errors I attempted to use the standard available firewalls and firewall rules that are available in virtual networks. My understanding now is that the Postgres Servers exist outside of that paradigm and by relation to that have their own firewall rules.

This firewall rule basically attaches the firewall to the resource group, then the server itself, and allows internal access between the Postgres Server and the Hasura instance.

```javascript
resource "azurerm_postgresql_firewall_rule" "pgfirewallrule" {
  name                = "allow-azure-internal"
  resource_group_name = azurerm_resource_group.adronsrg.name
  server_name         = azurerm_postgresql_server.logisticsserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
```

The last and final step is setting up the Hasura instance to work with the Postgres Server and the designated database now available.

To setup the Hasura instance I decided to go with the container service that Azure has. It provides a relatively inexpensive, easier to setup, and more concise way to setup the server than setting up an entire VM or full Kubernetes environment just to run a singular instance.

The first section sets up a public IP address, which of course I'll need to change as the application is developed and I'll need to provide an actual secured front end. But for now, to prove out the deployment, I've left it public, setup the DNS label, and set the OS type.

The next section in this resource I then outline the container details. The name of the container can be pretty much whatever you want it to be, it's your designator. The image however is specifically `hasura/graphql-engine`. I've set the CPU and memory pretty low, at 0.5 and 1.5 respectively as I don't suspect I'll need a ton of horsepower just to test things out.

Next I set the port available to port 80. Then the environment variables `HASURA_GRAPHQL_SERVER_PORT` and `HASURA_GRAPHQL_ENABLE_CONSOLE` to that port to display the console there. Then finally that wild concatenated interpolated connection string that I have setup as an output variable - again specifically for testing - `HASURA_GRAPHQL_DATABASE_URL`.

```javascript
resource "azurerm_container_group" "adronshasure" {
  name                = "adrons-hasura-logistics-data-layer"
  location            = azurerm_resource_group.adronsrg.location
  resource_group_name = azurerm_resource_group.adronsrg.name
  ip_address_type     = "public"
  dns_name_label      = "logisticsdatalayer"
  os_type             = "Linux"


  container {
    name   = "hasura-data-layer"
    image  = "hasura/graphql-engine"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      HASURA_GRAPHQL_SERVER_PORT = 80
      HASURA_GRAPHQL_ENABLE_CONSOLE = true
    }
    secure_environment_variables = {
      HASURA_GRAPHQL_DATABASE_URL = "postgres://${var.username}%40${azurerm_postgresql_server.logisticsserver.name}:${var.password}@${azurerm_postgresql_server.logisticsserver.fqdn}:5432/${var.database}"
    }
  }

  tags = {
    environment = "datalayer"
  }
}
```

With all that setup it's time to test. But first, just for clarity here's the entire Terraform file contents.

```javascript
provider "azurerm" {
  version = "=2.20.0"
  features {}
}

resource "azurerm_resource_group" "adronsrg" {
  name     = "adrons-rg"
  location = "westus2"
}

resource "azurerm_postgresql_server" "logisticsserver" {
  name = var.server
  location = azurerm_resource_group.adronsrg.location
  resource_group_name = azurerm_resource_group.adronsrg.name
  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.username
  administrator_login_password = var.password
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "logisticsdb" {
  name                = var.database
  resource_group_name = azurerm_resource_group.adronsrg.name
  server_name         = azurerm_postgresql_server.logisticsserver.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "pgfirewallrule" {
  name                = "allow-azure-internal"
  resource_group_name = azurerm_resource_group.adronsrg.name
  server_name         = azurerm_postgresql_server.logisticsserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_container_group" "adronshasure" {
  name                = "adrons-hasura-logistics-data-layer"
  location            = azurerm_resource_group.adronsrg.location
  resource_group_name = azurerm_resource_group.adronsrg.name
  ip_address_type     = "public"
  dns_name_label      = "logisticsdatalayer"
  os_type             = "Linux"


  container {
    name   = "hasura-data-layer"
    image  = "hasura/graphql-engine"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      HASURA_GRAPHQL_SERVER_PORT = 80
      HASURA_GRAPHQL_ENABLE_CONSOLE = true
    }
    secure_environment_variables = {
      HASURA_GRAPHQL_DATABASE_URL = "postgres://${var.username}%40${azurerm_postgresql_server.logisticsserver.name}:${var.password}@${azurerm_postgresql_server.logisticsserver.fqdn}:5432/${var.database}"
    }
  }

  tags = {
    environment = "datalayer"
  }
}

variable "database" {
  type = string
}

variable "server" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

output "hasura_url" {
  value = "postgres://${var.username}%40${azurerm_postgresql_server.logisticsserver.name}:${var.password}@${azurerm_postgresql_server.logisticsserver.fqdn}:5432/${var.database}"
}
```

To run this, similarly to how I setup the dev environment, I've setup a startup and shutdown script. The startup script named `prod-start.sh` has the following commands. Note the `$PUSERNAME` and `$PPASSWORD` are derived from environment variables, where as the other two values are just inline.

```shell
cd terraform

terraform apply -auto-approve \
    -var 'server=logisticscoresystemsdb' \
    -var 'username='$PUSERNAME'' \
    -var 'password='$PPASSWORD'' \
    -var 'database=logistics'
```

Executing that script gives me results that, if everything goes right, looks similarly to this.

```shell
./prod-start.sh 
azurerm_resource_group.adronsrg: Creating...
azurerm_resource_group.adronsrg: Creation complete after 1s [id=/subscriptions/77ad15ff-226a-4aa9-bef3-648597374f9c/resourceGroups/adrons-rg]
azurerm_postgresql_server.logisticsserver: Creating...
azurerm_postgresql_server.logisticsserver: Still creating... [10s elapsed]
azurerm_postgresql_server.logisticsserver: Still creating... [20s elapsed]


...and it continues.
```

Do note that this process will take a different amount of time and is completely normal for it to take ~3 or more minutes. Once the server is done in the build process a lot of the other activities start to take place very quickly. Once it's all done, toward the end of the output I get my hasura_url output variable so that I can confirm that it is indeed put together correctly! Now that this is preformed I can take next steps and remove that output variable, start to tighten security, and other steps. Which I'll detail in a future blog post once more of the application is built.

```shell
... other output here ...


azurerm_container_group.adronshasure: Still creating... [40s elapsed]
azurerm_postgresql_database.logisticsdb: Still creating... [40s elapsed]
azurerm_postgresql_database.logisticsdb: Still creating... [50s elapsed]
azurerm_container_group.adronshasure: Still creating... [50s elapsed]
azurerm_postgresql_database.logisticsdb: Creation complete after 51s [id=/subscriptions/77ad15ff-226a-4aa9-bef3-648597374f9c/resourceGroups/adrons-rg/providers/Microsoft.DBforPostgreSQL/servers/logisticscoresystemsdb/databases/logistics]
azurerm_container_group.adronshasure: Still creating... [1m0s elapsed]
azurerm_container_group.adronshasure: Creation complete after 1m4s [id=/subscriptions/77ad15ff-226a-4aa9-bef3-648597374f9c/resourceGroups/adrons-rg/providers/Microsoft.ContainerInstance/containerGroups/adrons-hasura-logistics-data-layer]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

hasura_url = postgres://postgres%40logisticscoresystemsdb:theSecretPassword!@logisticscoresystemsdb.postgres.database.azure.com:5432/logistics
```

Now if I navigate over to `logisticsdatalayer.westus2.azurecontainer.io` I can view the Hasura console! But where in the world is this fully qualified domain name (FQDN)?

## References

* [Postgres](https://www.postgresql.org/)
* [Hasura (OSS)](https://hasura.io/opensource/)
* My past post about the data model I'll be working with, ["Beyond CRUD n’ Cruft Data-Modeling"](https://compositecode.blog/2019/11/25/beyond-crud-n-cruft-data-modeling/)

## Sign Up for Thrashing Code

For JavaScript, Go, Python, Terraform, and more infrastructure, web dev, and coding in general I stream regularly on Twitch at [https://twitch.tv/adronhall](https://twitch.tv/adronhall), post the VOD's to YouTube along with entirely new tech and *metal* content at [https://youtube.com/c/ThrashingCode](https://youtube.com/c/ThrashingCode).

For more blogging, I've got https://compositecode.blog and the [Thrashing Code Newsletter](https://compositecode.blog/thrashing-composite-code-newsletter/), sign up for it [here](https://compositecode.blog/thrashing-composite-code-newsletter/)!
