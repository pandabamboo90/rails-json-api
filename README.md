# rails-json-api

## Introduction
This project is collection of config / gems / tools for quickstart developing Rails API follow JSON API spec.
No test framework is included, you should add it by yourself, your choice ! :)

### Table of Contents

* [Installation](#installation)
* [System requirements](#system-requirements)
* [In-use gems](#in-use-gems)
* [Contribution](#contribution)
* [Semantic Versioning (SemVer)](#semantic-versioning)
* [License](#license)

------------------------------------------------------------------------

## System requirements

- rbenv `latest`
- ruby `>= 3.0.1`
- postgres `latest`
- docker `latest` (If you want to run with Docker)

------------------------------------------------------------------------

## Installation

### Without Docker
1. Clone the repo
   ```git
   git clone https://github.com/pandabamboo90/rails-json-api
   ```
2. Run setup to prepare database
   ```shell
   cd rails-json-api
   bin/setup
   ```
3. Start the server
   ```shell
   rails s
   ```

### Using Docker
1. Clone the repo
   ```git
   git clone https://github.com/pandabamboo90/rails-json-api
   ```
2. Open `entrypoint.sh` and change CONTAINER_TYPE value to "SETUP", this will help you setup DB/migrations/seed data and run the project 1st time
   ```shell
   # entrypoint.sh
   CONTAINER_TYPE=SETUP
   ```
3. Build the image and run container
   ```shell
   docker-compose build
   docker-compose up
   ```
4. At this point your project is ready and should be up & running. Open `entrypoint.sh` and change CONTAINER_TYPE value to "WEB" for later to speed up the boot time
   ```shell
   # entrypoint.sh
   CONTAINER_TYPE=WEB
   ```

------------------------------------------------------------------------
## In-use gems
### Authentication
Gem | Info
--- | ---- 
[devise](https://github.com/heartcombo/devise) | A flexible authentication solution for Rails based on Warden
[devise_token_auth](https://github.com/lynndylanhurley/devise_token_auth) | Simple, multi-client and secure token-based authentication for Rails.

### Authorization
Gem | Info
--- | ---- 
[rolify](https://github.com/RolifyCommunity/rolify) | Very simple Roles library without any authorization enforcement supporting scope on resource object
[action_policy](https://github.com/palkan/action_policy) | Authorization framework for Ruby and Rails applications. Composable, extensible and performant

### Uploading file
Gem | Info
--- | ---- 
[shrine](https://github.com/janko-m/shrine) | Toolkit for handling file uploads in Ruby.

### Soft-delete models
Gem | Info
--- | ---- 
[discard](https://github.com/jhawthorn/discard) | A simple ActiveRecord mixin to add conventions for flagging records as discarded.

### JSON API serializer / deserializer
Gem | Info
--- | ----
[oj](https://github.com/ohler55/oj) | A fast JSON parser and Object marshaller as a Ruby gem.
[jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer) | A fast JSON:API serializer for Ruby Objects.
[jsonapi.rb](https://github.com/stas/jsonapi.rb) | transform a JSONAPI document into a flat dictionary that can be used to update an ActiveRecord::Base model.

### Log
Gem | Info
--- | ---- 
[rails_semantic_logger](https://logger.rocketjob.io/) | Scalable, next generation enterprise logging for Ruby.

### Active Record Validations
Gem | Info
--- | ----
[validates_overlap](https://github.com/pandabamboo90/validates_overlap) | Ideal solution for booking applications where you want to make sure, that one place can be booked only once in specific time period.
[validates_timeliness](https://github.com/adzap/validates_timeliness) | Date and time validation plugin for ActiveModel and Rails.

### Mailer & test / sending mails in local env
Gem | Info
--- | ----
[letter_opener](https://github.com/ryanb/letter_opener) | Preview mail in the browser instead of sending.

------------------------------------------------------------------------

## Contribution

------------------------------------------------------------------------

## Semantic Versioning
Ransack attempts to follow semantic versioning in the format of `x.y.z`, where:

`x` stands for a major version (new features that are not backward-compatible).

`y` stands for a minor version (new features that are backward-compatible).

`z` stands for a patch (bug fixes).

In other words: `Major.Minor.Patch.`

------------------------------------------------------------------------

## License
Feel free to use this template for your next JSON-API project. Good luck, have fun !