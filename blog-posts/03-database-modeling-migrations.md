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

For the production deployment of this stack I wanted to deploy to Azure, use Terraform for infrastructure as code, and the Azure database service for Postgres.

## References

* [Postgres](https://www.postgresql.org/)
* [Hasura (OSS)](https://hasura.io/opensource/)
* My past post about the data model I'll be working with, ["Beyond CRUD n’ Cruft Data-Modeling"](https://compositecode.blog/2019/11/25/beyond-crud-n-cruft-data-modeling/)

## Sign Up for Thrashing Code!

For JavaScript, Go, Python, Terraform, and more infrastructure, web dev, and coding in general I stream regularly on Twitch at [https://twitch.tv/adronhall](https://twitch.tv/adronhall), post the VOD's to YouTube along with entirely new tech and *metal* content at [https://youtube.com/c/ThrashingCode](https://youtube.com/c/ThrashingCode).

For more blogging, I've got https://compositecode.blog and the [Thrashing Code Newsletter](https://compositecode.blog/thrashing-composite-code-newsletter/), sign up for it [here](https://compositecode.blog/thrashing-composite-code-newsletter/)!
