# Database Design and Implementation

Built on the foundation of healthcare and senior living, Rare is posed as a staple product line across the United States and beyond. This is an organization on the rise and since they’ve scaled their operations up in the recent past, the number of entities and the complexity of their relationships have increased. Whenever an organization decides to scale up, they should be more observant in the way they manage their databases. 
Data management helps minimize potential errors by establishing processes and policies for usage and building trust in the data being used to make decisions across your organization. With reliable, up-to-date data, companies can respond more efficiently to market changes and customer needs. Currently the organization manages data using excel sheets, but wants to migrate to databases as they have the advantage to handle large volumes of data. 

Data management allows organizations to effectively scale data and usage occasions with repeatable processes to keep data and metadata up to date. When processes are easy to repeat, your organization can avoid the unnecessary costs of duplication, such as employees conducting the same research repeatedly or re-running costly queries unnecessarily.

# Methodology

In the original database given by Rare, there were 2 master tables with ~10 columns each. Our team concluded that this database model could be made more efficient with the help of normalization because of the following redundancies that we observed.
•	Insertion Anomaly: We couldn’t enter client information as a prospect if they did not place an order
•	Deletion Anomaly: Deleting some order details would delete information about propertly too
•	Updating Anomaly: Modification in the name of Frontier Management would cause changes in multiple rows
It is important that a database is normalized to minimize redundancy and to ensure only related data is stored in each table. It also prevents any issues that stem from the above anomalies.

We ran the database through the 3 stages of normalization – 

•	First Normal Form (1NF): The data was stored in tables with rows uniquely identified by primary key and data within each table was in its most reduced form, only the table “Employees” had multivalued attribute (Employee Phone Number).

•	Second Normal Form (2NF): Only data related to the respective primary key was stored in each table. The 1NF table was decomposed into Item information and Order_Item Information Tables.

•	Third Normal Form (3NF):  We analyzed the 2NF tables and we found out that Transitive dependency existed between OrderID and ShipmentID and concluded that the table had to be further decomposed into 3NF form where the Order Shipment table and Shipment Information table was created. Thus we ensured that there are no in table dependencies between coloumns in each table.

# Recommendation

Recommendations and Conclusion:

•	The firm being a new one there needs to be an initialization of database so that process can be streamlined as and when new products are launched, and new clients are acquired.

•	Having a Snowflake Schema for the Fact and Dimensional model will be suggested in this case for better data retrieval and query purposes

