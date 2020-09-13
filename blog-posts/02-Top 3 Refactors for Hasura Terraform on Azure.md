# Top 3 Refactors for Hasura Terraform on Azure 


I posted on the 9th the "[Setup Postgres, and GraphQL API with Hasura on Azure](https://compositecode.blog/2020/09/09/setup-postgres-and-graphql-api-with-hasura-on-azure/)". In that post I had a few refactorings that I wanted to make. The following are the top 3 refactorings that make it much easier to use!

## 1 Changed the Port Used to a Variable



## 2 Get the FQDN via Terraform Output Variable

I made this change so that I don't have to chase down 