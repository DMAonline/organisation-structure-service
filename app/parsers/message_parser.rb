class MessageParser

  def initialize body
    raise EmptyMessage unless body.present?
    @message = body
  end

  def get_system_type
    if @message["system"].present? && @message["system"]["type"].present?
      @message["system"]["type"]
    else
      raise NoSystemSpecified
    end
  end

  def get_tenant_id
    if @message["tenant"].present? && @message["tenant"]["id"].present?
      @message["tenant"]["id"]
    else
      raise NoTenantIDSpecified
    end
  end
  
  def get_data
    if @message["data"].present?
      @message["data"]
    else
      raise NoMessageData
    end
  end

end

class EmptyMessage < StandardError
end

class NoSystemSpecified < StandardError
end

class NoTenantIDSpecified < StandardError
end

class NoMessageData < StandardError
end