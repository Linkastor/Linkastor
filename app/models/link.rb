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

    page = Nokogiri::HTML(open(self.url))

    if self.description == nil
      self.description = page.xpath('//meta[@property="og:description"]')[0][:content]
    end

    if self.image_url == nil
      self.image_url = page.xpath('//meta[@property="og:image"]')[0][:content]
    end
  end
end