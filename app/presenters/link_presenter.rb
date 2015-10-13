class LinkPresenter
  def safe_link_title(link)
    ActionController::Base.helpers.strip_tags(link.title)
  end

  def safe_link_description(link)
    ActionController::Base.helpers.strip_tags(link.description).try(:truncate, 335).try(:html_safe)
  end

  def reading_duration(link)
    return "unknown" unless link.wordcount

    duration = link.wordcount/200 #assuming you read 200 words in a minute

    if duration <= 1
      "about a minute"
    elsif duration > 30
      "30+ minutes"
    else
      rounded_duration = [1, 2, 5, 10, 15, 30].select {|x| x > duration }.first
      "#{rounded_duration} minutes or less"
    end
  end
end