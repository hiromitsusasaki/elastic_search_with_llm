class GoogleSearchResult
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :url, :string
  attribute :description, :string
end
