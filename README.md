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

![Diagram](http://i.imgur.com/u4qYLoM.png)

## Signup

Create a new user

### Request

* Method: POST
* Required properties: username, password

## Login

Log a user into the app

### Request

* Method: POST
* Required properties: username, password

## User

User details

### Request

* Method: GET
* Required properties: id

## Collect

Save an idea

### Request

* Method: POST
* Required properties: description

## Idea

Idea details

### Request

* Method: GET
* Required properties: id

## Review

Mark an idea as reviewed

### Request

* Method: POST
* Required properties: id

## Delete

Kill an idea

### Request

* Method: DELETE
* Required properties: id
