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

    if self.description == nil
      og_descriptions = page.xpath('//meta[@property="og:description"]')
      if og_descriptions.length > 0
        self.description = og_descriptions[0][:content]  
      end
    end

    if self.image_url == nil
      og_images = page.xpath('//meta[@property="og:image"]')
      if og_images.length > 0
        self.image_url = og_images[0][:content]
      end
    end
  end
end