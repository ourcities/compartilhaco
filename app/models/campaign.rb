class Campaign < ActiveRecord::Base
  has_many :campaign_spreaders
  has_many :spam_reports
  has_many :facebook_profiles, through: :campaign_spreaders, source: :timeline, source_type: "FacebookProfile"
  has_many :twitter_profiles, through: :campaign_spreaders, source: :timeline, source_type: "TwitterProfile"
  belongs_to :organization
  belongs_to :user
  belongs_to :category
  belongs_to :mobilization, primary_key: :hashtag, foreign_key: :hashtag
  mount_uploader :image, ImageUploader

  validates :ends_at, :share_link, :goal, :organization_id, :user_id, :category_id, :image, :title, :description, :tweet, :new_campaign_spreader_mail, presence: true
  validate :ends_at_cannot_be_in_the_past
  validate :ends_at_cannot_be_in_more_than_50_days

  after_create { CampaignWorker.perform_async(self.id) }

  scope :unshared,   -> { where("shared_at IS NULL") }
  scope :unarchived, -> { where("archived_at IS NULL") }
  scope :upcoming,   -> { where("? < ends_at", Time.now) }
  scope :ended,      -> { where("? >= ends_at", Time.now) }
  scope :succeeded,  -> { where("(
    SELECT count(*)
    FROM campaign_spreaders
    WHERE campaign_spreaders.campaign_id = campaigns.id) >= campaigns.goal")}

  def share
    campaign_spreaders.each {|cs| cs.share}
    update_attribute :shared_at, Time.now
  end

  def archive
    update_attribute :archived_at, Time.now
  end

  def ends_at_cannot_be_in_the_past
    errors.add(:ends_at, I18n.t("errors.messages.cannot_be_in_the_past")) if
      ends_at.nil? || ends_at < Time.now
  end

  def ends_at_cannot_be_in_more_than_50_days
    errors.add(:ends_at, I18n.t("errors.messages.cannot_be_in_more_than", 50.days)) if
      ends_at.nil? || ends_at > 50.days.from_now
  end

  def check_expired_tokens
    facebook_profiles.each { |fp| fp.check_expired_token }
  end

  def progress_of_goal
    campaign_spreaders.count.to_f/goal.to_f * 100
  end

  def progress_of_time
    (Time.now - created_at)/(ends_at - created_at) * 100
  end

  def reach
    facebook_profiles.sum(:friends_count) +
      facebook_profiles.sum(:subscribers_count) +
      twitter_profiles.sum(:followers_count)
  end

  def archived?
    !self.archived_at.nil?
  end

  def succeeded?
    campaign_spreaders.count >= goal && ended?
  end

  def unsucceeded?
    campaign_spreaders.count < goal && ended?
  end

  def ended?
    ends_at < Time.now
  end
end
