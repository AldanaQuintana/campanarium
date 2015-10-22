module ChartsHelper
  def pie_chart_with_labels(results, mapping, colors = nil, id = nil)
    pie_chart results.reduce({}){|memo, (key, val)| memo[mapping[key.to_s]] = val; memo; }, colors:  colors.present? ? results.keys.map{|k| colors[k]} : [], id: id
  end
end