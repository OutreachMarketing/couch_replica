require 'rest-client'
require 'json'
require 'logger'

module CouchReplica
  
  class Database
    
    attr_reader :name, :source_endpoint, :target_endpoint, :replicator_url
    
    def initialize(name, source_endpoint:, target_endpoint:, replicator_url:)
      @name = name
      @source_endpoint = source_endpoint
      @target_endpoint = target_endpoint
      @replicator_url = replicator_url
    end
    
    def start
      doc = status
      if doc
        logger.info "Replication already started from #{source_url} to #{target_url}"
        return
      end
      
      res = RestClient.post replicator_url, {
        _id: replicator_id,
        source: source_url,
        target: target_url,
        continuous: true,
        create_target: true
      }.to_json, content_type: :json
      
      logger.info "Started push replication from #{source_url} to #{target_url}"
      
      res
    end
    
    def stop
      doc = status
      
      if !doc
        logger.info "No replication found from #{source_url} to #{target_url}"
        return
      end
      
      res = RestClient.delete doc_url, params: {rev: doc['_rev']}
      logger.info "Stopped replication from #{source_url} to #{target_url}"
      res
    end
    
    def status
      JSON.parse RestClient.get doc_url
    rescue RestClient::ResourceNotFound
      nil
    end
    
    def doc_url
      "#{replicator_url}/#{replicator_id}"
    end
    
    def replicator_id
      "pull-#{name}"
    end
    
    def source_url
      "#{source_endpoint}/#{name}"
    end
    
    def target_url
      "#{target_endpoint}/#{name}"
    end
    
    def logger
      @logger ||= Logger.new(STDOUT)
    end
    
  end
  
end
