config = {
  host:  ENV['ELASTICSEARCH_HOST'] || "es:9200/",
}

Elasticsearch::Model.client = Elasticsearch::Client.new(config)
