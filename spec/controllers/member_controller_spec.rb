# frozen_string_literal: true

require 'rails_helper'

describe MembersController do
  before :each do
    @member = FactoryBot.create(:member)
    @posts = [FactoryBot.create(:post, author: @member)]
    @twitter_auth = FactoryBot.create(:authentication, member: @member)
    @flickr_auth = FactoryBot.create(:flickr_authentication, member: @member)
  end

  describe "GET index" do
    it "assigns only confirmed members as @members" do
      get :index, params: {}
      assigns(:members).should eq([@member])
    end
  end

  describe "GET JSON index" do
    it "provides JSON for members" do
      get :index, format: 'json'
      response.should be_success
    end
  end

  describe "GET show" do
    it "provides JSON for member profile" do
      get :show, params: { id: @member.id }, format: 'json'
      response.should be_success
    end

    it "assigns @posts with the member's posts" do
      get :show, params: { id: @member.id }
      assigns(:posts).should eq(@posts)
    end

    it "assigns @twitter_auth" do
      get :show, params: { id: @member.id }
      assigns(:twitter_auth).should eq(@twitter_auth)
    end

    it "assigns @flickr_auth" do
      get :show, params: { id: @member.id }
      assigns(:flickr_auth).should eq(@flickr_auth)
    end

    it "doesn't show completely nonsense members" do
      get :show, params: { id: 9999 }
      expect(response).to have_http_status(:not_found)
    end

    it "doesn't show unconfirmed members" do
      @member2 = FactoryBot.create(:unconfirmed_member)
      get :show, params: { id: @member2.id }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET member's RSS feed" do
    it "returns an RSS feed" do
      get :show, params: { id: @member.to_param }, format: "rss"
      response.should be_success
      response.should render_template("members/show")
      response.content_type.should eq("application/rss+xml")
    end
  end
end
