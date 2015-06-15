require_relative './database'

module CouchReplica
  
  class Replicator
    
    attr_reader :source_endpoint, :target_endpoint, :prefix_filter
    
    def initialize(source_endpoint:, target_endpoint:, prefix_filter: nil)
      @source_endpoint = source_endpoint
      @target_endpoint = target_endpoint
      @prefix_filter = prefix_filter
    end
    
    def start
      databases.map(&:start)
    end
    
    def stop
      databases.map(&:stop)
    end
    
    protected
    
    def replicator_url
      # Pull replication
      "#{target_endpoint}/_replicator"
    end
    
    def databases
      names = JSON.parse(RestClient.get(source_endpoint + '/_all_dbs'))
      if prefix_filter
        names.select!{|name| name =~ /^#{prefix_filter}/}
      end
      # Never include the replicator itself
      names.select!{|name| name != '_replicator' && name != '_users'}
      names.map{|n| Database.new(n,
        source_endpoint: source_endpoint,
        target_endpoint: target_endpoint,
        replicator_url: replicator_url
      )}
    end
    
  end
  
end
