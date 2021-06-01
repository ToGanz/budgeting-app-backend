class TransactionSerializer
  include JSONAPI::Serializer
  attributes :description, :spending, :amount, :created_at
  belongs_to :category
end
