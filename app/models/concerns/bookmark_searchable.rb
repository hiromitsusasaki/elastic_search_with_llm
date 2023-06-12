module BookmarkSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name "es_bookmarks_#{Rails.env}"

    settings do
      mappings dynamic: 'false' do
        indexes :id, type: 'integer'
        indexes :title, type:'text', analyzer: 'kuromoji'
        indexes :description, type:'text', analyzer: 'kuromoji'
        indexes :url, type:'text'
        indexes :created_in_source_at, type:'date'
        indexes :updated_in_source_at, type:'date'
        indexes :created_at, type:'date'
        indexes :updated_at, type:'date'
      end
    end

    def as_indexed_json(*)
      attributes
        .symbolize_keys
        .slice(:id, :title, :description, url, created_in_source_at, updated_in_source_at, created_at, updated_at)
    end
  end

  class_methods do
    def create_index!
      client = __elasticsearch__.client
      client.indices.delete index: self.index_name rescue nil
      client.indices.create(index: self.index_name,
                            body: {
                                settings: self.settings.to_hash,
                                mappings: self.mappings.to_hash
                            })
    end
  end
end
