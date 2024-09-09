require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  describe 'POST #single' do
    let(:valid_attributes) do
      {
        transaction_id: SecureRandom.uuid,
        points: 100,
        user_id: SecureRandom.uuid
      }
    end

    let(:invalid_attributes) do
      {
        transaction_id: nil,
        points: nil,
        user_id: nil
      }
    end

    context 'with valid attributes' do
      before do
        allow_any_instance_of(Api::V1::TransactionsController).to receive(:fetch_transaction_data).and_return(valid_attributes)
      end

      it 'creates a new transaction' do
        expect {
          post :single, params: valid_attributes, as: :json
        }.to change(Transaction, :count).by(1)
      end

      it 'returns a success status' do
        post :single, params: valid_attributes, as: :json
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('status' => 'success', 'transaction_id' => valid_attributes[:transaction_id])
      end
    end

    context 'with invalid attributes' do
      before do
        allow_any_instance_of(Api::V1::TransactionsController).to receive(:fetch_transaction_data).and_return(invalid_attributes)
      end

      it 'does not create a new transaction' do
        expect {
          post :single, params: invalid_attributes, as: :json
        }.not_to change(Transaction, :count)
      end

      it 'returns an error status' do
        post :single, params: invalid_attributes, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('status' => 'error')
      end
    end
  end

  describe 'POST #bulk' do
    let(:valid_transactions) do
      [
        { 'transaction_id' => SecureRandom.uuid, 'points' => 100, 'user_id' => SecureRandom.uuid },
        { 'transaction_id' => SecureRandom.uuid, 'points' => 200, 'user_id' => SecureRandom.uuid }
      ]
    end

    let(:invalid_transactions) do
      [
        { 'transaction_id' => nil, 'points' => nil, 'user_id' => nil }
      ]
    end

    before do
      stub_request(:post, "https://transaction.free.beeceptor.com/bulk_transaction")
        .to_return(status: 200, body: { 'transactions' => valid_transactions }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    context 'with valid transactions' do
      it 'creates new transactions' do
        expect {
          post :bulk, params: { 'transactions' => valid_transactions }, as: :json
        }.to change(Transaction, :count).by(valid_transactions.size)
      end

      it 'returns a success status' do
        post :bulk, params: { 'transactions' => valid_transactions }, as: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('status' => 'success', 'processed_count' => valid_transactions.size)
      end
    end

    context 'with invalid transactions' do
      before do
        stub_request(:post, "https://transaction.free.beeceptor.com/bulk_transaction")
          .to_return(status: 200, body: { 'transactions' => invalid_transactions }.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'does not create invalid transactions' do
        expect {
          post :bulk, params: { 'transactions' => invalid_transactions }, as: :json
        }.not_to change(Transaction, :count)
      end

      it 'returns an error status' do
        post :bulk, params: { 'transactions' => invalid_transactions }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('status' => 'error')
      end
    end
  end
end
