require 'rails_helper'

feature "View shared campaigns", :type => :feature do
  context "when there is no shared campaigns" do
    it "should not show the shared campaigns list" do
      visit root_path
      expect(page).to_not have_css("#shared-campaigns-list")
    end
  end

  context "when there are at least 6 shared campaigns" do
    before { 6.times { Campaign.make! shared_at: Time.now } }

    it "should show the shared campaigns list" do
      visit root_path
      expect(page).to have_css("#shared-campaigns-list")
    end

    it "should show all the 6 shared campaigns" do
      visit root_path
      expect(page).to have_css("#shared-campaigns-list .campaign", count: 6)
    end

    context "when one of these campaigns is archived" do
      let(:campaign) { Campaign.first }
      before { campaign.archive }

      it "should not show the archived campaign" do
        visit root_path
        expect(page).to_not have_css("#campaign-#{campaign.id}")
      end
    end

    context "when one of these campaigns is ended" do
      let(:campaign) { Campaign.first }
      before{ campaign.update_column :ends_at, 1.day.ago }

      it "should show the ended campaign" do
        visit root_path
        expect(page).to have_css("#campaign-#{campaign.id}")
      end
    end
  end

  context "when there are more than 6 shared campaigns" do
    before { 8.times { Campaign.make! shared_at: Time.now } }

    it "should show only 6 campaigns" do
      visit root_path
      expect(page).to have_css("#shared-campaigns-list .campaign", count: 6)
    end
  end
end
