# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    sequence(:transaction_id) { |n| "transaction_#{n}" }
    points { 100 }
    user_id { "user_#{rand(1..1000)}" }
  end
end
