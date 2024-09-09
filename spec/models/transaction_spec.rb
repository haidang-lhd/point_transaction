# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:transaction) { build(:transaction) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(transaction).to be_valid
    end

    it 'is not valid without a transaction_id' do
      transaction.transaction_id = nil
      expect(transaction).to_not be_valid
    end

    it 'is not valid without points' do
      transaction.points = nil
      expect(transaction).to_not be_valid
    end

    it 'is not valid without a user_id' do
      transaction.user_id = nil
      expect(transaction).to_not be_valid
    end

    it 'is not valid with a non-unique transaction_id' do
      create(:transaction, transaction_id: transaction.transaction_id)
      expect(transaction).to_not be_valid
    end

    it 'is not valid with non-integer points' do
      transaction.points = 'a'
      expect(transaction).to_not be_valid
    end
  end
end
