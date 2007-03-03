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
    def ident; return nil; end

    # IPアドレスデータ
    IP_ADDRESSES = nil
    
    # 当該キャリアのIPアドレス帯域からのアクセスであれば +true+ を返す。
    # そうでなければ +false+ を返す。
    # IP空間が定義されていない場合は +nil+ を返す。
    def valid_ip?
      addrs = self.class::IP_ADDRESSES
      return nil if addrs.nil?
      remote = IPAddr.new(@request.remote_ip)
      addrs.each do |s|
        return true if IPAddr.new(s.chomp).include?(remote)
      end
      return false
    end

    # ブラウザ画面の幅を返す。
    def browser_width; nil; end
    # ブラウザ画面の高さを返す。
    def browser_height; nil; end
    # カラー端末の場合は +true+、白黒端末の場合は +false+ を返す。
    def display_color?; nil; end
    # 端末の色数(白黒端末の場合は階調数)を返す。
    def display_depth; nil; end


    private
    # リクエストのパラメータ。
    def params
      @request.parameters
    end
  end
end
