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
  "auth_token": "yourToken",
  "name": "User1",
  "email": "test@test.com"
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



## Plans

### Create Plan

Endpoint: POST /api/v1/plans

Attributes: Title

Example Requestbody:
```
{
  "plan": {
      "title": "plan 1"
  }
}
```

Example Response:
```
{
  "data": {
    "id": "2",
    "type": "plan",
    "attributes": {
      "title": "plan 1"
    }
  }
}
```

### Index Plan

You can only view your own plans.

Endpoint: GET /api/v1/plans


Example Response:
```
{
  "data": [
    {
      "id": "1",
      "type": "plan",
      "attributes": {
        "title": "Plan it"
      }
    },
    {
      "id": "2",
      "type": "plan",
      "attributes": {
        "title": "plan 1"
      }
    }
  ]
}
```

### Show Plan

You can only view your own plan.

Endpoint: GET /api/v1/plans/:id

Headers: "Authorization": "YourJWT"

Parameters: Id

Example Response:
```
{
  "data": {
    "id": "2",
    "type": "plan",
    "attributes": {
      "title": "plan 1"
    }
  }
}
```


### Edit Plan

You can only your own plan.

Endpoint: PUT /api/v1/plans/:id

Headers: "Authorization": "YourJWT"

Parameters: Id

Attributes: Title

Example Requestbody:
```
{
    "plan": {
        "title": "new Plan"
    }
}
```

Example Response:
```
{
  "data": {
    "id": "2",
    "type": "plan",
    "attributes": {
      "title": "new Plan"
    }
  }
}
```

### Delete Plan

You can only delete your own plan.

Endpoint: DELETE /api/v1/plans/:id

Headers: "Authorization": "YourJWT"

Parameters: Id



## Categories

### Create Category

Endpoint: POST /api/v1/categories

Attributes: Name

Example Requestbody:
```
{
  "category": {
      "name": "Groceries"
  }
}
```

Example Response:
```
{
  "data": {
    "id": "5",
    "type": "category",
    "attributes": {
      "name": "Groceries"
    }
  }
}
```

### Index Category

You can only view your own categories.

Endpoint: GET /api/v1/categories


Example Response:
```
{
  "data": [
     {
      "id": "1",
      "type": "category",
      "attributes": {
        "name": "Synergistic Wooden Lamp"
      }
    },
    {
      "id": "2",
      "type": "category",
      "attributes": {
        "name": "Rustic Paper Hat"
      }
    },
    {
      "id": "3",
      "type": "category",
      "attributes": {
        "name": "Synergistic Marble Gloves"
      }
    }
  ]
}
```

### Show Category

You can only view your own category.

Endpoint: GET /api/v1/categories/:id

Headers: "Authorization": "YourJWT"

Parameters: Id

Example Response:
```
{
  "data": {
    "id": "5",
    "type": "category",
    "attributes": {
      "name": "Groceries"
    }
  }
}
```


### Edit Category

You can only your own category.

Endpoint: PUT /api/v1/categories/:id

Headers: "Authorization": "YourJWT"

Parameters: Id

Attributes: Name

Example Requestbody:
```
{
  "category": {
      "name": "New Category"
  }
}
```

Example Response:
```
{
  "data": {
    "id": "5",
    "type": "category",
    "attributes": {
      "name": "New Category"
    }
  }
}
```

### Delete Category

You can only delete your own category.

Endpoint: DELETE /api/v1/categories/:id

Headers: "Authorization": "YourJWT"

Parameters: Id



## Transactions

Transactions are nested within plans and must have a valid category.

### Create Transaction

Endpoint: POST /api/v1/plans/:plan_id/transactions

Attributes: Description, Amount, CategoryId

Parameters: PlanId


Example Requestbody:
```
{ 
    "transaction": { 
        "description": "Groceries",
        "amount": "12.00",
        "category_id": "1"
    } 
 } 
```

