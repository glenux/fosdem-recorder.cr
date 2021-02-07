
module FosdemRecorder
  # Fosdem Cli - Download and cut streams video
  class Cli < Thor
    desc 'info URL', 'Get information about URL'
    def info(url)
      meta = _get_meta(url)
      puts meta[:title]
      puts "* start      = #{meta[:start_str]}"
      puts "* stop       = #{meta[:stop_str]}"
      puts "* length     = #{meta[:duration_str]}"
      puts "* stream url = #{meta[:stream_url]}"
    end

    desc 'download URL', 'Download conference described at URL'
    def download(url)
      meta = _get_meta(url)
      cmd = "echo ffmpeg -i #{meta[:stream_url]} -c copy -t #{meta[:duration_str]} \"#{meta[:title_sane]}.mp4\" | at #{meta[:start_str]}"
      puts "Command: #{cmd}".yellow
      system cmd
    end

    private

    def _validate_url(url)
      return if url =~ %r{^https://fosdem.org/\d+/schedule/event/.*}

      warn 'ERROR: not a fosdem stream. URL must start with https://fosdem.org/...'
      exit 1
    end

    def _get_meta(url)
      mechanize = Mechanize.new
      page = mechanize.get(url)

      title = page.title
      title_sane =
        title
        .gsub(/[^a-zA-Z0-9]/, '-')
        .gsub(/--*/, '-')
        .gsub(/-$/, '')
        .gsub(/^-/, '')

      play_start_str =
        page
        .at('.side-box .icon-play')
        .parent
        .at('.value-title')
        .text
        .strip

      play_start = Time.parse(play_start_str)

      play_stop_str =
        page
        .at('.side-box .icon-stop')
        .parent
        .at('.value-title')
        .text.strip

      play_stop = Time.parse(play_stop_str)

      duration = (play_stop - play_start) / 3600
      duration_h = duration.to_i
      duration_m = ((duration - duration_h) * 60).to_i
      duration_str = format('%<hours>02d:%<minutes>02d:00', hours: duration_h, minutes: duration_m)

      stream_page =
        page
        .links
        .select { |link| link.href =~ /live.fosdem.org/ }
        .first
        .href

      stream_url =
        stream_page
        .gsub(%r{.*watch/}, 'https://stream.fosdem.org/')
        .gsub(/$/, '.m3u8')

      {
        title: title,
        title_sane: title_sane,
        stream_url: stream_url,
        start_str: play_start_str,
        stop_str: play_stop_str,
        duration_str: duration_str
      }
    end
  end

end
