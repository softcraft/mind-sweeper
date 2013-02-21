mind-sweeper
==============

Get ideas out of your head (the first step in GTD process)

# Description

This is a simple service that allows you to:

* Take an idea out of your head and save it
* Review you saved ideas (one by one)
* Sweep the idea when you are done

# Documentation

(Diagram here)

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
