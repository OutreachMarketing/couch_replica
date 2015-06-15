require 'thor'

require_relative './replicator'

module CouchReplica
  
  class CLI < Thor
    
    class_option :"source-host", aliases: "-s", desc: "The host of the couchdb server acting as the source"
    class_option :"source-port", aliases: "-sp", default: 5984, desc: "The port of the couchdb server acting as the source"
    class_option :"target-host", aliases: "-t", desc: "The host of the couchdb server acting as the target"
    class_option :"target-port", aliases: "-tp", default: 5984, desc: "The port of the couchdb server acting as the target"
    class_option :"prefix-filter", aliases: "-f", desc: "Only replicate databases which match this prefix"
    
    desc "start", "start replication"
    def start
      instance.start
    end
    
    desc "stop", "stop replication"
    def stop
      instance.stop
    end
    
    private
    
    def instance
      Replicator.new(
        source_endpoint: "http://#{options['source-host']}:#{options['source-port']}",
        target_endpoint: "http://#{options['target-host']}:#{options['target-port']}",
        prefix_filter: options["prefix-filter"]
      )
    end
    
    
  end
  
end
