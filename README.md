
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

