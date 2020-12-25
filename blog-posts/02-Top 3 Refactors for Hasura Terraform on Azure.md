# Top 5 Refactors for My Hasura Terraform Deploy on Azure

I posted on the 9th of September, the "[Setup Postgres, and GraphQL API with Hasura on Azure](https://compositecode.blog/2020/09/09/setup-postgres-and-graphql-api-with-hasura-on-azure/)". In that post I had a few refactorings that I wanted to make. The following are the top 3 refactorings that make the project in that repo easier to use!

## 1 Changed the Port Used to a Variable

In the docker-compose and the Terraform automation the port used was using the default for the particular types of deployments. This led to a production and a developer port that is different. It's much easier, and more logical for the port to be the same on both dev and production, for *at least* while we have the console available on the production server (i.e. it should be disabled, more on that in a subsequent post). Here are the details of that change.

In the `docker-compose` file under the `graphql-engine` the ports, I insured were set to the specific port mapping I'd want. For this, the local dev version, I wanted to stick to port 8080. I thus, left this as 8080:8080.

``` yaml
version: '3.6'
services:
  postgres:
    image: library/postgres:12
    restart: always
    environment:
      POSTGRES_PASSWORD: ${PPASSWORD}
    ports:
      - 5432:5432
  graphql-engine:
    image: hasura/graphql-engine:v1.3.3
    ports:
      - "8080:8080"
    depends_on:
      - "postgres"
    restart: always
    environment:
      HASURA_GRAPHQL_DATABASE_URL: postgres://postgres:${PPASSWORD}@postgres:5432/logistics
      HASURA_GRAPHQL_ENABLE_CONSOLE: "true"
volumes:
  db_data:
```

The production version, or whichever version this may be in your build, I added a Terraform variable called `apiport`. This variable I set to be passed in via the script files I use to execute the Terraform.

The script file change looks like this now for launching the environment.

``` javascript
cd terraform

terraform apply -auto-approve \
  -var 'server=logisticscoresystemsdb' \
  -var 'username='$PUSERNAME'' \
  -var 'password='$PPASSWORD'' \
  -var 'database=logistics' \
  -var 'apiport=8080'
```

The destroy script now looks like this.

``` javascript
cd terraform

terraform destroy \
  -var 'server="logisticscoresystemsdb"' \
  -var 'username='$PUSERNAME'' \
  -var 'password='$PPASSWORD'' \
  -var 'database="logistics"' \
  -var 'apiport=8080'
```

There are then three additional sections in the Terraform file, the first is here, the next I'll talk about in refactor 2 below. The changes in the resource as shown below, in the container `ports` section and the `environment_variables` section, simply as `var.apiport`.

``` javascript
resource "azurerm_container_group" "adronshasure" {
  name                = "adrons-hasura-logistics-data-layer"
  location            = azurerm_resource_group.adronsrg.location
  resource_group_name = azurerm_resource_group.adronsrg.name
  ip_address_type     = "public"
  dns_name_label      = "logisticsdatalayer"
  os_type             = "Linux"

  container {
    name   = "hasura-data-layer"
    image  = "hasura/graphql-engine:v1.3.2"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = var.apiport
      protocol = "TCP"
    }

    environment_variables = {
      HASURA_GRAPHQL_SERVER_PORT    = var.apiport
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

With that I now have the port standardized across dev and prod to be 8080. Of course, it could be another port, that's just the one I dicided to go with.

## 2 Get the Fully Qualified Domain Name (FQDN) via a Terraform Output Variable

One thing I kept needing to do after Terraform got production up and going everytime is navigating over to Azure and finding the FQDN to open the console up at (or API calls, etc). To make this easier, since I'm obviously running the script, I added an output variable that concatenates the interpolated FQDN from the results of execution. The output variable looks like this.

``` javascript
output "hasura_uri_path" {
  value = "${azurerm_container_group.adronshasure.fqdn}:${var.apiport}"
}
```

Again, you'll notice I have the `var.apiport` concatenated there at the end of the value. With that, it returns at the end of execution the exact FQDN that I need to navigate to for the Hasura Console!

## 3 Have Terraform Create the Local "Dev" Database on the Postgres Server

I started working with what I had from the previous post "[Setup Postgres, and GraphQL API with Hasura on Azure](https://compositecode.blog/2020/09/09/setup-postgres-and-graphql-api-with-hasura-on-azure/)", and realized I had made a mistake. I wasn't using a database on the database server that actually had the same name. Dev was using the default database and prod was using a newly created named database! Egads, this could cause problems down the road, so I added some Terraform just for creating a new Postgres database for the local deployment. Everything basically stays the same, just a new part to the local script was added to execute this Terraform along with the `docker-compose` command.

First, the Terraform for creating a default logistics database.

``` javascript
terraform {
  required_providers {
    postgresql = {
      source = "cyrilgdn/postgresql"
    }
  }
  required_version = ">= 0.13"
}

provider "postgresql" {
  host            = "localhost"
  port            = 5432
  username        = var.username
  password        = var.password
  sslmode         = "disable"
  connect_timeout = 15
}

resource "postgresql_database" "db" {
  name              = var.database
  owner             = "postgres"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
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
```

Now the script as I setup to call it.

``` shell
docker-compose up -d

terraform init

sleep 1

terraform apply -auto-approve \
  -var 'server=logisticscoresystemsdb' \
  -var 'username='$PUSERNAME'' \
  -var 'password='$PPASSWORD'' \
  -var 'database=logistics'
```

There are more refactorings that I made, but these were the top 3 I did right away! Now my infrastructure as code is easier to use, the scripts are a little bit more seemless, and everything is wrapping into a good development workflow a bit better. 

For JavaScript, Go, Python, Terraform, and more infrastructure, web dev, and coding in general I stream regularly on Twitch at [https://twitch.tv/thrashingcode](https://twitch.tv/thrashingcode), post the VOD's to YouTube along with entirely new tech and *metal* content at [https://youtube.com/c/ThrashingCode](https://youtube.com/c/ThrashingCode).

For more blogging, I've got https://compositecode.blog and the [Thrashing Code Newsletter](https://compositecode.blog/thrashing-composite-code-newsletter/), sign up for it [here](https://compositecode.blog/thrashing-composite-code-newsletter/)!