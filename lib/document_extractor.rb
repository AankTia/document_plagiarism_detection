class DocumentExtractor

  STOP_WORDS = File.read("#{Rails.root}/lib/stop_word.txt").split
  TEXT_DELIMITERS = File.read("#{Rails.root}/lib/text_delimiter.txt").split

  def self.extract(text_content)
    result = case_folding(text_content)
    result = tokenizing(result)
    result = filtering(result)
    result = stemming(result)

    result.join.split(//)
  end

  private

  def self.case_folding(text_content)
    text_content.downcase
  end

  def self.tokenizing(text_content)
    text_content.split
  end

  def self.filtering(text_contents)
    results = []
    text_contents.each do |text|
      if !STOP_WORDS.include?(text)
        if !TEXT_DELIMITERS.include?(text)
          TEXT_DELIMITERS.each do |delimiter|
            text = text.gsub(delimiter, '') if text.include?(delimiter)
          end
          results << text
        end
      end
    end

    results
  end

  def self.stemming(text_contents)
    results = []
    text_contents.each do |text|
      results << IndonesianStemmer.stem(text)
    end
    results
  end

end