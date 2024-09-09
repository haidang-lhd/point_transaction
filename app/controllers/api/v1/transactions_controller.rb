# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def single
        transaction_data = fetch_transaction_data
        transaction = Transaction.new(transaction_data)

        if transaction.save
          render json: { status: 'success', transaction_id: transaction.transaction_id },
                 status: :created
        else
          render json: { status: 'error', errors: transaction.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def bulk
        bulk_transactions = bulk_transaction_params['transactions']

        transactions = bulk_transactions.map do |transaction_data|
          Transaction.new(transaction_data)
        end

        valid_transactions = transactions.select(&:valid?)
        invalid_transactions = transactions.reject(&:valid?)

        if invalid_transactions.any?
          render json: { status: 'error', errors: invalid_transactions.map do |t|
            t.errors.full_messages
          end.flatten }, status: :unprocessable_entity
        else
          Transaction.import(valid_transactions)
          render json: { status: 'success', processed_count: valid_transactions.size }, status: :ok
        end
      end

      private

      def fetch_transaction_data
        transaction_id = SecureRandom.uuid
        points = 100
        user_id = SecureRandom.uuid
        uri = URI("https://transaction.free.beeceptor.com/single_transaction?transaction_id=#{transaction_id}&points=#{points}&user_id=#{user_id}")
        response = Net::HTTP.get(uri)
        JSON.parse(response)
      end

      def bulk_transaction_params
        num_transactions = 5
        transactions = Array.new(num_transactions) do
          { 'transaction_id' => SecureRandom.uuid, 'points' => rand(100..500), 'user_id' => SecureRandom.uuid }
        end

        uri = URI('https://transaction.free.beeceptor.com/bulk_transaction')
        response = Net::HTTP.post(uri, { 'transactions' => transactions }.to_json, 'Content-Type' => 'application/json')
        JSON.parse(response.body)
      end
    end
  end
end
