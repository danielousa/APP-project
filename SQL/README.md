# Development Technologies

For the implementation of the project's database, we used Microsoft SQL Server Management Studio (version 19.3), with a prior creation of the relational model diagram using Draw.io.

Initially, we designed the relational model, establishing all entities, attributes, data types, and their relationships. Based on this schema, we developed our database by creating the tables (entities) with the previously defined attributes, selecting a unique identifier for each table as the primary key (PK), specifying the existing foreign keys (FK), and creating constraints according to the needs of our database.

After creating the database, we proceeded to implement CRUD procedures and some triggers that we considered necessary, particularly to restrict the user ID in certain tables to only one acceptable user type.

Finally, we used ChatGPT to generate dummy (fictitious) data, which we inserted into our database to perform testing.

# ER-Diagram

<img width="1336" height="687" alt="Captura de ecrã 2025-08-13 185648" src="https://github.com/user-attachments/assets/95bdb550-16b6-4404-af36-40e007c69c56" />


