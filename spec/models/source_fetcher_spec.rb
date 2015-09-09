require "spec_helper"

describe SourceFetcher do 
  subject(:source_fetcher){SourceFetcher.new}
  describe "format_kewords" do 
    it "removes accents" do 
      formated_keyword = source_fetcher.format_keyword("áaabécânlë")
      expect(formated_keyword).to match("aaabecanle")
    end

    it "separates numbers from letters" do
      formated_keyword = source_fetcher.format_keyword("ad213 5de4 s99 eerere")
      expect(formated_keyword).to match("ad 213 5 de 4 s 99 eerere")
    end

    it "removes extra whitespaces" do 
      formated_keyword = source_fetcher.format_keyword("    knlad adnla    dnka a  n  ")
      expect(formated_keyword).to match("knlad adnla dnka a n")
    end

  end
end