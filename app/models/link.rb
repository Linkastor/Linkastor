class Link < ActiveRecord::Base
  belongs_to :group
  belongs_to :custom_source
  belongs_to :user, :foreign_key => "posted_by"
  
  scope :not_posted, -> { where(posted: false) }
  
  validates :url, :title, presence: true
  validates :posted_by, presence:true, if: 'group_id.present?'
  validates :url, uniqueness: { scope: :group_id }, if: 'group_id.present?'
  validates :url, uniqueness: { scope: :custom_source_id }, if: 'custom_source_id.present?'

  self.per_page = 10

  def fetch_meta
    page = Mechanize.new.get(self.url).try(:parser)
    return if page.nil?

    if self.description.nil?
      og_descriptions = page.xpath('//meta[@property="og:description"]')
      if og_descriptions.length > 0
        self.description = og_descriptions[0][:content]  
      end
    end

    if self.image_url.nil?
      og_images = page.xpath('//meta[@property="og:image"]')
      if og_images.length > 0
        self.image_url = og_images[0][:content]
      end
    end
  end

  def fetch_pocket_meta
    return if ENV["POCKET_CONSUMER_KEY"].nil? || ENV["POCKET_ACCESS_TOKEN"].nil?

    pocket = ThirdParties::Pocket::Client.new(user: nil).add_link(title: nil, url: self.url, access_token: ENV["POCKET_ACCESS_TOKEN"])
    pocket_item = pocket['item']

    return if pocket_item.nil?

    if self.wordcount == 0
      self.wordcount = pocket_item['word_count'].to_i
    end

    if self.description.nil?
      self.description = pocket_item['excerpt']
    end

    if self.image_url.nil?
      first_image = pocket_item['images'][0]

      if first_image
        self.image_url = first_image['src']
      end
    end
  end

  def readingDuration
    return nil if self.wordcount == 0

    duration = self.wordcount/200 #assuming you read 200 words in a minute

    
    return "about a minute" if duration <= 1
    return "2 minutes or less" if duration <= 2
    return "5 minutes or less" if duration <= 5
    return "10 minutes or less" if duration <= 10
    return "15 minutes or less" if duration <=15
    return "30 minutes or less" if duration <= 30
    return "30+ minutes"
  end
end