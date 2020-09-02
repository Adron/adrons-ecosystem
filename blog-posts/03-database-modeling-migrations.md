# Setting up Postgres DB and Graphql API with Hasura

Key Technologies: Hasura, Postgres, Terraform, and Azure.

I created a data model to store railroad systems, services, scheduled, time points, and related information, detailing the schema ["Beyond CRUD n’ Cruft Data-Modeling"](https://compositecode.blog/2019/11/25/beyond-crud-n-cruft-data-modeling/) with a few tweaks. The original I'd created for Apache Cassandra, and have since switched to Postgres giving the option of primary and foreign keys, relations, and the related connections for the model.

In this post I'll use that schema to build out an infrastructure as code solution with [Terraform](https://www.terraform.io/), utilizing [Postgres](https://www.postgresql.org/) and [Hasura (OSS)](https://hasura.io/opensource/).

## Prerequisites

* Terraform & Azure CLI - [Installation & Setup](https://compositecode.blog/2019/08/01/development-workspace-with-terraform/).
* Hasura CLI - [Installing the binary globally](https://hasura.io/docs/1.0/graphql/manual/hasura-cli/install-hasura-cli.html#install-a-binary-globally), and [other options](https://hasura.io/docs/1.0/graphql/manual/hasura-cli/install-hasura-cli.html).

## References

* [Postgres](https://www.postgresql.org/)
* [Hasura (OSS)](https://hasura.io/opensource/)
