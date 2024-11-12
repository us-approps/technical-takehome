/*
Question 3

Too big to display here.. pls see the link below...
https://github.com/us-approps/technical-takehome/blob/main/q3/README.md
*/

/* Part A: */

-- Question A(i)
**SQL Query to list request_ids for requests made by Democrat Senators:**

    SELECT r.request_id
    FROM requests r
    JOIN senators s ON r.senator_id = s.senator_id
    WHERE s.party = 'Democrat';


join the `requests` table with the `senators` table on `senator_id` because we need to access the party affiliation information
and filter the results where the senator's party is `'Democrat'`.

-- Question A(ii)
-- SQL Query to list all states where only one of the two Senators made a CDS request:

    SELECT s.state
    FROM senators s
    LEFT JOIN requests r ON s.senator_id = r.senator_id
    GROUP BY s.state
    HAVING COUNT(r.request_id) = 1;

Perform a `LEFT JOIN` to include all senators, even if they did not make a CDS request.
then group by `state` to count the number of requests for each state.

---

Part B: Architecture Design

-- Question B(i)
-- System for Tracking Duplicate CDS Requests

- Database Option:
A relational database (e.g., PostgreSQL, MySQL) would be an appropriate choice for this system.
This choice offers powerful querying capabilities, ensuring efficient retrieval and manipulation of duplicate groups.

- Data Schema Design:
    - Tables:
        1. Requests: This table will store the CDS requests, including a unique `request_id`, the associated `senator_id`,
        and relevant details like `title`, `recipient`, etc.
        2. Duplicates: This table will track relationships between requests that are considered duplicates.
        The schema for this table would contain two columns: `request_id_1` and `request_id_2` to store pairs of duplicate requests.
        3. Duplicate Groups: To efficiently track and identify groups of duplicates, we can introduce a duplicate_group_id.
        Each duplicate group will have a unique ID, and each request will be linked to a `duplicate_group_id`.
        Requests that are marked as duplicates will share the same `duplicate_group_id`.

    - Schema Example:
        ```sql
        CREATE TABLE requests (
            request_id INT PRIMARY KEY,
            senator_id INT,
            title VARCHAR(255),
            recipient VARCHAR(255),
            status VARCHAR(50),  -- 'distinct', 'potential', or null
            -- other fields
        );

        CREATE TABLE duplicate_groups (
            group_id INT PRIMARY KEY,
            -- other metadata about the group
        );

        CREATE TABLE request_duplicates (
            request_id INT,
            duplicate_request_id INT,
            duplicate_group_id INT,
            PRIMARY KEY (request_id, duplicate_group_id),
            FOREIGN KEY (request_id) REFERENCES requests(request_id),
            FOREIGN KEY (duplicate_group_id) REFERENCES duplicate_groups(group_id)
        );
        ```

    - Efficient Tracking of Duplicate Groups:
        - The `duplicate_groups` table will represent a set of requests that are duplicates of each other.
        - The `request_duplicates` table will represent the membership of each request in a duplicate group.
        - When two requests are marked as duplicates, we add them to the same `duplicate_group_id`.
        If a third request is added, it will be linked to the same group, and so on.
        This ensures that all related duplicates are stored in a single group.

    - Data Retrieval for Export:
        - To export all duplicate requests, we would query the `request_duplicates` table to group requests by `duplicate_group_id` and export the results.
        - This approach is scalable and efficient, ensuring that retrieving and exporting all requests in a duplicate group can be done with a simple query.

    - Other Options Considered:
        - Graph Database (e.g., Neo4j): A graph database could be used to model the relationships between requests,
        where nodes represent requests and edges represent duplication.
        This could work well for highly interconnected data. However, relational databases are more mature,
        provide more features for analytics, and have better support for operations like joins, which are necessary for this system.
        - NoSQL Databases (e.g., MongoDB): A NoSQL database might be considered for scalability in a distributed system, but it may lack the relational integrity and querying power needed for efficiently handling duplicates. Using a document store without rigid schema constraints could also lead to difficulties with maintaining consistency across request data.

    Tradeoffs:
    - Relational Database: This approach is well-understood and offers strong data consistency guarantees, but it could potentially be less scalable for extremely large datasets (though this is rarely a limitation in most use cases).
    - Graph Database: This would handle complex relationships well, but it may not be as efficient or convenient for handling large numbers of requests and duplicates when considering basic reporting and export tasks.

-- Question B(ii)

Marking CDS Requests as Distinct or Potential Duplicates

- Database Schema:
    - We could add a column in the `requests` or `request_duplicates` table to mark requests as confidently distinct or potential duplicates.
    - A column like `status` in the `request_duplicates` table could indicate whether two requests are marked as:
        - `'distinct'`: The requests are confirmed to be distinct.
        - `'potential'`: The requests are potential duplicates and will need further review.

    Schema Example:
    ```sql
    CREATE TABLE request_duplicates (
        request_id INT,
        duplicate_group_id INT,
        status VARCHAR(50),  -- 'distinct', 'potential', or null
        PRIMARY KEY (request_id, duplicate_group_id),
        FOREIGN KEY (request_id) REFERENCES requests(request_id),
        FOREIGN KEY (duplicate_group_id) REFERENCES duplicate_groups(group_id)
    );
    ```

- How It Works:
    - When two requests are identified as distinct, we set their `status` as `'distinct'`. This allows staff to easily query and exclude them from further duplicate analysis.
    - For potential duplicates, the `status` is set to `'potential'`, flagging them for review or further action.
    - This flagging system allows flexible workflow management and ensures that confident decisions are easily distinguishable from those pending review.

- Alternatives Considered:
    - Separate Tables for Distinct and Potential Duplicates: An alternative design could involve creating two separate tables: one for confirmed distinct requests and another for potential duplicates. However, this would make querying more complex and would require synchronization between tables. Using a single table with a status field is more scalable and simpler to maintain.

- Tradeoffs:
    - Single Table with Status: This design allows for simplicity and efficiency but requires careful handling of statuses during updates.
    - Separate Tables: Although this would provide a clear separation of distinct and potential duplicates, it could result in redundant data and more complex querying when working with both groups simultaneously.

