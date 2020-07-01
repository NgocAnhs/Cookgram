# Assuming you can set the BONSAI_URL variable:
Elasticsearch::Model.client = Elasticsearch::Client.new url: ENV['BONSAI_URL']