mind-sweeper
==============

![Travis-ci](https://api.travis-ci.org/solojavier/mind-sweeper.png)

Organize your ideas and take action

# Description

This is a simple service that allows you to:

* Create a new idea
* Review your ideas (one by one)
* Delete or mark as reviewed an idea

# Documentation

TODO: this need to be updated (login and signup in root)

![Diagram](http://i.imgur.com/cyWTuXA.png)

![Diagram](http://i.imgur.com/TqohrO0.png)

## Signup

Create a new user

### Request

* Method: POST
* Required properties: username, password

### Responses

#### Created

* Status: 201

#### Bad parameters

* Status: 422

## Collect

Save an idea

### Request

* Method: POST
* Required properties: description
* Optional properties: related_users

### Responses

#### Created

* Status: 201

#### Bad parameters

* Status: 422

## Decide

Review next idea, ordered by creation date and then reviewed date

### Request

* Method: GET

### Responses

#### OK

* Status: 200
* Embedded: next_idea

## Idea

Idea resource details

### Request

* Method: GET
* Required properties: id

### Responses

#### OK

* Status: 200
* Properties: id, description
* Links: delete, review

## Review

Mark an idea as reviewed

### Request

* Method: POST
* Required properties: id

### Responses

#### Updated

* Status: 204

#### Bad parameters

* Status: 422

## Delete

Kill an idea

### Request

* Method: DELETE
* Required properties: id

### Responses

#### Updated

* Status: 204

#### Bad parameters

* Status: 422
