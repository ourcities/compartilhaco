require 'rails_helper'

RSpec.describe CampaignsController, :type => :controller do

  describe 'GET show' do
    let(:campaign){ Campaign.make! }
    before { get :show, id: campaign.id }

    it 'should be successful' do
      expect(response).to be_successful
    end

    it 'should assign @campaign_spreader' do
      expect(assigns(:campaign_spreader)).to be_instance_of(CampaignSpreader)
    end

    it 'should assign @campaign' do
      expect(assigns(:campaign)).to be_eql(campaign)
    end

    context 'when there are no spreaders' do
      it 'should assign empty to @last_spreaders' do
        expect(assigns(:last_spreaders)).to be_empty
      end
    end

    context 'when there are 5 spreaders' do
      before { 5.times { CampaignSpreader.make! :facebook_profile, campaign: campaign } }

      it 'should assign 5 items to @last_spreaders' do
        expect(assigns(:last_spreaders).count).to eq(5)
      end
    end
  end

  describe 'GET edit' do
    let(:campaign){ Campaign.make! }

    context "when I'm an admin" do
      before do
        allow(controller).to receive(:current_user).and_return(User.make! :admin)
        get :edit, id: campaign.id
      end

      it 'should be successful' do
        expect(response).to be_successful
      end

      it 'should assign @campaign' do
        expect(assigns(:campaign)).to be_eql(campaign)
      end
    end

    context "when I'm the campaign's owner" do
      before do
        allow(controller).to receive(:current_user).and_return(User.find campaign.user_id)
        get :edit, id: campaign.id
      end

      it 'should be successful' do
        expect(response).to be_successful
      end

      it 'should assign @campaign' do
        expect(assigns(:campaign)).to be_eql(campaign)
      end
    end
  end

  describe 'PATCH archive' do
    let(:campaign) { Campaign.make! }

    before do
      allow(controller).to receive(:current_user).and_return(User.make! :admin)
      patch :archive, id: campaign.id
    end

    it 'should redirect to @campaign' do
      expect(response).to redirect_to campaign
    end
  end

  describe 'GET serve_image' do
    before { @campaign = Campaign.make! }

    it 'should serve an image' do
      get :serve_image, id: @campaign.id, trash: 'blablabla'
      expect(response.header['Content-Type']).to eq 'image/jpeg'
    end
  end
end
