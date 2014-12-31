# UnchangedValidator

[![Build Status](https://travis-ci.org/petedmarsh/unchanged_validator.png)](https://travis-ci.org/petedmarsh/unchanged_validator)

A validator for ActiveModels that checks that attributes have not been
modified since the last time the model was saved.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unchanged_validator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unchanged_validator

## Running the tests

Install various dependencies:

    $ appraisal install
    
Then, to run the tests:

    $ appraisal rspec

## Usage

### Example

```ruby
class Person < ActiveRecord::Base
  validates_unchanged :first_name
end

p = Person.new
p.first_name = 'Bob'
p.save
#=> true
p.valid?
#=> true

p.first_name = 'Dave'
p.save
#=> false
p.valid?
#=> false
```

### I18n

To change the default message for all usages of `validates_unchanged`:

```yaml
# In config/locales/en.yml
en:
  activerecord:
    errors:
      messages:
        changed: 'cannot be different'
```

To change the message for a particular attribute of a particular model:

```yaml
# In config/locales/en.yml
en:
  activerecord:
    models:
      person:
        attributes:
          first_name:
            changed: 'cannot be different'
```

### Options

UnchangedValidator supports all of the common `ActiveModel::Validations` options:

```ruby
class Book < ActiveRecord::Base
  validates_unchanged :title, allow_blank: true
  validates_unchanged :author, allow_nil: true
  validates_unchanged :copyright_expirty_date, if: same_edition?
  validates_unchanged :published_date, message: 'cannot be re-released'
  validates_unchanged :foreward, on: :update
  validates_unchanged :publisher, unless: :rebranded?
end
```
## Supported Rails Versions

* 3.1
* 3.2
* 4.0
* 4.1
* 4.2
