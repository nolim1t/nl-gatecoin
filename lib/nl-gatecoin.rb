require 'base64'
require 'cgi'
require 'openssl'
require 'json'
require 'digest/md5'
require 'httparty'

class Gatecoin
    include HTTParty
    base_uri 'https://api.gatecoin.com'

    def initialize(options={})
        @apisecret = ENV['gc_private_key']
        @apikey = ENV['gc_public_key']
    end

    def method_missing(method_sym, *arguments, &block)
        convert_undercores_to_slashes = method_sym.to_s.gsub('_','/')
        method_type = convert_undercores_to_slashes.split('/')[0]
        convert_undercores_to_slashes = convert_undercores_to_slashes.gsub(method_type + '/','')

        nonce = (Time.now).to_f.to_s # generate a new one each time
        if method_type.downcase == 'get' then
          content_type = ''
        elsif method_type.downcase == 'post'
          content_type = 'multipart/form-data'
        elsif method_type.downcase == 'pubget'
          content_type = ''
        else
          # No content type
          content_type = ''
        end
        @parameters = ''
        if arguments.length == 1 then
          if arguments[0].kind_of? Hash
            arguments[0].each{|key, value|
              if @parameters.length > 0 then
                @parameters = "#{@parameters}&#{key.capitalize}=#{CGI::escape(value)}"
              else
                @parameters = "#{key}=#{CGI::escape(value)}"
              end
            }
          end
        end
        if @parameters.length > 0 then
          convert_undercores_to_slashes = "#{convert_undercores_to_slashes}?#{@parameters}"
        end
        encode_message = (method_type.upcase + 'https://www.gatecoin.com/api/' + convert_undercores_to_slashes + content_type + nonce).downcase
        if @apisecret.length > 0 and @apikey.length > 0 then
          ssl_sign = OpenSSL::HMAC.digest('sha256', @apisecret, encode_message)
          ssl_sign_encoded = Base64.encode64(ssl_sign).to_s.gsub("\n",'')
          if method_type.downcase == "get" then
            self.class.get('/' + convert_undercores_to_slashes, :headers => {'Accept' => 'application/json', 'Content-Type' => 'application/json', 'API_PUBLIC_KEY' => @apikey , 'API_REQUEST_SIGNATURE' => ssl_sign_encoded, 'API_REQUEST_DATE' => nonce}).to_json
          elsif method_type.downcase == "post"
            self.class.post('/' + convert_undercores_to_slashes, :body => @parameters.to_s, :headers => {'Accept' => 'application/json', 'Content-Type' => content_type, 'API_PUBLIC_KEY' => @apikey , 'API_REQUEST_SIGNATURE' => ssl_sign_encoded, 'API_REQUEST_DATE' => nonce}).to_json
          elsif method_type.downcase == "pubget"
            self.class.get('/Public/' + convert_undercores_to_slashes, :headers => {'Accept' => 'application/json', 'Content-Type' => 'application/json'}).to_json
          else
            "Unsupported method"
          end
        else
          "Invalid API key and secret"
        end
    end
end
