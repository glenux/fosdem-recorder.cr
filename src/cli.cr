
require "option_parser"

# Cli part of FosdemRecorder
module FosdemRecorder
  # Fosdem Cli - Download and cut streams video
  class Cli
    enum Actions
      Info
      None
    end

    property action : Actions = Actions::None

    def initialize(args)
      if args
        parse args
      end
    end

    def self.start(args)
      Cli.new(args)
    end

    private def info(url)
      _validate_url(url)
      meta = _get_meta(url)
      puts meta[:title].colorize.fore(:green)
      puts "* event start  = #{meta[:event_start]}"
      puts "* event stop   = #{meta[:event_stop]}"
      puts "* event length = #{meta[:duration_str]}"
      puts "* stream url   = #{meta[:stream_url]}"
    end

    private def download(url)
      _validate_url(url)
      meta = _get_meta(url)

      localtime = meta[:event_start].to_local
      timeformat = localtime.to_s("%H:%M %Y-%m-%d")
      cmd = "echo ffmpeg -i #{meta[:stream_url]} -c copy -t #{meta[:duration_str]} \"#{meta[:title_sane]}.mp4\" | at #{timeformat}"
      puts "Command: #{cmd}".colorize.fore(:yellow)
      system cmd
    end

    private def parse(args)
      commands = [] of Proc(String, Nil)

      OptionParser.parse(args) do |opts|
        opts.banner = "Usage: fosdem-recorder [subcommand] [arguments]"

        opts.on("info", "Get information about URL") do
          commands << ->info(String)
        end

        opts.on("download", "Download conference described at URL") do
          commands << ->download(String)
        end

        opts.on("-h", "--help", "Shows this help") do
          puts opts
          exit 0
        end
      end

      commands.each do |proc|
        targs = Tuple(String).from(args)
        proc.call(*targs)
      end
    end

    private def _validate_url(url)
      return if url =~ %r{^https://fosdem.org/\d+/schedule/event/.*}

      if url =~ %r{^https://fosdem.org/.*}
        STDERR.puts "ERROR: not a schedule page. URL must contain .../schedule/event/..."
        exit 1
      end

      STDERR.puts "ERROR: not a fosdem stream. URL must start with https://fosdem.org/..."
      exit 1
    end

    private def _get_meta(url)
      puts "Loading data from #{url}".colorize.fore(:yellow)
      mechanize = Mechanize.new

      begin
        page = mechanize.get(url)
      rescue ex : Socket::Addrinfo::Error
        STDERR.puts "ERROR: #{ex.message}"
        exit 1
      end

      # body_class = page.at('body').attr('class')
      # if body_class != 'schedule-event'
      #   STDERR.puts "ERROR: Not an event schedule page!"
      #   exit 1
      # end
      # puts body_class

      title = page.title
      title_sane =
        title
        .gsub(/[^a-zA-Z0-9]/, "-")
        .gsub(/--*/, "-")
        .gsub(/-$/, "")
        .gsub(/^-/, "")

      play_start_str =
        page
        .css(".side-box .icon-play").first.parent
        .try &.css(".value-title").first["title"].strip
      play_start_str = "" if play_start_str.nil?

      puts "PLAY_START = #{play_start_str}"
      location = Time::Location.load("Europe/Brussels")
      # play_start = Time.parse(play_start_str, "%H:%S", location)
      play_start = Time.parse_rfc3339(play_start_str) #, location)

      play_stop_str =
        page
        .css(".side-box .icon-stop").first.parent
        .try &.css(".value-title").first["title"].strip
      play_stop_str = "" if play_stop_str.nil?

      # play_stop = Time.parse(play_stop_str, "%H:%S", location)
      play_stop = Time.parse_rfc3339(play_stop_str)

      duration = (play_stop - play_start).to_i / 3600
      duration_h = duration.to_i
      duration_m = ((duration - duration_h) * 60 + 1).to_i
      duration_str = sprintf("%02d:%02d:00", { duration_h, duration_m })

      stream_page =
        page
        .links
        .select { |link| link.href =~ /live.fosdem.org/ }
        .first
        .href

      stream_url =
        stream_page
        .gsub(%r{.*watch/}, "https://stream.fosdem.org/")
        .gsub(/$/, ".m3u8")

      {
        title: title,
        title_sane: title_sane,
        stream_url: stream_url,
        event_start: play_start,
        event_stop: play_stop,
        event_start_str: play_start_str,
        event_stop_str: play_stop_str,
        duration_str: duration_str
      }
    end
  end
end
