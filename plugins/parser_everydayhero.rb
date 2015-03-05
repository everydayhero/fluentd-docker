require "json"

Fluent::TextParser.register_template("everydayhero", -> { Everydayhero.new })

class JSONFlattener
  def self.call(json)
    flatten(json)
  end

  def self.flatten(json, prefix = "")
    json.keys.each do |key|
      if prefix.empty?
        full_path = key
      else
        full_path = [prefix, key].join('.')
      end

      if json[key].is_a?(Hash)
        value = json[key]
        json.delete key
        json.merge!(flatten(value, full_path))
      else
        value = json[key]
        json.delete key
        json[full_path] = value
      end
    end

    json
  end
end

class Everydayhero < Fluent::Parser
  REGEXP = /^(?<time>.*) (?<app_name>[a-zA-Z]+)\[(?<process_type>.*)\.(?<container_id>.*)\]: (?<payload>.*)$/

  config_param :time_format, :string, default: "%b %d %H:%M:%S"
  config_param :flatten, :string, default: "payload"

  def initialize(*)
    super

    @mutex = Mutex.new
    @time_parser = Fluent::TextParser::TimeParser.new(@time_format)
  end

  def configure(conf)
    super
    @time_parser = Fluent::TextParser::TimeParser.new(@time_format)
  end

  def parse(text)
    match = REGEXP.match(text)
    record = {}
    time = nil

    match.names.each do |name|
      if value = match[name]
        case name
        when "time"
          time = @mutex.synchronize { @time_parser.parse(value) }
        when @flatten
          begin
            value = value.strip
            result = JSON.parse(value)
            payload = JSONFlattener.call(result)
            record.merge!(payload)
          # rescue JSON::ParserError
          #   record[name] = value
          end
        else
          record[name] = value
        end
      end
    end

    if block_given?
      yield time, record
    else # keep backward compatibility. will be removed at v1
      return time, record
    end
  end
end
