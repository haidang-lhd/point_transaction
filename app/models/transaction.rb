# == Schema Information
#
# Table name: transactions
#
#  id             :bigint           not null, primary key
#  transaction_id :string
#  points         :integer
#  user_id        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# frozen_string_literal: true

class Transaction < ApplicationRecord
  validates :transaction_id, :points, :user_id, presence: true
  validates :transaction_id, uniqueness: true
  validates :points, numericality: { only_integer: true }
end
