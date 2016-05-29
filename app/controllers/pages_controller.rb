class PagesController < ApplicationController

  def home
  end

  def get_similiarity
    plagiarism_detection = PlagiarismDetection.new(
      document: params['document'],
      comparator_document: params['comparator_document'],
      kgram_value: params['kgram_value'].to_i
    )
    plagiarism_result = plagiarism_detection.analize!

    redirect_to action: "plagiarism_result", plagiarism_result: plagiarism_result
  end

  def plagiarism_result
    @plagiarism_result = params[:plagiarism_result]
  end

end
