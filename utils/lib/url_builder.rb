#!/usr/bin/env ruby

require 'uri'
require 'cgi'
require 'commander/import'
require './version'

module MixPanelSB
  class URLBuilder

    def build
      program :help_formatter, :compact
      program :name, 'Dolly'
      program :version, VERSION
      program :description, 'Clone and genetically modify premium apps.'

      command :funnel do |c|
        c.syntax = 'mixpanel funnel'
        c.description = 'Build StatusBoard URL for Funnel'
        c.action do |args, options|
          puts "Enter URL (no http): "
          url = $stdin.gets.chomp.strip

          puts "Enter API key: "
          apikey = $stdin.gets.chomp.strip

          puts "Enter API secret: "
          apisecret = $stdin.gets.chomp.strip

          puts "Enter MixPanel Funnel ID: "
          funnel_id = $stdin.gets.chomp.strip

          puts "Enter StatusBoard Title: "
          title = $stdin.gets.chomp.strip
        end
      end

      command :event do |c|
        c.syntax = 'mixpanel event'
        c.description = 'Build StatusBoard URL for Event'
        c.action do |args, options|
          puts "Enter URL (no http): "
          url = $stdin.gets.chomp.strip

          puts "Enter API key: "
          apikey = $stdin.gets.chomp.strip

          puts "Enter API secret: "
          apisecret = $stdin.gets.chomp.strip

          puts "Enter Mixpanel Event: "
          event = $stdin.gets.chomp.strip

          puts "Enter Mixpanel Event Property: "
          prop = $stdin.gets.chomp.strip

          puts "Enter StatusBoard Title: "
          title = $stdin.gets.chomp.strip

          mp_limit = '50'
          puts "Enter Limit [default=50]: "
          limit = $stdin.gets.chomp.strip

          mp_type = 'general'
          puts "Enter Type [default=general]: "
          type = $stdin.gets.chomp.strip

          mp_provider = 'MPStatus'
          puts "Enter Provider [default=MPStatus]: "
          provider = $stdin.gets.chomp.strip

          if limit != ""
            mp_limit = limit
          end

          if type != ""
            mp_type = type
          end

          if provider != ""
            mp_provider = provider
          end

          url_string = URI.escape("http://#{url}/mixpanel?api_key=#{apikey}&api_secret=#{apisecret}&on=#{prop}&title=#{title}&event=#{event}&type=#{mp_type}&limit=#{mp_limit}")

          puts "LOCAL:\ncurl \"#{url_string}\"\n\n"

          url_string = CGI.escape(url_string)
          puts "APP:\npanicboard://?url=#{url_string}&panel=table&sourceDisplayName=#{mp_provider}\n\n"
        end
      end
    end

  end
end