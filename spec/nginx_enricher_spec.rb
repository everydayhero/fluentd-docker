require_relative "../plugins/nginx_enricher"

describe NginxEnricher do
  it "leaves unknown keys alone" do
    response = subject.call(
      "foo" => "-",
      "bar" => "0.001",
    )

    expect(response).to eq(
      "foo" => "-",
      "bar" => "0.001",
    )
  end

  it "should not transform wrong things" do
    response = subject.call(
      "upstream_connect_time" => "foo-bar"
    )

    expect(response).to eq(
      "upstream_connect_time" => "foo-bar"
    )
  end

  it "should not transform more wrong things" do
    response = subject.call(
      "upstream_connect_time" => "I am 1.74 metres tall"
    )

    expect(response).to eq(
      "upstream_connect_time" => "I am 1.74 metres tall"
    )
  end

  context "upstream_connect_time" do
    it "should transform a - into a nil" do
      response = subject.call(
        "upstream_connect_time" => "-"
      )

      expect(response).to eq(
        "upstream_connect_time" => nil
      )
    end

    it "should transform a number into a number" do
      response = subject.call(
        "upstream_connect_time" => "0.003"
      )

      expect(response).to eq(
        "upstream_connect_time" => 0.003
      )
    end
  end

  context "upstream_response_time" do
    it "should transform a - into a nil" do
      response = subject.call(
        "upstream_response_time" => "-"
      )

      expect(response).to eq(
        "upstream_response_time" => nil
      )
    end

    it "should transform a number into a number" do
      response = subject.call(
        "upstream_response_time" => "0.003"
      )

      expect(response).to eq(
        "upstream_response_time" => 0.003
      )
    end
  end
end
