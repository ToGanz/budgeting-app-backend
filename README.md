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

To use the functionality of the api, you first have to create an account and login. The login returns a JSON Web Token. This token has to be used in the header under the "Authorization" key.

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

Attributes: Name, Email, Password

Example Requestbody:
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
      "name": "test1",
      "email": "test@test.com"
    }
  }
}
```


### Login

Endpoint: POST /api/v1/auth/login

Attributes: Email, Password

Example Requestbody:
```
{
    "user": {
        "email": "test@test.com",
        "password": "password"
    }
}
```

Example Response:
```
{
  "auth_token": "yourToken"
}
```

Use this token for future requests. It has an expiration date of 24 hours.


### Show User

You can only view the authenticated user

Endpoint: GET /api/v1/users/:id

Headers: "Authorization": "YourJWT"

Parameters: Id

Example Response:
```
{
  "data": {
    "id": "2",
    "type": "user",
    "attributes": {
      "name": "test1",
      "email": "test@test.com"
    }
  }
}
```

### Edit User

You can only edit the authenticated user

Endpoint: PUT /api/v1/users/:id

Headers: "Authorization": "YourJWT"

Parameters: Id

Attributes: Name, Email, Password

Example Requestbody:
```
{
  "user": {
      "name": "newName"
  }
}
```

Example Response:
```
{
  "data": {
    "id": "2",
    "type": "user",
    "attributes": {
      "name": "newName",
      "email": "test@test.com"
    }
  }
}
```

### Delete User

You can only delete the authenticated user

Endpoint: DELETE /api/v1/users/:id

Headers: "Authorization": "YourJWT"

Parameters: Id


