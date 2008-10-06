# =EMOBILE携帯電話

module Jpmobile::Mobile
  # ==EMOBILE携帯電話
  class Emobile < AbstractMobile
    autoload :IP_ADDRESSES, 'jpmobile/mobile/z_ip_addresses_emobile'
    autoload :DEVICE_INFO,  'jpmobile/mobile/z_device_info_emobile'

    USER_AGENT_REGEXP = %r{^emobile/|^Mozilla/5.0 \(H11T; like Gecko; OpenBrowser\) NetFront/3.4$|^Mozilla/4.0 \(compatible; MSIE 6.0; Windows CE; IEMobile 7.7\) S11HT$}
    # 対応するメールアドレスの正規表現
    MAIL_ADDRESS_REGEXP = /^.+@emnet\.ne\.jp$/
    # EMnet対応端末から通知されるユニークなユーザIDを取得する。
    def em_uid
      @request.env['HTTP_X_EM_UID']
    end
    alias :ident_subscriber :em_uid
    
    def device_id
      if @request.env["HTTP_USER_AGENT"] =~ /^emobile\/1.0.0 \(([^;]+)/
        return $1
      elsif @request.env["HTTP_USER_AGENT"] =~ /^Mozilla\/[^)]+\) (.+)$/
        return $1
      end
    end
    # 現状デバイスIDから名前をひく方法はないので
    alias :device_name :device_id
    
    def css?
      device_info_use_function?(:css)
    end
    
    def gif?
      device_info_use_function?(:gif)
    end
    
    def jpg?
      device_info_use_function?(:jpg)
    end
    
    def png?
      device_info_use_function?(:png)
    end
    
    private 
    
    def device_info_use_function?(function)
      # モバイルブラウザ以外は無条件に使えるものとみなす
      if Jpmobile::Mobile::Emobile::DEVICE_INFO[device_id].nil?
        return true
      else
        Jpmobile::Mobile::Emobile::DEVICE_INFO[device_id][function] == "1" ? true : false
      end
    end
    
  end
end
