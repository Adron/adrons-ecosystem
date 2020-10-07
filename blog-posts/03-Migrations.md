# Evolutionary Database Design, GraphQL, APIs, and Database Schema Migrations

## Evolutionary Database Design

Evolutionary Database Design is a practice that has been around for a long time and can be applied to any database storage medium you have. It could be a fancy pants NoSQL database like Apache Cassandra, Mongo, Neo4j, one of a gazillion relational databases like Postgres, mysql, Maria DB, SQL Server, DB2, or the ole' Oracle DB. Whichever database, Evolutionary Database Design helps with several key requirements for any database:

* It synchronizes and provides better integration for those responsible for management of the database(s), likely the Database Administrators (DBAs) in enterprises, to work more concisely and effectively with those responsible for application development against the database(s).
* With almost all databases, developers each get their own database or at least database model mocks to develop against.
* The database schema itself is versioned, providing a way to accurately and safely iterate during application and database development or refactoring.
* As with code of the application, the migrations for the databases are managed in the same or parallel repositories, thus version controlled. Keeping a synchronized versioning across the application and database for deployment and in some cases rolling back to previous versions.
* As refactoring, iterative development, or other mutation of the code and database occur automation should be applied to manage these changes moving forward and for rolling back. As I've often paraphrased; "manually doing this is ok, do twice and ponder automation, do thrice and it's time to automate."

Evolutionary Database Design doesn't stop there however. There are additional offshoots of database management that can benefit from the patterns and process of Evolutionary Database Design. These include, are not limited to, but include the following;

* Managing multiple versions of databases for developers, production, etc.
* Shipping changes with application through automation and related efforts.
* Using multiple applications with a database, or multiple databases with an application, or multiple databases with multiple applications interlined across each other.

Check out the references at the end of this blog entry for further material to read about Evolutionary Database Design.

### My 2 Cents on Evolutionary Database Design

With some of the hostility towards Agile (upper case), agile (lower case), scrum, and some of the ideas often mentioned along with Evolutionary Database design it is extremely important to not conflate this practice and pattern of development with those ideas and practices. There is no *tight coupling* between these things, Evolutionary Database Design, Database Schema Mirations, and related practices  around database development and refactoring are ***not*** *tightly coupled*, they stand on their own and respectively can be used as such.

With that stated, it is important to note that this design acumen and practice around managing one's databases, their development, and the respective APIs and application development related to those databases is extremely effective. It's going on 20 plus years and is still a trusted and liked practice to keep development in an always known state. It folds well into modern mindsets of development as well as new infrastructure capabilities and development ideas such as Infrastructure as Code (IaC).

## GraphQL and APIs



## Database Schema Migrations


## References

* [Martin Fowler's & Pramod Sadalage's Evolutionary Database Design Post](https://martinfowler.com/articles/evodb.html)
* [Refactoring Databases by Pramod Sadalage and Scott Ambler](https://www.amazon.com/gp/product/0321774515/ref=ox_sc_act_title_1?smid=ATVPDKIKX0DER&psc=1)
* [Wikipedia Database Refactoring](https://en.wikipedia.org/wiki/Database_refactoring)

* [Database Refactoring Site](https://www.databaserefactoring.com/)
* [Pramod Sadalage's](https://twitter.com/pramodsadalage) and [Scott Ambler's](https://twitter.com/scottwambler) Twitter Accounts

