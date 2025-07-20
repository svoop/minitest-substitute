## Main

### Changes
* Update Ruby to 3.4
* Add action for trusted release

## 1.0.0

### Breaking Changes
* Switch from `with` to `substitute` because Rails 7 pollutes `Object` for
  everybody by introducing `Object#with`. 💣

## 0.3.0

### Additions
* Substition of constants

## 0.2.1

### Changes
* Defer evaluation of the substitution value block for specs

## 0.2.0

### Additions
* Refactor to support class variables as well
* Use declared subject as default target for with helper

## 0.1.0

### Initial Implementation
* Require Ruby 3.0
* Substitution of instance variables
* Substitution of global variables
* Helper for Minitest spec notation
