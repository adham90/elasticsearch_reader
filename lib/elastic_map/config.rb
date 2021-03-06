# frozen_string_literal: true

module ElasticMap
  # ElasticMap core configuration.
  class Config
    include Singleton

    attr_accessor :settings, :logger,

                  # Where ElasticMap expects to find index definitions
                  # within a Rails app folder.
                  :indices_path

    def self.delegated
      public_instance_methods -
        superclass.public_instance_methods -
        Singleton.public_instance_methods
    end

    def initialize
      @settings = {}
      @indices_path = 'app/indices'
    end

    # ElasticMap configurations. There is two ways to set it up:
    # use `ElasticMap.settings=` method or, create
    # `config/elastic_map.yml` file (ERB supported), this file
    # support All Elasticsearch::Client options supports.
    #
    #        test:
    #          host: 'localhost:9250'
    #
    def configuration
      yaml_settings.merge(settings.deep_symbolize_keys).tap do |configuration|
        configuration[:logger]         = logger if logger
        configuration[:indices_path] ||= indices_path
      end
    end

    private

    def yaml_settings
      @yaml_settings ||= begin
        file = File.join(Dir.pwd, 'config', 'elastic_map.yml')

        if File.exist?(file)
          yaml = ERB.new(File.read(file)).result
          hash = YAML.safe_load(yaml)
          hash&.try(:deep_symbolize_keys)
        end
      end || {}
    end
  end
end