Example Response:
```
{
  "data": {
    "id": "7",
    "type": "transaction",
    "attributes": {
      "description": "Groceries",
      "spending": false,
      "amount": "12.0",
      "created_at": "2021-06-03T02:56:59.984Z"
    },
    "relationships": {
      "category": {
        "data": {
          "id": "1",
          "type": "category"
        }
      }
    }
  }
}
```

### Index Transaction

You can only view your own transactions.
Categories are included for transactions.
Transactions are paginated. If no "page" parameter is provided the first page is provided. If no "per_page" parameter is provied 20 transactions per page are returned.

Endpoint: GET /api/v1/plans/:plan_id/transactions

Parameters: PlanId, page, per_page

Example Response:
```
{
  "data": [
    {
      "id": "1",
      "type": "transaction",
      "attributes": {
        "description": "Fantastic Bronze Plate",
        "spending": false,
        "amount": "94.71",
        "created_at": "2021-06-02T03:19:44.069Z"
      },
      "relationships": {
        "category": {
          "data": {
            "id": "1",
            "type": "category"
          }
        }
      }
    },
    {
      "id": "3",
      "type": "transaction",
      "attributes": {
        "description": "Small Concrete Pants",
        "spending": false,
        "amount": "55.94",
        "created_at": "2021-06-02T03:19:44.095Z"
      },
      "relationships": {
        "category": {
          "data": {
            "id": "2",
            "type": "category"
          }
        }
      }
    },
    {
      "id": "5",
      "type": "transaction",
      "attributes": {
        "description": "Synergistic Cotton Knife",
        "spending": false,
        "amount": "87.78",
        "created_at": "2021-06-02T03:19:44.118Z"
      },
      "relationships": {
        "category": {
          "data": {
            "id": "3",
            "type": "category"
          }
        }
      }
    }
  ],
  "included": [
    {
      "id": "1",
      "type": "category",
      "attributes": {
        "name": "Synergistic Wooden Lamp"
      }
    },
    {
      "id": "2",
      "type": "category",
      "attributes": {
        "name": "Rustic Paper Hat"
      }
    },
    {
      "id": "3",
      "type": "category",
      "attributes": {
        "name": "Synergistic Marble Gloves"
      }
    }
  ],
  "links": {
    "first": "/api/v1/plans/1/transactions?page=1",
    "last": "/api/v1/plans/1/transactions?page=1",
    "prev": "/api/v1/plans/1/transactions",
    "next": "/api/v1/plans/1/transactions"
  }
}
```

### Show Transaction

You can only view your own transaction.

Endpoint: GET /api/v1/plans/:plan_id/transactions/:id

Headers: "Authorization": "YourJWT"

Parameters: PlanId, Id

Example Response:
```
{
  "data": {
    "id": "7",
    "type": "transaction",
    "attributes": {
      "description": "Groceries",
      "spending": false,
      "amount": "12.0",
      "created_at": "2021-06-03T02:56:59.984Z"
    },
    "relationships": {
      "category": {
        "data": {
          "id": "1",
          "type": "category"
        }
      }
    }
  }
}
```


### Edit Transaction

You can only your own transaction.

Endpoint: PUT /api/v1/plans/:plan_id/transactions/:id

Headers: "Authorization": "YourJWT"

Parameters: PlanId, Id

Attributes: Description, Amount, Category_id

Example Requestbody:
```
{ 
    "transaction": { 
        "description": "New transaction",
        "amount": "12.00",
        "category_id": "1"
    } 
 } 
```

Example Response:
```
{
  "data": {
    "id": "7",
    "type": "transaction",
    "attributes": {
      "description": "New transaction",
      "spending": false,
      "amount": "12.0",
      "created_at": "2021-06-03T02:56:59.984Z"
    },
    "relationships": {
      "category": {
        "data": {
          "id": "1",
          "type": "category"
        }
      }
    }
  }
}
```

### Delete Transaction

You can only delete your own transaction.

Endpoint: DELETE /api/v1/plans/:plan_id/transactions/:id

Headers: "Authorization": "YourJWT"

Parameters: PlanId, Id
