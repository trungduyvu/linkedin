require 'cgi'

module LinkedIn

  class Client
    include Helpers::Request
    include Api::QueryMethods
    include Api::UpdateMethods
    include Search

    attr_reader :consumer_token, :consumer_secret, :consumer_options

    def initialize(ctoken=LinkedIn.token, csecret=LinkedIn.secret, oauth_version=1, options={})
      @consumer_token   = ctoken
      @consumer_secret  = csecret
      @consumer_options = options
      if oauth_version == 1
          self.class.send(:include, Helpers::Authorization)
      elsif oauth_version == 2
        self.class.send(:include, Helpers::Authorization2)
      end
    end

    #
    # def current_status
    #   path = "/people/~/current-status"
    #   Crack::XML.parse(get(path))['current_status']
    # end
    #
    # def network_statuses(options={})
    #   options[:type] = 'STAT'
    #   network_updates(options)
    # end
    #
    # def network_updates(options={})
    #   path = "/people/~/network"
    #   Network.from_xml(get(to_uri(path, options)))
    # end
    #
    # # helpful in making authenticated calls and writing the
    # # raw xml to a fixture file
    # def write_fixture(path, filename)
    #   file = File.new("test/fixtures/#{filename}", "w")
    #   file.puts(access_token.get(path).body)
    #   file.close
    # end

  end

end
