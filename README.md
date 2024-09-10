# Point Transaction

This is a Ruby on Rails application for managing point transactions.

## Project Description

The application provides APIs to handle single and bulk point transactions. It includes endpoints to create transactions and validate them.

## Setup Instructions

### Prerequisites

- Ruby 2.7.8
- Rails 7.1.2
- PostgreSQL

### Installation

1. **Clone the repository**:
   ```sh
   git clone git@github.com-haidang:haidang-lhd/point_transaction.git
   cd point_transaction


2. Install dependencies:

`bundle install`

3. Setup the database:
````
rails db:create
rails db:migrate
````

4. Setup the database:
````
rails server
````

The application will be available at http://localhost:3000.


API Endpoints
Create a Single Transaction
Endpoint: `POST /api/v1/transactions/single`

````
curl --location --request POST 'http://localhost:3000/api/v1/transactions/single' \
--data ''
````

Response:
Success: 201 Created
````
{
    "status": "success",
    "transaction_id": "unique-transaction-id"
}
````

Error: 422 Unprocessable Entity

````
{
    "status": "error",
    "errors": [
        "Transaction ID can't be blank",
        "Points can't be blank",
        "User ID can't be blank"
    ]
}
````


Create Bulk Transactions
Endpoint: POST /api/v1/transactions/bulk

Request Example:
````
curl --location --request POST 'http://localhost:3000/api/v1/transactions/bulk' \
--header 'Content-Type: application/json' \
--data ''
````

Response:

Success: 200 OK

````
{
    "status": "success",
    "processed_count": 2
}
````

Error: 422 Unprocessable Entity

````
{
    "status": "error",
    "errors": [
        "Transaction ID can't be blank",
        "Points can't be blank",
        "User ID can't be blank"
    ]
}
````


Check coverage
`open coverage/index.html`
