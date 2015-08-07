class NginxEnricher
  def call(output)
    output = output.dup

    output.each do |key, value|
      if keys_to_transform.include?(key)
        output[key] = transform (value)
      end
    end

    output
  end

  private

  def keys_to_transform
    %w(upstream_response_time upstream_connect_time)
  end

  def transform (value)
    case value
    when /^-$/
      nil
    when /^\d+\.\d+$/
      value.to_f
    else
      value
    end
  end
end
