module ChartsHelper
  def with_labels(results, mapping)
    results.reduce({}){|memo, (key, val)| memo[mapping[key.to_s]] = val; memo; }
  end
end