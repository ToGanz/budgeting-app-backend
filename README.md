# Budgeting-API

This is a JSON API for budgeting functionality written with Ruby on Rails. 
The API follows the [http://jsonapi.org/] specifications.


Technologies used: 
* Ruby on Rails 6.1
* postgresql
* bcrypt and jwt for authentication
* RSpec for tests



I built this app to get familiar with using rails as an API. I plan to use it as a backend for a budgeting app I want to build with vue.js. 
The API uses JSON Web Token for authentication.


Live on: [https://tg-budgeting-app-backend.herokuapp.com/]

## Resources

The api exposes the following resources:

* users
* plans
* categories
* transactions

A user can have many budgeting plans. A plan has many transactions and a Transaction has one category.

To use the functionality of the api, you first have to create an account and login. The login returns a JSON Web Token. This token has to be used in the header under the "authorization" key.

* [Users](#users)
  * [Sign up](#sign-up)
  * [Login](#login)
  * [Show](#show-user)
  * [Edit](#edit-user)
  * [Delete](#delete-user)
* [Plans](#plans)
  * [Create](#create-plan)
  * [Index](#index-plan)
  * [Show](#show-plan)
  * [Edit](#edit-plan)
  * [Delete](#delete-plan)
* [Categories](#categories)
  * [Create](#create-category)
  * [Index](#index-category)
  * [Show](#show-category)
  * [Edit](#edit-category)
  * [Delete](#delete-category)
* [Transactions](#transactions)
  * [Create](#create-transaction)
  * [Index](#index-transaction)
  * [Show](#show-transaction)
  * [Edit](#edit-transaction)
  * [Delete](#delete-transaction)


## Users

### Sign up

Endpoint: POST /api/v1/users
Parameters: Name, Email, Password

Example Request:
```
{
    "user": {
        "name": "User1",
        "email": "test@test.com",
        "password": "password"
    }
}
```

Example Response:
```
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "name": "User1",
      "email": "test@test.com"
    }
  }
}
```