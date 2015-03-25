require "json"

Fluent::TextParser.register_template("journalctl", -> { JournalCtl.new })

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

class JournalCtl < Fluent::Parser
  def parse(text)
    output = {}
    json = JSON.parse(text)
    time = nil

    json.each do |key, value|
      output_key = key.gsub(/^_+/,'').gsub(/^/,'journalctl.').downcase
      output[output_key] = value

      begin
        nested_hash = JSON.parse(value)
        flat_hash = JSONFlattener.flatten(nested_hash)
        output.merge!(flat_hash)
      rescue JSON::ParserError
      end

      output
    end

    if block_given?
      yield time, output
    else # keep backward compatibility. will be removed at v1
      return time, output
    end
  end
end
