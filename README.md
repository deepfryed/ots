# OTS

ots is an interface to libots - The open text summarizer

## Dependencies

  * ruby 1.9.1 or later
  * libxml2
  * glib2.0 
  * homebrew (on MacOSX)

## Installation

### Debian flavors of Linux
 
```

  # ruby & ruby development libraries (not needed if you use rvm)
  sudo apt-get install ruby1.9.1-dev ruby1.9.1

  # libxml2 and glib development libraries
  sudo apt-get install libxml2-dev libglib2.0-dev

  # install ots
  gem install ots

```

### MacOSX


```

 # update homebrew to latest & greatest version
 GIT_SSL_NO_VERIFY=1 brew update

 # install glib
 brew install glib

 # install ots
 gem install ots

```

## API

```
  OTS
    .parse #=> OTS::Article

  OTS::Article
    .new
    #summarize
    #keywords
    #title

```

## Usage

```ruby
  require 'ots'
  article = OTS.parse("I think I need some ice cream to cool me off. It is too hot down under")

  article.keywords
  article.summarize(lines: 1)
  article.summarize(percent: 50)

  article = OTS.parse("j'ai besoin de la crème glacée. il fait trop chaud en australie.", "fr")
  article.keywords
  article.summarize(lines: 1)
  article.summarize(percent: 50)
```

## License

[Creative Commons Attribution - CC BY](http://creativecommons.org/licenses/by/3.0)
