
# FOSDEM Recorder

## Prerequisites

* Make sure you have Ruby installed
* Make sure you have the 'bundler' Gem installed

## Installation

Install project dependencies

    $ bundle install

## Usage

Get information about given URL

    $ bundle exec fosdem-recorder info URL

Schedule video download for given URL

    $ bundle exec fosdem-recorder download URL

Real example

```shell-session
$ bundle exec fosdem-recorder info https://fosdem.org/2021/schedule/event/sca_weclome/
* title = FOSDEM 2021 - Software Composition Analysis Devroom Welcome
* start = 14:00
* stop = 14:05
* diff = 00:05:00
* url = https://stream.fosdem.org/dcomposition.m3u8

$ bundle exec fosdem-recorder info https://fosdem.org/2021/schedule/event/sca_weclome/
[... schedules the download ... ]
[... a MP4 file will be created once the video is downloaded ...]
```

# Fosdem

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/fosdem`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fosdem'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fosdem

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/glenux/fosdem.
