require 'ipaddr'

module Jpmobile::Mobile
  # 携帯電話の抽象クラス。
  class AbstractMobile
    def initialize(request)
      @request = request
    end

    # 対応するuser-agentの正規表現
    USER_AGENT_REGEXP = nil

    # 緯度経度があれば Position のインスタンスを返す。
    def position; return nil; end

    # 契約者又は端末を識別する文字列があれば返す。
    def ident; ident_subscriber || ident_device; end
    # 契約者を識別する文字列があれば返す。
    def ident_subscriber; nil; end
    # 端末を識別する文字列があれば返す。
    def ident_device; nil; end

    # 当該キャリアのIPアドレス帯域からのアクセスであれば +true+ を返す。
    # そうでなければ +false+ を返す。
    # IP空間が定義されていない場合は +nil+ を返す。
    def valid_ip?
      return @__valid_ip_p if @__valid_ip_p
      addrs = nil
      begin
        addrs = self.class::IP_ADDRESSES
      rescue NameError => e
        return @__valid_ip_p = nil
      end
      remote = IPAddr.new(@request.remote_addr)
      @__valid_ip_p = addrs.any? {|ip| ip.include? remote }
    end
    
    # 画面情報を +Display+ クラスのインスタンスで返す。
    def display
      @__displlay ||= Jpmobile::Display.new
    end

    # クッキーをサポートしているか。
    def supports_cookie?
      return false
    end

    private
    # リクエストのパラメータ。
    def params
      if @request.respond_to? :parameters
        @request.parameters
      else
        @request.params
      end
    end
  end
end
