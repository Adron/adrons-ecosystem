# Top 5 Refactors for My Hasura Terraform Deploy on Azure


I posted on the 9th the "[Setup Postgres, and GraphQL API with Hasura on Azure](https://compositecode.blog/2020/09/09/setup-postgres-and-graphql-api-with-hasura-on-azure/)". In that post I had a few refactorings that I wanted to make. The following are the top 3 refactorings that make it much easier to use!

## 1 Changed the Port Used to a Variable



## 2 Get the FQDN via Terraform Output Variable

I made this change so that I don't have to chase down 

## 3 Have Terraform Create the Local "Dev" Database on the Postgres Server

This is about the "local" dev deploy, but it's using Terraform and needs to map closely to that of the prod deploy on Azure. I added this when I realized my databases I was using in each environment weren't the same database.

https://github.com/Adron/adrons-ecosystem/blob/master/pg_db.tf

## 4 HASURA_GRAPHQL_DATABASE_URL: postgres://postgres:${PPASSWORD}@postgres:5432/logistics

## 5     volumes:
      - db_data:/var/lib/postgresql/data