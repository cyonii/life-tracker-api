# Life Tracker - API

Life Tracker - keeps track of daily activities like Sleep, Exercise, Work, Study, etc. It keep records like the `duration` of activities, `satisfaction` experienced, and other data regarding a particular `Activity`.

This is an api-only that securely exposes endpoints to the consumer from which they can perform CRUD operations on their activity records.

## Ruby version

This project is built on [`ruby 3.0.1`](https://www.ruby-lang.org)

## System dependencies

Make sure you have [`ruby 3.0.1`](https://www.ruby-lang.org) installed on your machine.
For database, you need to have `PostgreSQL` installed.

## Specification

The API follows the [json-api.org](https://jsonapi.org/) specification.

## ERD

The Entity Relationship Diagram below visualises how the tables relate in the database.

![Screenshot](./doc/img/life-tracker-erd.png)

## Database creation

To get the database up and running, run the command below:

```ruby
rails db:create <!-- Creates database -->
rails db:migrate <!-- Migrates database -->
```

## Database initialization

This operation should seed the `Activity` table of the database.

```ruby
rails db:seed
```

## Launching

To launch the application, run the command below:

```ruby
rails s
```

## Endpoints

### V1

For the `version 1` of this API, these are the endpoints exposed by the backend from the base url `/api/v1`

#### Create a new user

To sign up a new user

```ruby
# Request
POST /api/v1/users

# Payload
{
  user: {
    username: "johndoe",
    email: "johndoe@email.com",
    password: "password"
  }
}
```

```ruby
# Response
{
  "data": {
    "id": "1",
    "type": "users",
    "attributes": {
      "username": "johndoe",
      "email": "johndoe@email.com"
    },
    "relationships": {
      "records": {
          "data": []
      }
    }
  }
}
```

#### Authentication & Authorization

All endpoints, except the user registration and authentication enpoints, requires authentication/authorization token to access any resources.

When a user attempt to sign in, the server returns a token and that user's data if successful, or a `401` response with a message. The user/client **MUST** use this token returned by the server for subsequent requests, added to every request's headers as the value for the `Authorization` key, see example.

```ruby
# Request
POST /api/v1/auth

# Payload
{
  email: 'johndoe@email.com',
  password: 'password'
}
```

```ruby
# Response
{
  "auth_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0LCJleHAiOjE2MzE4MTI4NDR9.l19X2PRR2ZWJs4LJKc7WtprR8jGx7XQ9WCxtHcQ6iFw",
  "user": {
    "id": 4,
    "username": "johndoe",
    "email": "johndoe@email.com"
  }
}
```

For subsequent requests, add an `Authorization` header and set it's value to `auth_token` returned by the server for authentication and authorization by the server.

#### Activities

Only `2` endpoints has been exposed; to `GET` all objects, and a single object for the `Activity` resource.

##### All activities

```ruby
# Request
GET /api/v1/activities
  headers: { Authorization: Bearer <auth_token> }

# Response
{
  "data": [
    {
      "id": "1",
      "type": "activities",
      "attributes": {
        "name": "Sleep"
      },
      "relationships": {
        "records": {
          "data": [
            {
                "id": "1",
                "type": "records"
            },
            {
                "id": "5",
                "type": "records"
            }
          ]
        }
      }
    },
  ]
}
```

##### Single activity

```ruby
# Request
GET /api/v1/activities/<activity_id>
  headers: { Authorization: Bearer <auth_token> }

# Response
{
  "data": {
    "id": "1",
    "type": "activities",
    "attributes": {
      "name": "Sleep"
    },
    "relationships": {
      "records": {
        "data": [
          {
            "id": "1",
            "type": "records"
          },
          {
            "id": "5",
            "type": "records"
          }
        ]
      }
    }
  }
}
```

#### Records

All `CRUD` endpoints is exposed for the `Record` resource.

##### CREATE `Record`

```ruby
# Request
POST /api/v1/activities/<activity_id>/records 
  headers: { Authorization: Bearer <auth_token> }
  payload: {
    "record": {
      "duration: <float>, # 0.1 <= duration <= 1440
      "satisfaction": <integer>, # 0 <= satisfaction <= 10
      "date": "2021-09-04,
      "activity_id": <integer>
    }
  }

# Response
{
  "data": {
    "id": "3",
    "type": "records",
    "attributes": {
      "duration": 67.0,
      "satisfaction": 5,
      "date": "2021-09-04"
    },
    "relationships": {
      "user": {
        "data": {
          "id": "1",
          "type": "users"
        }
      },
      "activity": {
        "data": {
          "id": "1",
          "type": "activities"
        }
      }
    }
  }
}
```

##### DELETE `Record`

```ruby
# Request
DELETE /api/v1/activities/<activity_id>/records/<record_id>
  headers: { Authorization: Bearer <auth_token> }

# Response
Status => 204 # Successfully deleted
```

##### UPDATE `Record`

```ruby
# Request
PATCH /api/v1/activities/<activity_id>/records/<record_id>
  headers: { Authorization: Bearer <auth_token> }
  payload: {} # updated fields

# Response
# Returns the updated Record object
```

##### `GET` all `Record`s of a particular `Activity`

```ruby
# Request
GET /api/v1/activities/<activity_id>/records
  headers: { Authorization: Bearer <auth_token> }

# Response
{
  "data": [
    {
      "id": "1",
      "type": "records",
      "attributes": {
        "duration": 67.0,
        "satisfaction": 5,
        "date": "2021-09-16"
      },
      "relationships": {
        "user": {
          "data": {
            "id": "1",
            "type": "users"
          }
        },
        "activity": {
          "data": {
            "id": "1",
            "type": "activities"
          }
        }
      }
    }
  ]
}
```

##### `GET` a single `Record` of an activity

```ruby
# Request
GET /api/v1/activities/1/records/1
  headers: { Authorization: Bearer <auth_token> }

# Response
{
  "data": {
    "id": "1",
    "type": "records",
    "attributes": {
      "duration": 40.0,
      "satisfaction": 5,
      "date": "2021-09-16"
    },
    "relationships": {
      "user": {
        "data": {
          "id": "1",
          "type": "users"
        }
      },
      "activity": {
        "data": {
          "id": "1",
          "type": "activities"
        }
      }
    }
  }
}

```

## Test suites

This app has been tested using `RSpec`. To run the test suite, run this command:
`rspec` **OR** `bundle exec rspec`

  > To see test details, use --foramt flag

`rspec --format=documentation`

## Deployment instructions

For easy deployment, see [Getting Started on Heroku with Rails 6.x
](https://devcenter.heroku.com/articles/getting-started-with-rails6).

## Authors

**CY Kalu** 👤

- GitHub: [CY Kalu](https://github.com/cyonii)
- LinkedIn: [Silas Kalu](https://www.linkedin.com/in/cyonii)

## Contributing 🤝

Contributions, issues, and feature requests are welcome!

## Support

Give a ⭐️ if you like this project!
