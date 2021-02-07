
# FOSDEM Recorder

## Prerequisites

* Make sure you have a recent Ruby version installed
* Make sure you have the 'bundler' Gem installed


## Installation

Install project dependencies

    $ bundle install


## Usage

Get information about given URL

    $ fosdem_recorder info URL


Schedule video download for given URL

    $ fosdem_recorder download URL


Real example

```shell-session
$ bundle exec fosdem-recorder info https://fosdem.org/2021/schedule/event/sca_weclome/
* title = FOSDEM 2021 - Software Composition Analysis Devroom Welcome
* start = 14:00
* stop = 14:05
* diff = 00:05:00
* url = https://stream.fosdem.org/dcomposition.m3u8

$ bundle exec fosdem-recorder info https://fosdem.org/2021/schedule/event/sca_weclome/
[... schedules the download with 'at'... ]
[... downloads the file with 'ffmpeg'... ]
[... a MP4 file will be created once the video is downloaded ...]
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/glenux/fosdem-recorder.

