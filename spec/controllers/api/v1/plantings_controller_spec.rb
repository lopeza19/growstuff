# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PlantingsController, type: :controller do
  subject { JSON.parse response.body }

  let(:headers) do
    {
      'Accept'       => 'application/vnd.api+json',
      'Content-Type' => 'application/vnd.api+json'
    }
  end
  let!(:member) { FactoryBot.create :member }

  describe '#index' do
    let(:matching_planting) { subject['data'].select { |planting| planting['id'] == my_planting.id.to_s }.first }

    describe 'GET #index' do
      context 'basic planting' do
        let!(:my_planting) { FactoryBot.create(:planting, owner: member, planted_at: '2000-01-01') }
        let(:expected_attributes) do
          {
            'crop-name'           => my_planting.crop.name,
            'description'         => my_planting.description,
            'expected-lifespan'   => nil,
            'finish-predicted-at' => nil,
            'finished'            => my_planting.finished,
            'finished-at'         => my_planting.finished_at,
            'first-harvest-date'  => nil,
            'last-harvest-date'   => nil,
            'percentage-grown'    => nil,
            'planted-at'          => '2000-01-01',
            'planted-from'        => my_planting.planted_from,
            'quantity'            => my_planting.quantity,
            'slug'                => my_planting.slug,
            'sunniness'           => nil,
            'thumbnail'           => nil
          }
        end

        before { get :index, format: :json }

        it { expect(matching_planting).to include('id' => my_planting.id.to_s) }
        it { expect(matching_planting['attributes']).to eq expected_attributes }
        it { expect(response.status).to eq 200 }
      end

      context 'with photo' do
        let!(:my_planting) { FactoryBot.create(:planting, owner: member, planted_at: '2000-01-01') }

        let(:expected_attributes) do
          {
            'crop-name'           => my_planting.crop.name,
            'description'         => my_planting.description,
            'expected-lifespan'   => nil,
            'finish-predicted-at' => nil,
            'finished'            => my_planting.finished,
            'finished-at'         => my_planting.finished_at,
            'first-harvest-date'  => nil,
            'last-harvest-date'   => nil,
            'percentage-grown'    => nil,
            'planted-at'          => '2000-01-01',
            'planted-from'        => my_planting.planted_from,
            'quantity'            => my_planting.quantity,
            'slug'                => my_planting.slug,
            'sunniness'           => nil,
            'thumbnail'           => photo.thumbnail_url
          }
        end
        let(:photo) { FactoryBot.create(:photo, owner: my_planting.owner) }

        before do
          my_planting.photos << photo
          get :index, format: :json
        end

        it { expect(matching_planting).to include('id' => my_planting.id.to_s) }
        it { expect(matching_planting['attributes']).to eq expected_attributes }
        it { expect(response.status).to eq 200 }
      end
    end
  end
end
