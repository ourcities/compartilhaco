require 'rails_helper'

RSpec.describe Campaign, :type => :model do
  it { should have_many :campaign_spreaders }
  it { should validate_presence_of :ends_at }
  it { should validate_presence_of :share_link }
  it { should validate_presence_of :goal }

  context "when the ends_at is in the past" do
    subject { Campaign.make ends_at: 1.hour.ago }
    it { should have(1).error_on(:ends_at) }
  end

  context "when the ends_at is in more than 50 days from now" do
    subject { Campaign.make ends_at: 51.days.from_now }
    it { should have(1).error_on(:ends_at) }
  end

  describe ".succeeded" do
    context "when there is at least one succeeded campaign" do
      before { CampaignSpreader.make!(:facebook_profile, campaign: Campaign.make!(goal: 1)) }

      it "should have one campaign" do
        expect(Campaign.succeeded).to have(1).campaign
      end
    end

    context "when there is no succeeded campaign" do
      before { Campaign.make! }

      it "should be empty" do
        expect(Campaign.succeeded).to be_empty
      end
    end
  end

  describe ".ended" do
    context "when there is at least one ended campaign" do
      before do
        Campaign.make! ends_at: 1.day.from_now
        allow(Time).to receive(:now).and_return(2.days.from_now)
      end

      it "should have one campaign" do
        expect(Campaign.ended).to have(1).campaign
      end
    end

    context "when there is no ended campaign" do
      before { Campaign.make! ends_at: Time.now + 1.day }

      it "should be empty" do
        expect(Campaign.ended).to be_empty
      end
    end
  end

  describe ".unshared" do
    context "when there is at least one unshared campaign" do
      before { Campaign.make! }

      it "should have one campaign" do
        expect(Campaign.unshared).to have(1).campaign
      end
    end

    context "when there is no unshared campaign" do
      before { Campaign.make! shared_at: Time.now }

      it "should be empty" do
        expect(Campaign.unshared).to be_empty
      end
    end
  end

  describe "#share" do
    subject { Campaign.make! }
    before { @campaign_spreader = CampaignSpreader.make!(:facebook_profile, campaign: subject) }

    it "should call campaign_spreader#share method" do
      expect{
        VCR.use_cassette('facebook profile share', match_requests_on: [:host, :path]) do
          subject.share
        end
      }.to change{@campaign_spreader.reload.uid}.from(nil).to("10152278257287843_10152330512207843")
    end

    it "should update shared_at" do
      time = Time.now
      allow(Time).to receive(:now).and_return(time)

      expect{
        subject.share
      }.to change{subject.shared_at}.from(nil).to(time)
    end
  end
end
