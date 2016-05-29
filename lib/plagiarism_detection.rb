class PlagiarismDetection

  PlagiarismDetectionResult = Struct.new(
    :document,
    :comparator_document,
    :document_length,
    :comparator_document_length,
    :kgram_value,
    :similiarity
  )

  def initialize(document:, comparator_document:, kgram_value:)
    @document = document
    @comparator_document = comparator_document
    @kgram_value = kgram_value
  end

  def analize!
    document_content = read(@document)
    comparator_document_content = read(@comparator_document)

    doc_contents = DocumentExtractor.extract(document_content)
    com_contents = DocumentExtractor.extract(comparator_document_content)

    same_pattern_value = 0
    doc_contents.each_with_index do |doc_string, index|
      doc_content_by_kgram = doc_contents.from(index)
                                         .to(@kgram_value-1)
                                         .join
      match_pattern = rabin_karp_set(
        string_pattern: doc_content_by_kgram,
        string_contents: com_contents,
        kgram: @kgram_value
      )
      same_pattern_value += 1 if match_pattern
    end

    similiarity = BigDecimal.new((@kgram_value * same_pattern_value)) / BigDecimal.new((doc_contents.size + com_contents.size))

    result = PlagiarismDetectionResult.new
    result.document = @document
    result.comparator_document = @comparator_document
    result.document_length = doc_contents.size
    result.comparator_document_length = com_contents.size
    result.kgram_value = @kgram_value
    result.similiarity = similiarity

    result
  end

  private

  def read(file)
    if file.respond_to?(:read)
      file.read
    elsif file.respond_to?(:path)
      File.read(file.path)
    else
      begin
        File.read(file)
      rescue
        raise "Bad file: #{file.class.name}: #{file.inspect}"
      end
    end
  end

  def rabin_karp_set(string_pattern:, string_contents:, kgram:)
    equal = false
    hsubs = []
    string_contents.each_with_index do |string_content, index|
      hsubs << string_contents.from(index)
                              .to(@kgram_value-1)
                              .join
    end

    hsubs.each do |aa|
      if aa == string_pattern
        equal = true
        break
      end
    end

    equal
  end

end