# OTS

ots is an interface to libots - The [open text summarizer](http://libots.sourceforge.net/).

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

 # optional: macosx normally has libxml2 installed if not try
 brew install libxml2

 # install glib
 brew install glib

 # install ots
 gem install ots

```

## API

```
  OTS
    .parse        #=> OTS::Article
    .languages    #=> Array

  OTS::Article
    .new
    #topics       #=> Array
    #keywords     #=> Array
    #summarize    #=> Array

```

## Usage

```ruby
  require 'ots'
  article = OTS.parse("I think I need some ice cream to cool me off. It is too hot down under")
  article = OTS.parse("j'ai besoin de la crème glacée. il fait trop chaud en australie.", language: "fr")
  article = OTS.parse("j'ai besoin de la crème glacée. il fait trop chaud en australie.", dictionary: "custom.xml")

  article.topics
  article.keywords
  article.summarize(percent: 50)
  article.summarize(sentences: 1)

  OTS.languages #=> list of supported languages dictionaries baked-in to libots
```

## See Also

[https://github.com/ssoper/summarize](https://github.com/ssoper/summarize)

## License

[Creative Commons Attribution - CC BY](http://creativecommons.org/licenses/by/3.0)
