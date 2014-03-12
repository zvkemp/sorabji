# Sorabji

This is an early-stage DSL for accepting user input in a Rails app. Goals are to provide a simple syntax for non-developer users to transform hashes or hash-like entities (like Mongoid documents), and sandboxing user scripts to protect the app and server.

## Installation

Add this line to your application's Gemfile:

    gem 'sorabji'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sorabji

## Usage

- Basic identifiers (hash keys)
  - strings are converted to symbols: `{external_id}` becomes `object[:external_id]`
  - integers are used as-is `{123}` becomes `object[123]`

- Reference identifiers (method symbols)
  - only strings permitted
  - sent as messages to a reference object: `{{year}}` becomes `object.reference_object.send(:year)`
  - TODO: implement messaging whitelist
  - TODO: define how reference objects are looked up

- Lists
  - square bracket delineated, space-separated values
  - eg `[123 456 {276} (1 + {{year}})]`

- Functions
  - `default`: returns the first present argument:
  - `default[{276} 101]` returns 101 unless `{276}` is defined.

## Todo

- how to handle integer division cleanly, without violating the expectations of non-developers (i.e. convert to float by default?)?


## Contributing

1. Fork it ( http://github.com/<my-github-username>/sorabji/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
