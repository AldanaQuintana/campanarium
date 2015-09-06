require 'support/corpus_helper'

namespace :fake_data do
  desc "Create data set"
  task :create_notices => :environment do
    sources = ["tn", "infobae", "diario_veloz", "la_nacion"]
    CorpusHelper.CORPUSES.each do |co|
      title, body = co.split(".", 2)
      Notice.create(title: title, body: body, source: sources.sample)
    end
  end
end
