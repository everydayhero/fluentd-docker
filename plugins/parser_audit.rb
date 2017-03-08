require 'fluent/parser'
require 'fluent/env'
require 'fluent/time'

module Fluent
  class AuditParser < Parser
    Plugin.register_parser('audit', self)

    ParserError = ::Fluent::ParserError

    def parse(text)
      time, record = nil, nil
      meta, msg = text.split(/:\s+/, 2)
      if meta && msg
        record = parse_fields(meta)
        time = extract_time(record)
        record.update parse_fields(msg)
      end

      if block_given?
        yield time, record
      else
        return time, record
      end
    end

    private

    def parse_fields(text)
      Hash[seperate_fields(text).map(&method(:split_key_from_value))]
    end

    def seperate_fields(text)
      text.split(/\s(?=(?:[^"]|"[^"]*")*$)/)
    end

    def split_key_from_value(text)
      key, value = text.split('=', 2)
      raise ParserError, "Unknown field '#{text}'" if value.nil?
      [key, strip_quotes(value)]
    end

    def extract_time(record)
      msg = record.delete('msg')
      timestamp = msg.scan(/(?:audit\()(\d+\.\d+)/).flatten.first
      raise ParserError, "Invalid timestamp '#{msg}'" if timestamp.nil?
      Time.strptime(timestamp, '%s')
    end

    def strip_quotes(text)
      text.gsub(/^[\"\']|[\"\']$/, '')
    end
  end
end
