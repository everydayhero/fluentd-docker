require "spec_helper"

require_relative "../plugins/parser_journalctl"

describe JournalCtl do
  def parse_line(json_text)
    JournalCtl.new.parse(json_text)
  end

  def parse_hash(json_text)
    timestamp, hash = parse_line(json_text)
    hash
  end

  def assert_keys_in_example(example, keys)
    expect(parse_hash(example)).to include keys
  end

  def nginx_example(index)
    example_lines = IO.read("spec/nginx.json").lines.to_a
    example_lines[index]
  end

  pending "test that we extract the timestamp"
  pending "test that we extract a full journald hash"

  it "should parse nginx - as json null" do
    assert_keys_in_example(
      nginx_example(0),
      "upstream_connect_time" => "-",
      "upstream_response_time" => "-",
    )
  end

  it "should parse nginx numbers as json numbers" do
    assert_keys_in_example(
      nginx_example(7),
      "upstream_connect_time" => "0.001",
      "upstream_response_time" => "0.003",
    )
  end
end
