# OTS

ots is an interface to libots - The open text summarizer

## Installation
 
```bash 
  gem install ots
```

## Dependencies

  * ruby >= 1.9.1
  * ruby development libraries    (debian: ruby1.9.1-dev)
  * libxml2 development libraries (debian: libxml2-dev)
  * libots development libraries  (debian: libots-dev)
  * glib2.0 development libraries (debian: libglib2.0-dev)

## Usage

```ruby
  require "ots"
  article = OTS.parse("I think I need some ice cream to cool me off. It is too hot down under")

  article.keywords            #=> [ "hot", "cool", "cream", "ice", "think" ]
  article.summarize(lines: 1) #=> [ { :sentence => "I think I need some ice cream to cool me off", :score => 57 } ]
```
