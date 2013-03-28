mind-sweeper
==============

Organize your ideas and take action

# Description

This is a simple service that allows you to:

* Create a new idea
* Review your ideas (one by one)
* Sweep or mark as reviewed an idea

# Documentation

![Diagram](http://i.imgur.com/s0vFdBU.png)

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

## Review

Review saved ideas

### Request

* Method: GET

### Responses

#### OK

* Status: 200
* Embedded: ideas

## Idea

Idea resource details

### Request

* Method: GET
* Required properties: id

### Responses

#### OK

* Status: 200
* Properties: id, description
* Links: sweep

## Sweep

Mark an idea as reviewed

### Request

* Method: POST
* Required properties: id

### Responses

#### Updated

* Status: 204

#### Bad parameters

* Status: 422
