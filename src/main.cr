#!/usr/bin/env ruby
# frozen_string_literal: true

require "mechanize"
require "time"
require "colorize"

require "./cli"

FosdemRecorder::Cli.start(ARGV)
