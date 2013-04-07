mind-sweeper
==============

![Travis-ci](https://api.travis-ci.org/solojavier/mind-sweeper.png)
![Code Climate](https://codeclimate.com/github/solojavier/mind-sweeper.png)

Organize your ideas and take action

# Description

This is a simple service that allows you to:

* Create a new idea
* Review your ideas (one by one)
* Delete or mark as reviewed an idea

# Documentation

![Diagram](http://i.imgur.com/cyWTuXA.png)

![Diagram](http://i.imgur.com/wOv09pp.png)

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

## Login

Log a user into the app

### Request

* Method: POST
* Required properties: username, password

### Responses

#### Created

* Status: 200
* Body:   user

#### Bad parameters

* Status: 422

## User

User details

### Request

* Method: GET
* Required properties: id

### Responses

#### OK

* Status: 200
* Embedded: next_idea
* Links: collect

## Collect

Save an idea

### Request

* Method: POST
* Required properties: description

### Responses

#### Created

* Status: 201

#### Bad parameters

* Status: 422

## Idea

Idea details

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
