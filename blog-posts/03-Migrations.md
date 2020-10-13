# Evolutionary Database Design, GraphQL, APIs, and Database Schema Migrations

## Evolutionary Database Design

Evolutionary Database Design is a practice that has been around for a long time and can be applied to any database storage medium you have. It could be a fancy pants NoSQL database like Apache Cassandra, Mongo, Neo4j, one of a gazillion relational databases like Postgres, mysql, Maria DB, SQL Server, DB2, or the ole' Oracle DB. Whichever database, Evolutionary Database Design helps with several key requirements for any database:

* It synchronizes and provides better integration for those responsible for management of the database(s), likely the Database Administrators (DBAs) in enterprises, to work more concisely and effectively with those responsible for application development against the database(s).
* With almost all databases, developers each get their own database or at least database model mocks to develop against.
* The database schema itself is versioned, providing a way to accurately and safely iterate during application and database development or refactoring.
* As with code of the application, the migrations for the databases are managed in the same or parallel repositories, thus version controlled. Keeping a synchronized versioning across the application and database for deployment and in some cases rolling back to previous versions.
* As refactoring, iterative development, or other mutation of the code and database occur automation should be applied to manage these changes moving forward and for rolling back. As I've often paraphrased; *"manually doing this is ok, do twice and ponder automation, do thrice and it's time to automate."*

Evolutionary Database Design doesn't stop there however. There are additional offshoots of database management that can benefit from the patterns and process of Evolutionary Database Design. These include, are not limited to, but include the following;

* Managing multiple versions of databases for developers, production, etc.
* Shipping changes with application through automation and related efforts.
* Using multiple applications with a database, or multiple databases with an application, or multiple databases with multiple applications interlined across each other.

Check out the references at the end of this blog entry for further material to read about Evolutionary Database Design.

### My 2 Cents on Evolutionary Database Design

With some of the hostility towards Agile (upper case), agile (lower case), scrum, and some of the ideas often mentioned along with Evolutionary Database design it is extremely important to not conflate this practice and pattern of development with those ideas and practices. There is no *tight coupling* between these things, Evolutionary Database Design, Database Schema Mirations, and related practices  around database development and refactoring are ***not*** *tightly coupled*, they stand on their own and respectively can be used as such.

With that stated, it is important to note that this design acumen and practice around managing one's databases, their development, and the respective APIs and application development related to those databases is extremely effective. It's going on 20 plus years and is still a trusted and liked practice to keep development in an always known state. It folds well into modern mindsets of development as well as new infrastructure capabilities and development ideas such as Infrastructure as Code (IaC).

## GraphQL and APIs

Many of the relational databases have a plethora of options focused around accessing and managing data in a database. Very specifically relational databases like Postgres, SQL Server, Mysql, Oracle, and the like. These could be Object Relationship Mappers, or ORMs, Active Record, or a number of other patterns. A modern approach that has risen from all of these various patterns is to use GraphQL via an API as the access pattern over whatever the database is. One can implement a GraphQL Server themselves, per spec, over whatever data source they have, and there are many options that are built that offer server capabilities via API (Apollo, Hasura, and others).

With the advent of this layer, where GraphQL is provided via API access, there is a need to manage the metadata and API schema of the system along with any database schema itself. What this manifests as, when working with an evolutionary database design practice, is to work with the API as if it is the database itself. This way during development one would iterate on the API and the respective schema of the API in conjunction with the database versioning done with the schema migrations. With each solution one might have to build custom tooling to do this, but in this post as I move into examples of process and flow around database schema migration I'll be using the Hasura CLI. This CLI gives us prebuilt capabilities to keep the API schema and database schema in versioned synchronization.

Enough theory and ideas, let's talk about some real examples.

## Database Schema Migrations

There are two scenarios I will work through in the following examples. One building on the other. The first is a scenario in which a green field application, just getting started, needs to be initialized and setup for schema migrations. There are two primary examples that I've provided in the following: using the user interface to build out or start the initial schema migration, and a secondary option to build all elements of the schema migration process manually. Both of these options use the Hasura CLI to cover metadata and related collateral for organizing the iteration, version, and folder structure creation.

### GUI Method 

This method uses the following tools and features:

* Hasura CLI
* Hasura Console



### Manual Method 

* Hasura CLI





## References

**Evolutionary Database Design**

* [Martin Fowler's & Pramod Sadalage's Evolutionary Database Design Post](https://martinfowler.com/articles/evodb.html)
* [Refactoring Databases by Pramod Sadalage and Scott Ambler](https://www.amazon.com/gp/product/0321774515/ref=ox_sc_act_title_1?smid=ATVPDKIKX0DER&psc=1)
* [Wikipedia Database Refactoring](https://en.wikipedia.org/wiki/Database_refactoring)
* [Database Refactoring Site](https://www.databaserefactoring.com/)
* [Pramod Sadalage's](https://twitter.com/pramodsadalage) and [Scott Ambler's](https://twitter.com/scottwambler) Twitter Accounts

**Database Schema Migrations & Metadata Mgirations**

* [**docs** Hasura Migrations & Metadata v2](https://hasura.io/docs/1.0/graphql/core/migrations/index.html)
* [**docs** ]()

* [Migration Katas: Common Database and Migration Workflows with Hasura](https://youtu.be/eoIHuTEDu1Q)
* [Hasura Migrations [GraphQL engine, pragmatic overview, 2020]](https://youtu.be/edeJZz022AY)
* [Migrations on the Hasura GraphQL Engine](https://youtu.be/eWymkJ3KF6g)
* [Schema and Metadata migrations with Hasura](https://youtu.be/fRHZQAEd-Q0)
